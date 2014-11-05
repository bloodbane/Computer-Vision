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
xp = 0:bin_size:fv_epl(size(fv_epl,2));
epl_m = hist(fv_epl,xp);
%% compute errors scattered-networks
esl = es_compute( im0, im1, d0, ol, t_size );
esl_array = sort(esl(:));
fv_esl = esl_array(~isinf(esl_array))';
figure
xs = 0:bin_size:fv_esl(size(fv_esl,2));
esl_m = hist(fv_esl,xs);
%%
persentage = round(.95*size(fv_epl,2));
% threshold = epl_array(persentage);
nfv_epl = fv_epl(1,1:persentage);
nfv_esl = fv_esl(1,1:persentage);
xph = 0:bin_size:nfv_epl(size(nfv_epl,2))+bin_size;
epl_hist = hist(nfv_epl,xph)/size(nfv_epl,2);
figure
bar(xph,epl_hist)
xsh = 0:bin_size:nfv_esl(size(nfv_esl,2))+bin_size;
esl_hist = hist(nfv_esl,xsh)/size(nfv_esl,2);
figure
bar(xsh,esl_hist)
%% mean error and standard deviation
[epl_me, epl_sd] = mesd_compute(nfv_epl, xph, epl_hist, epl_m);
[esl_me, esl_sd] = mesd_compute(nfv_esl, xsh, esl_hist, esl_m);
%% rd
r = randi([-2,1],rows,colums)+rand(size(d0),'like',d0);
rd_d0 = d0 + r;
rd_epl = ep_compute( im0, im1, rd_d0, ol, t_size );
rd_epl_array = sort(rd_epl(:));
rd_fv_epl = rd_epl_array(~isinf(rd_epl_array))';
rd_esl = es_compute( im0, im1, rd_d0, ol, t_size );
rd_esl_array = sort(rd_esl(:));
rd_fv_esl = rd_esl_array(~isinf(rd_esl_array))';
rd_nfv_epl = rd_fv_epl(1,1:persentage);
rd_nfv_esl = rd_fv_esl(1,1:persentage);
rd_epl_m = hist(rd_fv_epl,xp);
rd_esl_m = hist(rd_fv_esl,xs);
rd_xph = 0:bin_size:rd_nfv_epl(size(rd_nfv_epl,2))+bin_size;
rd_epl_hist = hist(rd_nfv_epl,rd_xph)/size(rd_nfv_epl,2);
rd_xsh = 0:bin_size:rd_nfv_esl(size(rd_nfv_esl,2))+bin_size;
rd_esl_hist = hist(rd_nfv_esl,rd_xsh)/size(rd_nfv_esl,2);

[epl_me_rd, epl_sd_rd] = mesd_compute(rd_nfv_epl, rd_xph, rd_epl_hist, rd_epl_m);
[esl_me_rd, esl_sd_rd] = mesd_compute(rd_nfv_esl, rd_xsh, rd_esl_hist, rd_esl_m);

toc;
    