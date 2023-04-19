function main()
pkg load image;

I = double(imread('bimage1.bmp')) / 255;    % Исходное

var_noise = 0.0006;
estimated_nsr = var_noise / (var(I(:)) - var_noise);

PSF = fspecial('motion', 35, 205);
J1 = deconvwnr(I, PSF, estimated_nsr);    % Восстановленное

figure;
subplot(1,2,1), imshow(I);
title('Source image');

subplot(1,2,2), imshow(J1);
title('Recovered image');
end
