function [ labelmat, avgcolor, gabor ] = seedfeat( img )
%SEEDFEAT extract color and texture feature for oversegmented patchs
%   img, input image, should be in Lab color space
%   
addpath('Graph_seg');
addpath('Graph_seg/CoherenceFilter');
addpath('Gabor');
%adjacent neighborhood  model:
[L, ~] = graph_segment(img, 1, 3, 40);
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

d1 = 4;
d2 = 4;
gaborArray = gaborFilterBank(4,6,39,39);
[u,v] = size(gaborArray);
gaborResult = cell(u,v);
gabor = cell(1,lnum);
for ln=1:lnum
    mask = (L == labels(ln));
    avgcolor(ln,:) = [mean2(img1(mask == 1)), mean2(img2(mask == 1)),...
        mean2(img3(mask == 1))];
    
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

