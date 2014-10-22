function [ g ] = gaussian2dconv( im, sigma )
%GAUSSIAN2DCONV Summary of this function goes here
%   Detailed explanation goes here
[N,M] = size(im);
[x, y]=meshgrid(1:M, 1:N);
x = x - ceil(M/2) - 1;
y = y - ceil(N/2) - 1;
gaussian = exp(-(x.^2 + y.^2) / (2 * sigma^2)) / (2*pi*sigma^2);
g = real(ifft2(fft2(fftshift(gaussian)).*fft2(im)));
end