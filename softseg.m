function seged = softseg( img, ftdb )
%SOFTSEG used to make a soft segmentation of an image
%    function seged = softseg( img )
%    img: input image, should be in lab color space, M-by-N-by-3
%    ftdb: feature database, here is a 2-by-200 cell,cell in first line is
%   a gabor vector of 48 dimension, in second line is histogram vector of
%   100 dimension.

%first create soft segmentation seed
seeds = createseed( img, ftdb);

%add path
addpath('AppProp');

%apply edit propagation
g = seeds(:);
w = size(g);
w(:) = 0.5;
edit = appProp( img, g, w);