function cost = matching_cost(range_matrix)

    [height,width, range] = size(range_matrix);
       
    cost = cell(height, 1);

    
    for i = 1 : height
        cost_each_row = sparse(width, width);
        for j = 1 : width
        	for d = 1 : range
               	sign = mod(d,2)*(-2)+1;
                x_new = j + sign*round((d-1)/2);
                if x_new>0 && x_new<width
                    cost_each_row(j,x_new) = range_matrix(i,j,d);
                end
            end
        end
        cost{i, 1} = cost_each_row;

    end
    
    
    
    
%%
    
end
