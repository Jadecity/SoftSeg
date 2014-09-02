function [ labelmat, edges, avgcolor, gabor, pixels ] = seedfeat( img )
%SEEDFEAT extract color and texture feature for oversegmented patchs
%   img, input image, should be in rgb color space
%   labelmat: patch labeled image, M-by-N
%   edges: binary edge image, M-by-N
%   avgcolor: label num rows and 3 columns in Lab order
%   gabor: a cell line with label num elements, each one is 48 dimemsion
%   pixels: a cell line with label num elements, each one has K-by-3 matrix, K is # of pixels in that patch,elements order is the same with gabor
%   Author : lvhao
%   Email : lvhaoexp@163.com
%   Date : 2014-08-27

addpath('Graph_seg');
addpath('Graph_seg/CoherenceFilter');
addpath('Gabor');
addpath('c_inference_ver2_2');
%adjacent neighborhood  model:
[L, edges] = graph_segment(img, 1, 3, 40);
%subplot(1, 1, 1), imshow(label2rgb(L)), title('adjacent neighborhood based segmentation');
labels = unique(L);
lnum = size(labels, 1);
labelmat = L;

%for each label patch, extract its average color and gabor texture
cform = makecform('srgb2lab');
img_lab = applycform(img, cform);
avgcolor = zeros(lnum, 3);
img1 = img_lab(:,:,1);
img2 = img_lab(:,:,2);
img3 = img_lab(:,:,3);
img_gray =  double(rgb2gray(img));

gaborArray = gaborFilterBank(4,6,39,39);
[u,v] = size(gaborArray);
gaborResult = cell(u,v);
gabor = cell(1,lnum);
pixels = cell(1,lnum);
for ln=1:lnum
    mask = (L == labels(ln));
    avgcolor(ln,:) = [mean2(img1(mask == 1)), mean2(img2(mask == 1)),...
        mean2(img3(mask == 1))];
    pblock = cat(3,img1(mask == 1), img2(mask == 1), img3(mask == 1));
    [pr,pc,~] = size(pblock);
    pixels{ln} = reshape(pr*pc, 3);

    %filtering image by each Gabor filter
    fv = zeros(1,48);
    cnt = 1;
    for i = 1:u
        for j = 1:v
            gaborResult{i,j} = roifilt2(gaborArray{i,j},img_gray,mask);
            fv(cnt:cnt+1) = [ mean2(gaborResult{i,j}), std2(gaborResult{i,j})];
            cnt = cnt + 2;
        end
    end
    gabor{1,ln} = fv;
    
end

end

