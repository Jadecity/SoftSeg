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
gaborArray = gaborFilterBank(5,8,39,39);
gabor = cell(1,lnum);
for ln=1:lnum
    mask = (L == labels(ln));
    avgcolor(ln,:) = [mean2(img1(mask == 1)), mean2(img2(mask == 1)),...
        mean2(img3(mask == 1))];
    
    %filtering image by each Gabor filter
    [u,v] = size(gaborArray);
    gaborResult = cell(u,v);
    for i = 1:u
        for j = 1:v
            gaborResult{i,j} = roifilt2(gaborArray{i,j},img_gray,mask);
        end
    end
    
    %Gabor feature vector extraction
    [n,m] = size(img_gray);
    s = (n*m)/(d1*d2);
    line = s*u*v;
    featureVector = zeros(line,1);
    c = 0;
    for i = 1:u
        for j = 1:v
            c = c+1;
            gaborAbs = abs(gaborResult{i,j});
            gaborAbs = downsample(gaborAbs,d1);
            gaborAbs = downsample(gaborAbs.',d2);
            gaborAbs = reshape(gaborAbs.',[],1);

            % Normalized to zero mean and unit variance. (if not applicable, please comment this line)
            gaborAbs = (gaborAbs-mean(gaborAbs))/std(gaborAbs,1);

            featureVector(((c-1)*s+1):(c*s)) = gaborAbs;
        end
    end
    gabor{1,ln} = featureVector;
    
%     %% Show filtered images
% 
%     % Show real parts of Gabor-filtered images
%     figure('NumberTitle','Off','Name','Real parts of Gabor filters');
%     for i = 1:u
%         for j = 1:v        
%             subplot(u,v,(i-1)*v+j)    
%             imshow(real(gaborResult{i,j}),[]);
%         end
%     end
%     
%     
%     % Show magnitudes of Gabor-filtered images
%     figure('NumberTitle','Off','Name','Magnitudes of Gabor filters');
%     for i = 1:u
%         for j = 1:v        
%             subplot(u,v,(i-1)*v+j)    
%             imshow(abs(gaborResult{i,j}),[]);
%         end
%     end
end

end

