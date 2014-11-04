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
xpl = 0:bin_size:nfv_epl(size(nfv_epl,2));
ep_hist = hist(nfv_epl,xpl)/size(nfv_epl,2);
figure
bar(xpl,ep_hist)
xsl = 0:bin_size:nfv_esl(size(nfv_esl,2));
es_hist = hist(nfv_esl,xsl)/size(nfv_esl,2);
figure
bar(xsl,es_hist)
%%
epl_me = 0;
epl_me2 = 0;
for i=1:size(nfv_epl,2)
    pr = 0;
    for j=1:size(xpl,2)
        if xpl(j)>nfv_epl(i)
            pr = ep_hist(j-1);
            break;
        end
    end
    epl_me = epl_me + nfv_epl(i)*pr;
    epl_me2 = epl_me2 + nfv_epl(i)^2*pr;
end

esl_me = 0;
esl_me2 = 0;
for i=1:size(nfv_esl,2)
    pr = 0;
    for j=1:size(xsl,2)
        if xsl(j)>nfv_esl(i)
            pr = es_hist(j-1);
            break;
        end
    end
    esl_me = esl_me + nfv_esl(i)*pr;
    esl_me2 = esl_me2 + nfv_esl(i)^2*pr;
end
epl_sd = sqrt(abs(epl_me2-epl_me^2));
esl_sd = sqrt(abs(esl_me2-esl_me^2));
%% rd
% r = randi([-2,2],rows,colums);
% rd_d0 = d0 + r;
% [rd_ol, rd_im_new] = ol_compute(rd_d0,d1,im0);
% rd_epl = ep_compute( im0, im1, rd_d0, rd_ol, t_size );
% rd_epl_array = sort(rd_epl(:));
% rd_fv_epl = rd_epl_array(~isinf(rd_epl_array))';
% rd_esl = es_compute( im0, im1, rd_d0, rd_ol, t_size );
% rd_esl_array = sort(rd_esl(:));
% rd_fv_esl = rd_esl_array(~isinf(rd_esl_array))';
% rd_nfv_epl = rd_fv_epl(1,1:persentage);
% rd_nfv_esl = rd_fv_esl(1,1:persentage);
% rd_xpl = 0:bin_size:rd_nfv_epl(size(rd_nfv_epl,2));
% rd_ep_hist = hist(rd_nfv_epl,rd_xpl)/size(rd_nfv_epl,2);
% rd_xsl = 0:bin_size:rd_nfv_esl(size(rd_nfv_esl,2));
% rd_es_hist = hist(rd_nfv_esl,rd_xsl)/size(rd_nfv_esl,2);
% epl_me_rd = 0;
% epl_me2_rd = 0;
% for i=1:size(rd_nfv_epl,2)
%     pr = 0;
%     for j=1:size(rd_xpl,2)
%         if rd_xpl(j)>rd_nfv_epl(i)
%             pr = rd_ep_hist(j-1);
%             break;
%         end
%     end
%     epl_me_rd = epl_me_rd + rd_nfv_epl(i)*pr;
%     epl_me2_rd = epl_me2_rd + rd_nfv_epl(i)^2*pr;
% end
% esl_me_rd = 0;
% esl_me2_rd = 0;
% for i=1:size(rd_nfv_esl,2)
%     pr = 0;
%     for j=1:size(rd_xsl,2)
%         if rd_xsl(j)>rd_nfv_esl(i)
%             pr = rd_es_hist(j-1);
%             break;
%         end
%     end
%     esl_me_rd = esl_me_rd + rd_nfv_esl(i)*pr;
%     esl_me2_rd = esl_me2_rd + rd_nfv_esl(i)^2*pr;
% end
% epl_sd_rd = sqrt(abs(epl_me2_rd-epl_me_rd^2));
% esl_sd_rd = sqrt(abs(esl_me2_rd-esl_me_rd^2));

toc;
    