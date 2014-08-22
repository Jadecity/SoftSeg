%   unit test of appProp function
clear;
im = imread('../res/img/1.jpg', 'jpg');
cform = makecform('srgb2lab');
im_lab = applycform(im, cform);
[rows, cols, ~] = size(im);
g = randn(1, rows*cols);
w = randn(1, rows*cols);
[ e ] = appProp(im_lab, g, w);