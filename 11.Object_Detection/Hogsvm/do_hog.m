function feature_hog = do_hog(loc)
img = imread(loc);
[feature_hog,visualization] = extractHOGFeatures(img,'CellSize',[32 32]);
