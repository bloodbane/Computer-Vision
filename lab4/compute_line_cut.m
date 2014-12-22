function [row_disparity, flow] = compute_line_cut(matching_err)
tic;
% build a graph using two corresponding lines of pixels and find disparity 
% map by using graph cut method.
%     input: 
%             matching_err:  result of comparing two blocks of images by 
%                            scattered networks
%             contrast_left: lookup table of contrast between adjacent
%                            pixels of left image 
%             contrast_right:lookup table of contrast between adjacent
%                            pixels of right image 
%     output:
%             row_disparity: disparity map of one row
%             flow:          maxflow of the generated graph
            
    width = size(matching_err, 1); % width is the width of matching_err matrix
    graph_size = width ^ 2 * 2; % width ^ 2 of u and width ^ 2 of v nodes.
    
%% Edges inside graph
    A = sparse(graph_size, graph_size);
    % Scatter error (little black edges in figure)
    [i,j,v] = find(matching_err);
    for p = 1:i
        idx_u = convert2node('u', i(p), j(p), width, width);
        idx_v = convert2node('v', i(p), j(p), width, width);
        A(idx_u, idx_v) = v(p);
    end
        
%% Smooth term (little gray edges in figure)
    mu = 1e-4;
    
    % L changes
    for i = 1 : width - 1
        for j = 1 : width
            idx_u = convert2node('u', i, j, width, width);
            idx_v = convert2node('v', i + 1, j, width, width);
            A(idx_u, idx_v) = mu;
            A(idx_v, idx_u) = mu;
        end
    end
    % r changes
    for i = 1 : width
        for j = 1 : width - 1
            idx_u = convert2node('u', i, j + 1, width, width);
            idx_v = convert2node('v', i, j, width, width);
            A(idx_u, idx_v) = mu;
            A(idx_v, idx_u) = mu;
        end
    end
    
%% Edges between graph and Source/Sink
    T = sparse(graph_size, 2);
    % 1st col of T represents Source
    % 2nd col of T represents Sink
    % s,U_l1
    for i = 1 : width
        idx_u = convert2node('u', i, 1, width, width);
        T(idx_u, 1) = mu;
    end
    % V_lN,t
    for i = 1 : width
        idx_v = convert2node('v', i, width, width, width);
        T(idx_v, 2) = mu;
    end
    % s,U_Nr
    for j = 1 : width
        idx_u = convert2node('u', width, j, width, width);
        T(idx_u, 1) = mu;
    end
    % V_1r,t
    for j = 1 : width
        idx_v = convert2node('v', 1, j, width, width);
        T(idx_v, 2) = mu;
    end
    
 %% restriction term which forces min-cut on the right directions
    % (dash lines in figure)
    % Horizontal dash lines
    for i = 1 : width - 1
        for j = 2 : width
            idx_u1 = convert2node('u', i, j, width, width);
            idx_u2 = convert2node('u', i + 1, j, width, width);
            A(idx_u1, idx_u2) = inf;
        end
    end
    for i = 1 : width - 1
        for j = 1 : width - 1
            idx_v1 = convert2node('v', i, j, width, width);
            idx_v2 = convert2node('v', i + 1, j, width, width);
            A(idx_v1, idx_v2) = inf;
        end
    end
    % Vertical dash lines
    for i = 1 : width - 1
        for j = width : -1 : 2
            idx_u1 = convert2node('u', i, j, width, width);
            idx_u2 = convert2node('u', i, j - 1, width, width);
            A(idx_u1, idx_u2) = inf;
        end
    end
    for i = 2 : width
        for j = width : -1 : 2
            idx_v1 = convert2node('v', i, j, width, width);
            idx_v2 = convert2node('v', i, j - 1, width, width);
            A(idx_v1, idx_v2) = inf;
        end
    end

%% Do MaxFlow MinCut Calculation using Boykov's alg

    [flow, labels] = maxflow(A, T);
    row_disparity = path2disparity(labels, width);
%%
toc;
end