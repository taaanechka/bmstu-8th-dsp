% ЛР1: Изучение дискретизации сигналов.
% Прямоугольный импульс и сигнал Гаусса
function main
    n = input('Введите количество точек: ');
    step = input('Введите шаг: ');

    xMax = step * (n - 1) / 2;
    xArr = -xMax:step:xMax;
    x0Arr = -xMax:0.01:xMax;

    % Исходный сигнал
    initialYRectArr = computeRectPulse(x0Arr);
    initialYGaussArr = computeGaussSignal(x0Arr);

    % Дискретизация сигнала
    discreteYRectArr = computeRectPulse(xArr);
    discreteYGaussArr = computeGaussSignal(xArr);

    % Восстановление сигнала по формуле Котельникова
    restoredYRectArr = zeros(1, length(x0Arr));
    restoredYGaussArr = zeros(1, length(x0Arr));

    for i = 1:length(x0Arr)
        for j = 1:n
            % octave function sinc (x): Return sin (pi*x) / (pi*x).
            tmp = sinc((x0Arr(i) - xArr(j)) / step);

            restoredYRectArr(i) += discreteYRectArr(j) * tmp;
            restoredYGaussArr(i) += discreteYGaussArr(j) * tmp;
        end
    end

    figure;

    subplot(2,1,1);
    title('Прямоугольный импульс');
    hold on;
    grid on;
    plot(x0Arr, initialYRectArr, 'b');
    plot(x0Arr, restoredYRectArr, 'k');
    plot(xArr, discreteYRectArr, '.r');
    legend('Исходный', 'Восстановленный', 'Дискретный');

    subplot(2,1,2);
    title('Сигнал Гаусса');
    hold on;
    grid on;
    plot(x0Arr, initialYGaussArr, 'b');
    plot(x0Arr, restoredYGaussArr, 'k');
    plot(xArr, discreteYGaussArr, '.r');
    legend('Исходный', 'Восстановленный', 'Дискретный');

end


function [y] = computeRectPulse(x)
    c = 2;
    y = zeros(size(x));

    y(abs(x) < c) = 1;
end


function [y] = computeGaussSignal(x)
    sigma = 4;

    y = exp(-(x / sigma).^2);
end
