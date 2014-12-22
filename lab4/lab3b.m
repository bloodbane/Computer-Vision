close all;
clear all;
tic;

t_size = 32;
gap = 8;

addpath maxflow/;
dir = '../im/';
object = 'piano';
d0 = parsePfm(strcat(dir,object,'0-disp-perf.pfm'));
d1 = parsePfm(strcat(dir,object,'1-disp-perf.pfm'));
im0 = im2double(imread(strcat(dir,object,'0-perf.png')));
im1 = im2double(imread(strcat(dir,object,'1-perf.png')));
im0 = rgb2gray(im0);
im1 = rgb2gray(im1);
rows = size(im0,1);
colums = size(im0,2);
%% compute disparity range
disp('Computing First Stero Algorithm');
range = gap*2+1;

thetas = [0, pi/6,pi/3,pi/2,2*pi/3,5*pi/6];
sigmas = [1, 3, 6];
sigma_num = size(sigmas,2);
theta_num = size(thetas,2);

s0_l = gaussian2dconv(im0,6);
s0_r = gaussian2dconv(im1,6);
s1_l = zeros([size(im0,1) size(im0,2) sigma_num theta_num]);
s1_r = zeros([size(im1,1) size(im1,2) sigma_num theta_num]);

[cost_range, dis] = stero1(im0,im1,d0,gap,t_size);
figure;
imagesc(d0);
figure;
imagesc(dis); 

toc;
%% 
tic;

new_height = size(cost_range,1);
new_width = size(cost_range,2);
cost = matching_cost(cost_range);
disparity = zeros(new_height, new_width);
flow = zeros(new_height, 1);
for k = 1 : new_height  % row by row
% matching_error_normalized=normalize_matching_error(matching_error_black{23,1}); % % normalize the error
    matching_error = cost{k, 1};
    disp(['Building graph: ', num2str(k)]);
    [disparity(k, :), flow(k)] = compute_line_cut(matching_error);
end

disparity_show = disparity.*gap;
occlusion = ones(size(disparity_show));
figure;
imagesc(disparity_show); 

toc;
    