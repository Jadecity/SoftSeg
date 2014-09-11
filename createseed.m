function [ seedmask ] = createseed( img, ftdb )
%CREATESEED given an image, create 5 to 12 seed areas
%   function [ seedmask ] = createseed( img )
%   img, is an input image,M-by-N-by-3, should be in Lab color space
%   seedmask, output is a M-by-N matrix, with seed areas labeled with an
%   integer.
%   ftdb, feature database, here is a 2-by-200 cell,cell in first line is
%   a gabor vector of 48 dimension, in second line is histogram vector of
%   100 dimension.
%   Author : lvhao
%   Email : lvhaoexp@163.com
%   Date : 2014-08-27
addpath('c_inference_ver2_2');
addpath('c_inference_ver2_2/c_inference');
%check input parameters
% To Do

%initial parameters
cnum = 200;%class number
display('get seedfeat');
tic
%first get patch feature
[ segmat, edges,  avgcolor, gabor ] = seedfeat( img );
%sfinfo is short for seed feature info
sfinfo.csz = size(avgcolor);
sfinfo.gsz = size(gabor);
toc

display('create graph edge2adj');
tic
%create graph
labels = unique(segmat);
nnum = size(labels, 1);%node number
%convert edge matrix to adjacency matrix
adj = edge2adj(labels, segmat, edges, nnum);
lambda = cell(nnum,nnum);
local = cell(1,nnum);
toc

display('create graph main loop');
tic

for r=1:nnum
    tic
    vi = zeros(nnum, 1);
    tp = gabor{1,r};
    for t=1:nnum
        vi(t) = (tp-ftdb{1,t})*(tp-ftdb{1,t})';
    end
    local{1,r} = vi;
    toc
    display('start loop');
    
    for c=r:nnum
        tic
        commat = zeros(cnum);
        frst = exp(-(avgcolor(r) - avgcolor(c))*(avgcolor(r) - avgcolor(c))'/250);
        toc
        display('inner loop');
        tic
        for m=1:cnum
            for n=m:cnum
                commat(m,c) = frst*(ftdb{2,m} - ftdb{2,n})*(ftdb{2,m} - ftdb{2,n})';
            end
        end
        
        lambda{r,c} = commat+commat';
        lambda{c,r} = lambda{r,c};
        toc
    end
end
toc
display('do inference');
tic
[bel, converged, belpairs, msgs] = inference(adj,lambda,local,'loopy','sum_or_max',1);
toc

end

