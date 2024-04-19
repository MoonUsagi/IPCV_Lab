imgd = imageDatastore('CharModels','IncludeSubfolders',true,...
                      'LabelSource','foldernames');
imgd.ReadFcn = @do_hog;
img = readall(imgd);

Dataset = cat(1,img{:});
DataTable = table(Dataset,imgd.Labels);
DataTable.Properties.VariableNames(end) = {'Label'};
                  