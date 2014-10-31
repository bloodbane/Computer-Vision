function [ ep ] = ep_compute( im0, im1, d0, ol, t_size )
%EP_COMPUTE Summary of this function goes here
%   Detailed explanation goes here
rows = size(ol,1);
colums = size(ol,2);
% im0 = im0;
% im1 = im1;
ep = zeros([round(rows/t_size) round(colums/t_size)]);
for i=16:t_size:rows
    m = (i+16)/t_size;
    for j=16:t_size:colums     
        n = (j+16)/t_size;
        count = 0;
        tmp = 0;
        oc_in = 0;
        for p = i-15:i+16
            for q = j-15:j+16
                if ol(p,q)==0
                    x_new = round(q-d0(i,j));
                    if x_new > 0
                        count=count+1;
                        tmp = tmp+((im0(p,q)-im1(i,x_new)))^2;
                    end                    
                else oc_in = 1;
                end
            end
        end
        if oc_in == 1 %count == 0% 
            ep(m,n) = inf;           
        else 
            ep(m,n) = tmp/count;
        end
    end
end

end

