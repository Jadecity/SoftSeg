%unit test for seedfeat function
clear;
im = imread('res/img/1.jpg', 'jpg');
% cform = makecform('srgb2lab');
% im_lab = applycform(im, cform);
[a,b,c] = seedfeat(im);