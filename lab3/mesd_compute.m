function [ me, sd ] = mesd_compute( nfv_e, xh, e_hist, e_m )
me = 0;
me2 = 0;
for i=1:size(nfv_e,2)
    pr = 0;
    for j=2:size(xh,2)
        if xh(j)>nfv_e(i)
            if e_m(j-1) == 0
                pr = e_hist(j)/e_m(j);
            else
                pr = e_hist(j-1)/e_m(j-1);
            end
            break;
        end
        if j==size(xh,2)
           pr = e_hist(j)/e_m(j);
        end
    end
    me = me + nfv_e(i)*pr;
    me2 = me2 + nfv_e(i)^2*pr;
end
sd = sqrt(me2-me^2);
end