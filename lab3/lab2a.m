tic;
% close all;
% clear all;
% 
% % dir = 'Aloe/';
% im1 = im2double((imread(strcat(dir,'view1.png'))));
% im2 = im2double((imread(strcat(dir,'view5.png'))));
% d1 = double(imread(strcat(dir,'disp1.png')));
% d2 = double(imread(strcat(dir,'disp5.png')));

im1 = im2double((imread(strcat('Aloe_view1.png'))));
im2 = im2double((imread(strcat('Aloe_view5.png'))));
d1 = double(imread(strcat('Aloe_disp1.png')));
d2 = double(imread(strcat('Aloe_disp5.png')));

d = build_disparity(d1,d2);


%% build delta
deltas = -1:1;  % random number
randindices = randsample(3,numel(d),true);
rands = reshape(deltas(randindices), size(d));
d_d = d + rands;
bins = (1:20) * 0.0005;
%% gen wavelet responses
thetas = pi/6:pi/6:2*pi;
sigmas = 1:3;

mim1 = zeros([size(im1, 1) size(im1,2) size(im1,3) numel(thetas) * numel(sigmas)]);
mim2 = mim1;
idx = 1;
N = numel(im1);

for i = 1:numel(sigmas)
  for j = 1:numel(thetas)
    m = morlet2d(sigmas(i),thetas(j),6*sigmas(i)+1,1+6*sigmas(i));
    mim1(:,:,:,idx) = multiConv2(im1,m);
    mim2(:,:,:,idx) = multiConv2(im2,m);
    idx = idx + 1;
  end
end



%% 1.

iml = transDisparity(im2,d);
[h_normal,c_normal,avg_normal,std_normal, errs] = hist_error(im1,iml,0.01,d);
% f=figure('visible','off');
% xlabel(sprintf('normal, error average: %f, std error: %f', avg_normal, std_normal));
% bar(c_normal, h_normal); print(f,'-dpng',strcat(dir,'normal.png'));
figure(1);
bar(h_normal, c_normal);
%%
hist_plot(h_normal,c_normal,avg_normal,std_normal,  'normal',2);

iml_d = transDisparity(im2,d_d);
[h_normal_d,c_normal_d,avg_normal_d,std_normal_d] = hist_error(im1,iml_d,0.01,d_d);
hist_plot(h_normal_d,c_normal_d,avg_normal_d,std_normal_d,'normal + rand',3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% 2.
 miml = transDisparity(mim2,d);
 [h_m, c_m, avg_m, std_m,dt] = hist_error(mim1, miml, bins(end)*0.05, d);
 clear('miml');
 hist_plot(h_m,c_m,avg_m,std_m,'morlet',4);
 
 miml_d = transDisparity(mim2,d_d);
 [h_m_d, c_m_d, avg_m_d, std_m_d] = hist_error(mim1, miml_d, bins(end)/20, d);
 hist_plot(h_m_d,c_m_d,avg_m_d,std_m_d,'morlet + rand',5);

% %% 3.
 miml_abs = transDisparity(abs(mim2),d);
 mim1_abs = abs(mim1);
 
 [h_mabs, c_mabs, avg_mabs, std_mabs] = hist_error(mim1_abs, miml_abs, bins(end)/20, d);
 hist_plot(h_mabs,c_mabs,avg_mabs,std_mabs,'morlet-absolute value',6);
 
 miml_abs_d = transDisparity(abs(mim2),d_d);
 [h_mabs_d, c_mabs_d, avg_mabs_d, std_mabs_d] = hist_error(mim1_abs, miml_abs_d, bins(end)/20, d);
 hist_plot(h_mabs_d,c_mabs_d,avg_mabs_d,std_mabs_d,'morlet-absolute value + rand',7);






toc;