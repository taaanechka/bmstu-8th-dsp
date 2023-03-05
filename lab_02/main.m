% ЛР2: Изучение свойств ДПФ и БПФ.
% Прямоугольный импульс и сигнал Гаусса
function main
    n = input('Введите количество точек: ');
    step = input('Введите шаг: ');

    xMax = step * (n - 1) / 2;

    xArr = -xMax:step:xMax;
    xNum = 0:length(xArr) - 1;

    % Исходный сигнал
    yRectInitialArr = rectPulse(xArr);
    yGaussInitialArr = gaussSignal(xArr);

    % БПФ (с эффектом близнецов)
    tic
    yRectFFT = fft(yRectInitialArr);
    yGaussFFT = fft(yGaussInitialArr);
    toc

    % Устранение эффекта близнецов
    yRectFFT_NT = fftshift(yRectFFT);
    yGaussFFT_NT = fftshift(yGaussFFT);

    % ДПФ (с эффектом близнецов)
    tic
    yRectDFT = dft(yRectInitialArr);
    yGaussDFT = dft(yGaussInitialArr);
    toc

    % Устранение эффекта близнецов
    yRectDFT_NT = fftshift(yRectDFT);
    yGaussDFT_NT = fftshift(yGaussDFT);

    figure(1);
    drawFigure(1, xNum, yRectFFT, yRectFFT_NT, 'БПФ', 'Прямоугольный сигнал');
    drawFigure(2, xNum, yGaussFFT, yGaussFFT_NT, 'БПФ', 'Гаусс');
    drawFigure(3, xNum, yRectDFT, yRectDFT_NT, 'ДПФ', 'Прямоугольный сигнал');
    drawFigure(4, xNum, yGaussDFT, yGaussDFT_NT, 'ДПФ', 'Гаусс');
end


function y = rectPulse(x)
    c = 2;
    y = zeros(size(x));

    y(abs(x) < c) = 1;
end


function y = gaussSignal(x)
    sigma = 4;

    y = exp(-(x / sigma).^2);
end


function xArr = dft(x)
    N = length(x);
    xArr = 0:N - 1;
    temp = -2 * pi * sqrt(-1) * xArr / N;
    for i = 1:length(xArr)
        xArr(i) = 0;
        for j = 1:N
            xArr(i) = xArr(i) + x(j) * exp(temp(i) * j);
        end
    end
end


function drawFigure(ind, xNum, y, yImproved, nameAlg, namePulse)
    draw(ind, xNum, y, yImproved, @(x) abs(x), nameAlg, namePulse);
end


function draw(ind, xNum, y, yImproved, f, nameAlg, namePulse)
    subplot(2, 2, ind);
    N = length(xNum);
    plot(xNum, f(y) / N, xNum, f(yImproved) / N);
    title([nameAlg, ' ', namePulse]);
    legend('С эффектом близнецов', 'Без эффекта близнецов');
end
