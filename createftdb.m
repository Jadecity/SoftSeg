%this script is to create universal feature database used for  segmentation

addpath('Graph_seg');
addpath('Graph_seg/CoherenceFilter');
addpath('Gabor');
addpath('c_inference_ver2_2');

%first allocate memory
ftdb = cell(2,200);

%use images in a folder to train texture and histogram feature
path = 'res/images/training'
imgnum = 20;
%a big variable to store all texture and color vector, for clustering afterward
featdata = cell(1,imgnum);
gabornum = 0;
for n=1:imgnum
  filename = strcat(path,'/', num2str(n), '.jpg');
  img = imread(filename);

  %segment image and extract gabor feature for each path
  [labelmat, edges, avgcolor, gabor, pixels] = seedfeat(img);
  featdata{n}.gabor = gabor;
  featdata{n}.pixels = pixels;
  gabornum = gabornum + size(gabor, 2);
end

%prepair texture dataset
gabordb = zeros( gabornum, 48 );
pixeldb = cell( 1, gaboarnum );
cnt = 1;
for n=1:imgnum
  labelnum = size(featdata{n}.gabor,2);
  for m = 1:labelnum
    gabordb(cnt,:) = featdata{n}.gabor{m};
    pixeldb{cnt} = featdata{n}.pixels;
    cnt = cnt + 1;
  end
end

%use kmeans to cluster textures to 200 classes
classnum = 200;
[idx, Cntr] = kmeans(gabordb, classnum, 'distance', 'cosine');
save idx.mat idx;
save Cntr.mat Cntr;

%generate a histogram with 100 bins for each class
binnum = 100;
hsts = zeros(classnum, binnum);
for cl = 1:classnum
  pixblocks = pixeldb{idx==cl};
  pbnum = size(pixblocks, 2);
  pixlab = [];
  for p=1:pbnum
    pixlab = cat(1, pixlab, pixblocks{p});
  end
  hsts(cl) = histab(pixlab, binnum);
end

save hists.mat hsts;
