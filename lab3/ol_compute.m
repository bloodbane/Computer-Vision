function [ol,im0] = ol_compute(d0,d1,im0)

rows = size(d0,1);
colums = size(d0,2);
ol = zeros([rows colums]);

for i = 1:rows
    for j = 1:colums
        xl = j;
        yl = i;
        xr = round(xl-d0(yl,xl));
%         tst(i,j) = xr;
        yr = yl;
        %% infinity 
        if d0(yl,xl) == Inf
            ol(i,j) = inf;
            im0(i,j,:) = 1;
        elseif xr<1
            ol(i,j) = -1;
            im0(i,j,:) = 0;
        elseif abs((d0(yl,xl)-d1(yr,xr)))<0.3
            ol(i,j)=0;
        else ol(i,j)=1; im0(i,j,:) = 0;      
        end
    end
end