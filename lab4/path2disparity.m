function  disparity = path2disparity(labels, width)
% map from left image to right image
    hascut = zeros(width, 1);
    disparity = zeros(1, width);
    for i = 1 : width
        for j = 1 : width
            idx_u = convert2node('u', i, j, width, width);
            idx_v = convert2node('v', i, j, width, width);
            if labels(idx_u) ~= labels(idx_v)
                hascut(i, 1) = 1;
                disparity(i) = i - j;
                break;
            end
        end
        if hascut(i, 1) == 0
            disparity(i) = inf; % this means occlusion!!
        end
    end
end











