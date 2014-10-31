tic;
close all;
clear all;

bin_size = 0.0005;
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
[ol,im_new] = ol_compute(d0,d1,im0);
% figure
% imshow(im_new);
% % h = imshow(ol);
% str = sprintf('piano0-occlussion.jpg');
% title(str);
%% compute errors pixel-wise
epl = ep_compute( im0, im1, d0, ol, t_size );
epl_array = sort(epl(:));
fv_epl = epl_array(~isinf(epl_array))';
figure
x = 0:bin_size:fv_epl(size(fv_epl,2));
hist(fv_epl,x);
%% compute errors scattered-networks
esl = es_compute( im0, im1, d0, ol, t_size );
esl_array = sort(esl(:));
fv_esl = esl_array(~isinf(esl_array))';
figure
x = 0:bin_size:fv_esl(size(fv_esl,2));
hist(fv_esl,x);
%%
persentage = round(.95*size(fv_epl,2));
% threshold = epl_array(persentage);
nfv_epl = fv_epl(1,1:persentage);
nfv_esl = fv_esl(1,1:persentage);
x = 0:bin_size:nfv_epl(size(nfv_epl,2));
ep_hist = hist(nfv_epl,x)/size(nfv_epl,2);
figure
bar(x,ep_hist)
x = 0:bin_size:nfv_esl(size(nfv_esl,2));
es_hist = hist(nfv_esl,x)/size(nfv_epl,2);
figure
bar(x,es_hist)
toc;
    