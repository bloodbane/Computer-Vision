function y = multiConv2(x,co)
c = size(x,3);
y = zeros(size(x));
for i = 1:c
  y(:,:,i) = conv2(x(:,:,i),co,'same');
end
end