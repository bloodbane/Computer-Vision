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
range = gap*2+1;

thetas = [0, pi/6,pi/3,pi/2,2*pi/3,5*pi/6];
sigmas = [1, 3, 6];
sigma_num = size(sigmas,2);
theta_num = size(thetas,2);

s0_l = gaussian2dconv(im0,6);
s0_r = gaussian2dconv(im1,6);
s1_l = zeros([size(im0,1) size(im0,2) sigma_num theta_num]);
s1_r = zeros([size(im1,1) size(im1,2) sigma_num theta_num]);

for i = 1:sigma_num
  for j = 1:theta_num
    [rea_l,ima_l] = morlet2dconv(im0, sigmas(i), thetas(j));
    s1_l(:,:,i,j)=gaussian2dconv(sqrt(rea_l.^2 + ima_l.^2),6);
%% 
    [rea_r,ima_r] = morlet2dconv(im1, sigmas(i), thetas(j));
    s1_r(:,:,i,j)=gaussian2dconv(sqrt(rea_r.^2 + ima_r.^2),6);
  end
end

range_matrix = zeros([round((rows-t_size)/gap) round((colums-t_size)/gap) range]);
output = zeros([round((rows-t_size)/gap) round((colums-t_size)/gap)]);
I = zeros([round((rows-t_size)/gap) round((colums-t_size)/gap)]);

for i=16:gap:rows-16
    m = (i-8)/gap;
    for j=16:gap:colums-16     
        n = (j-8)/gap;
        if d0(i,j) == inf
            %% infinity case 2
            flag=0;
            for p = i-15:i+16
                for q = j-15:j+16
                    if d0(p,q)~=inf
                        d_true = round(d0(p,q)/gap)*gap;
                        flag = 1;
                        break;
                    end
                end
                if flag == 1
                    break;
                end
            end
            %% infinity case 1
            if flag == 0
                range_matrix(m,n,:) = inf;
                continue;
            end
        else
            d_true = round(d0(i,j)/gap)*gap;
        end
        %% disparity list         
        for d = 1:range
            sign = mod(d,2)*(-2)+1;
            d0_translation = d_true + sign*gap*round((d-1)/2);
            x_new = j+d0_translation;
            if x_new <= 0 || x_new > size(im1, 2)
                range_matrix(m,n,d) = inf;
            else
                tmp = (s0_l(i,j)-s0_r(i,x_new))^2;
                for p = 1:sigma_num
                    for q = 1:theta_num
                        tmp = tmp + (s1_l(i,j,p,q) - s1_r(i,x_new,p,q))^2;
                    end
                end
                range_matrix(m,n,d) = tmp/(sigma_num*theta_num+1);
            end
        end
    end
end

for m = 1:size(range_matrix,1)
    for n = 1:size(range_matrix,2)
        [output(m,n),I(m,n)] = min(range_matrix(m,n,:));
    end
end

toc;
    