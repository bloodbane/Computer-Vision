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
[ol,im_new] = ol_compute(d0,d1,im0);
% figure
% imshow(im_new);
% % h = imshow(ol);
% str = sprintf('piano0-occlussion.jpg');
% title(str);
%% compute errors pixel-wise
epl = ep_compute( im0, im1, d0, ol, t_size );

epl_array = sort(epl(:));
for i = 0:size(epl_array,1)
    if epl_array(i+1,1) == inf;
        max_point = i;
        break;
    end
end
        
persentage = round(.92*size(epl,1)*size(epl,2));
threshold = epl_array(persentage);


%%
bin_size = 0.005;
% max = ceil(threshold/bin_size);
% x = bin_size : bin_size : max*bin_size;
% y = zeros(1,max);
% for i = 1:persentage
%     for j= 0:bin_size:threshold+bin_size
%         if epl_array(i,1)<j
%             y(1,floor(j/bin_size)) = y(1,floor(j/bin_size)) + 1;
%             break
%         end
%     end  
% end
figure
% bar(x,y);
x = 0:bin_size:epl_array(max_point);
hist(epl_array(1:max_point,1)',x);
toc;
    