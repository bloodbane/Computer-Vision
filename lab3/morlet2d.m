function output = morlet2d(sigma, theta)
% morlet2d - returns the matrix of a morlet filter, meant for convolution via fourier
% transform
% N,M - size of the filter
% 

%% init
M = 32;
N= 32;
[x, y]=meshgrid(1:M, 1:N);
x = x - ceil(M/2) - 1;
y = y - ceil(N/2) - 1;
%theta = pi/2-theta;
%% calc
% using 4 sigma for xi
xi = 4*sigma;
gaussian = exp(-(x.^2 + y.^2) / 2 / sigma^2);
dir = x * cos(theta) + y * sin(theta);
occi = exp(1i * dir * 2 * pi / xi);

%% regularization
%c2 = sum(occi(:)) / sum(gaussian(:));

% analytical solution for c2
c2 = exp(-2*pi*pi*sigma*sigma/xi/xi);

output = (occi - c2) .* gaussian;
output = output / sqrt(sum((real(output(:)).^2 + imag(output(:)).^2)));
end