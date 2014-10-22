bf = im2double(imread('butterfly.jpg'));
if size(bf,3)>1
  bf = rgb2gray(bf);
end

%%
thetas = [0, pi/6,pi/4,pi/3,pi/2,2*pi/3,3*pi/4,5*pi/6];
sigmas = [1, 3, 6];
rows = size(sigmas,2);
cols = size(thetas,2);
result = zeros([rows cols 2 size(bf,1) size(bf,2)]);
%%colormap(white);
for i = 1:rows
  for j = 1:cols
    [rea,ima] = morlet2dconv(bf, sigmas(i), thetas(j));
    result(i,j,1,:,:) = rea;
    result(i,j,2,:,:) = ima;
    %%
    figure
    % g = subplot(rows,cols * 2, (i-1) * 2 * cols + 2 * j - 1);
    h = imshow(mat2gray(rea));
    str = sprintf('butterfly-%.2fpi,%d,re.jpg', thetas(j)/pi, sigmas(i));
    title(str);
    saveas(h, str);
    %%
    figure
    % subplot(rows,cols*2,(i-1)*2*cols+2*j);
    str = sprintf('butterfly-%.2fpi,%d,im.jpg', thetas(j)/pi, sigmas(i));
    h = imshow(mat2gray(ima));
    title(str);
    saveas(h, str);
  end
end 
%% gaussian blur
figure 
gaussianed = gaussian2dconv(bf,5);

imagesc(gaussianed);
h = imshow(mat2gray(gaussianed))
str = sprintf('butterfly-blur.jpg', thetas(j)/pi, sigmas(i));
    title(str);
    saveas(h, str);
%%