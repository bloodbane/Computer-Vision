function [ range_matrix , dis] = stero1( im0, im1, d0, gap, t_size)
%STERO1 Summary of this function goes here
%   Detailed explanation goes here
range = gap*2+1;
rows = size(im0,1);
colums = size(im0,2);

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
dis_range_matrix = zeros([round((rows-t_size)/gap) round((colums-t_size)/gap) range]);
cost = zeros([round((rows-t_size)/gap) round((colums-t_size)/gap)]);
I = zeros([round((rows-t_size)/gap) round((colums-t_size)/gap)]);
dis = zeros([round((rows-t_size)/gap) round((colums-t_size)/gap)]);

for i=16:gap:rows-16
    m = (i-(16-gap))/gap;
    for j=16:gap:colums-16     
        n = (j-(16-gap))/gap;
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
            dis_range_matrix(m,n,d) = d0_translation;
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
        [cost(m,n),I(m,n)] = min(range_matrix(m,n,:));
        if cost(m,n)==inf
            dis(m,n) = inf;
        else
            dis(m,n) = dis_range_matrix(m,n,I(m,n));
        end
    end
end


end

