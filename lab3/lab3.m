tic;
close all;
clear all;

dir = 'im/';
d0 = parsePfm(strcat(dir,'piano-disp0-perf.pfm'));
d1 = parsePfm(strcat(dir,'piano-disp1-perf.pfm'));
im0 = im2double(imread(strcat(dir,'piano0-perf.png')));
im1 = im2double(imread(strcat(dir,'piano1-perf.png')));
im0 = rgb2gray(im0);
im1 = rgb2gray(im1);
rows = size(im0,1);
colums = size(im0,2);
t_size = 32;
%% compute occlussion
% figure
% imagesc(d0);
% colorbar;
[ol,im0] = ol_compute(d0,d1,im0);
% figure
% imshow(im0);
% % h = imshow(ol);
% str = sprintf('piano0-occlussion.jpg');
% title(str);
%% compute errors pixel wise
epl = ep_compute( im0, im1, d0, ol, t_size );

epl_array = sort(epl(:));
persentage = round(.97*size(epl,1)*size(epl,2));
threshold = epl_array(persentage);

%%
bin_size = 0.05;
x = ceil(threshold/0.05);
for i = 1:persentage
    
end

toc;
    