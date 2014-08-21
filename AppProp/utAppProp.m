%   unit test of appProp function
clear;
im = imread('../res/img/1.jpg', 'jpg');
cform = makecform('srgb2lab');
im_lab = applycform(im, cform);

g = [];
w = [];
[imo, e] = appProp(im_lab, g, w);