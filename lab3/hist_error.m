function [ h,centers, avg, stddev, dt ] = hist_error(t1, t2, crop, mask)
%HIST_ERROR Takes t1, t2 - two set of representation of the image,
% mask - 0 reprensts data to throw away
%h=0;centers=0;avg=0;stddev=0;
channels = size(t1,3);
count = size(t1,4);
mask = repmat(~isnan(mask), [1 1 channels size(t1,4)]);

t1 = t1(mask);
t1 = reshape(t1, [channels numel(t1)/(channels*count) count]);
t2 = t2(mask);
t2 = reshape(t2, [channels numel(t1)/(channels*count) count]);
%size((t1-t2).^2)
dt = min(sum(abs(t1 - t2).^2,1),[],3);
clear('t1');
clear('t2');
fprintf('dt calculated\n');
%dt = min(abs(t1 - t2).^2,[],1);
%size(dt)
dt = dt(dt<crop);
%size(dt)

[h,centers] = hist(dt,20);
%centers = bins;
%size(centers)
%size(h)
%centers = centers';
avg = sum(h .* centers) / sum(h);
stddev = sqrt(sum(h .* centers.^2) / sum(h) - avg^2);
end