function [r,i] = morlet2dconv(im,  sigma, theta)
%MORLET2DCONV - filter im with a morlet kernel
% use fft2 for speed

morlet = morlet2d(sigma,theta);
%fim = fft2(im);
%result = ifft2(fim .* fft2(morlet));
r = conv2(im, real(morlet), 'same');
i = conv2(im, imag(morlet), 'same');
end