function [ labelvec, avgcolor, gabor ] = seedfeat( img )
%SEEDFEAT extract color and texture feature for oversegmented patchs
%   img, input image, should be in Lab color space
%   

%smooth the image by coherence filter:
img_ftd = CoherenceFilter(img,struct('T',5,'rho',2,'Scheme','R', 'sigma', 1));
%adjacent neighborhood  model:
L = graphSeg(img_ftd, 0.5, 50, 2, 0);
%display:
%cform = makecform('lab2srgb');
%rgb = applycform(img_ftd, cform);
subplot(1, 1, 1), imshow(label2rgb(L)), title('adjacent neighborhood based segmentation');

labelvec = [];
avgcolor = [];
gabor = [];
end

