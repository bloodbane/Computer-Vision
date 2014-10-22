function imll = transDisparity(imr, d, scale)

%% vectorized
if nargin < 3
  scale = 1;
end
d = d / scale;
d(d==0) = nan;
rows = size(imr,1);
cols = size(imr,2);
channels = size(imr,3);
count = size(imr,4);
% pad imr with NaNs
border = 256;
nans = NaN * ones([rows border channels count]);
imrr = [nans imr nans];
clear('nans');

fprintf('imrr constructed\n');
[xx, yy, zz] = meshgrid(1:cols,1:rows,1:channels);%,1:count);
[~,~,~,cc] = ndgrid(1:rows,1:cols,1:channels,1:count);
xx = xx + border - repmat(d, [1 1 channels]);
xx = repmat(xx,[1 1 1 count]);
yy = repmat(yy,[1 1 1 count]);
zz = repmat(zz,[1 1 1 count]);


inds = sub2ind([rows cols+border*2 channels count], yy, xx, zz,cc);
clear('yy','xx','zz','cc');
fprintf('inds constructed\n');
inds(isnan(inds)) = 1;
imll = imrr(inds);

return



%% unvectorized %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rows, cols, channels, count] = size(imr);
border = 256;
nans = NaN * ones([rows border]);
[xx,yy] = meshgrid(1:cols,1:rows);
xx = xx + border - d;
inds = sub2ind([rows cols+border*2],yy,xx);
inds(isnan(inds)) = 1;
imll = imr;
for i = 1:channels
  for j = 1:count
    t = [nans imr(:,:,i,j) nans];
    imll(:,:,i,j) = t(inds);
  end
end
return






end