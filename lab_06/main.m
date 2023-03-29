function main()
% Initial state
sigma = 0.5;
mult = 5;
step = 0.005;
t = -mult:step:mult;

% Impulse
x0 = gaussian_impulse(t, sigma);

% Gaussian noise generation
NA = 0;
NS = 0.05;
n1 = normrnd(NA, NS, [1 length(x0)]);
x1 = x0 + n1;

% Impulsive noise generation
count = 7;
M = 0.4;
n2 = impulsive_noise(length(x0), count, M);
x2 = x0 + n2;

% Filtering
y1_wiener = wiener_filter(fft(x1), fft(n1));
y2_wiener = wiener_filter(fft(x2), fft(n2));

y1_reject = reject_filter(fft(x1), fft(n1));
y2_reject = reject_filter(fft(x2), fft(n2));

figure;

subplot(2,2,1);
title('Gaussian signal filtering Wiener');
hold on;
grid on;
plot(t, x0, 'b');
plot(t, x1, 'r');
plot(t, ifft(fft(x1).*y1_wiener), 'g');
legend('Initial', 'With noise', 'Filtering');

subplot(2,2,3);
title('Impulsive signal filtering Wiener');
hold on;
grid on;
plot(t, x0, 'b');
plot(t, x2, 'r');
plot(t, ifft(fft(x2).*y2_wiener), 'g');
legend('Initial', 'With noise', 'Filtering');

subplot(2,2,2);
title('Gaussian signal filtering Reject');
hold on;
grid on;
plot(t, x0, 'b');
plot(t, x1, 'r');
plot(t, ifft(fft(x1).*y1_reject), 'g');
legend('Initial', 'With noise', 'Filtering');

subplot(2,2,4);
title('Impulsive signal filtering Reject');
hold on;
grid on;
plot(t, x0, 'b');
plot(t, x2, 'r');
plot(t, ifft(fft(x2).*y2_reject), 'g');
legend('Initial', 'With noise', 'Filtering');
end

% Gaussian impulse
function y = gaussian_impulse(x, s)
    y = exp(-(x / s).^2);
end

% Impulsive noise
function y = impulsive_noise(size, N, mult)
    step = floor(size / N);
    y = zeros(1, size);
    for i = 1:floor(N / 2)
        y(round(size / 2) + i * step) = mult * (0.5 + rand);
        y(round(size / 2) - i * step) = mult * (0.5 + rand);
    end
end

% Wiener filter
function y = wiener_filter(x, n)
    y = 1 - (n./ x).^2;
end

% Reject filter
function y = reject_filter(x, n)
    y = zeros(1, length(x));
    for i = 1:length(x)
        if (abs(x(i)) - abs(n(i))) > 1
            y(i) = 1;
        else
            y(i) = 0;
        end
    end
end
