%this script is to create universal feature database used for  segmentation

%first allocate memory
ftdb = cell(2,200);

%use images in a folder to train texture and histogram feature
path = 'res/images/training'
imgnum = 1;
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
cnt = 1;
for n=1:imgnum
  labelnum = size(featdata{n},2);
  for m = 1:labelnum
    gabordb(cnt,:) = featdata{n}{m};
  end
end

%use kmeans to cluster textures to 200 classes
classnum = 200;
[idx, Cntr] = kmeans(gabordb, classnum, 'distance', 'cosine');