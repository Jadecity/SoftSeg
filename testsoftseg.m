img = imread('res/images/test/001.jpg');
cform = makecform('srgb2lab');
img_lab = applycform(img, cform);

res = softseg(img, ftdb);