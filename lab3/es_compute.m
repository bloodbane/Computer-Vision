function [ es ] = es_compute( im0, im1, d0, ol, t_size )
%EP_COMPUTE Summary of this function goes here
%   Detailed explanation goes here
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

rows = size(ol,1);
colums = size(ol,2);
% im0 = im0;
% im1 = im1;
es = zeros([round(rows/t_size) round(colums/t_size)]);
for i=16:t_size:rows
    m = (i+16)/t_size;
    for j=16:t_size:colums     
        n = (j+16)/t_size;
        oc_in = 0;
        for p = i-15:i+16
            for q = j-15:j+16
                if ol(p,q)~=0
                    oc_in = 1;
                end
            end
        end
        if oc_in == 1 %count == 0% 
            es(m,n) = inf;           
        else
            x_new = round(j-d0(i,j));
            tmp = (s0_l(i,j)-s0_r(i,x_new))^2;
            for p = 1:sigma_num
                for q = 1:theta_num
                    tmp = tmp + (s1_l(i,j,p,q) - s1_r(i,x_new,p,q))^2;
                end
            end
            es(m,n) = tmp/(sigma_num*theta_num+1);
        end
    end
end
end

