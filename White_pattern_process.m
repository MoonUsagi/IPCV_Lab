%% ROI definition
close all
clc
img = imread("5.bmp","bmp");

% 負片處理/對比增強
img_neg = 255- img;
limit_low = (210-5)/255;
limit_high = (210+5)/255;
img_neg_cons = imadjust(img_neg,[limit_low,limit_high],[0, 1],1);

% 二值化/形態學做缺陷處理
img_neg_cons_bin = 255 * uint8(imbinarize(img_neg_cons, 0.8)); 
se = strel('square',5);
img_neg_cons_bin = imclose(img_neg_cons_bin,se);

% 搜尋ROI區域所標記的編號
img_neg_cons_bin = ~img_neg_cons_bin;
[~, L, N, A] = bwboundaries(img_neg_cons_bin,'noholes');
[rows, cols] = size(img);
middle_label = L(rows/2,cols/2);
if (middle_label ~= 0)
    stats = regionprops('table', L == middle_label, 'Orientation');
end
if (~isempty(stats.Orientation))
    img_neg_cons_bin(L ~= middle_label) = false;
    mask = img_neg_cons_bin;
    img_mask = img.*imfill(uint8(mask));
end

% 影像轉正
if (stats.Orientation < 0)
    angle = -90-stats.Orientation(1);
else
    angle = 90-stats.Orientation(1);
end
mask_rotate = imrotate(mask, angle, "bilinear","crop");
stats = regionprops(mask_rotate,'BoundingBox');
crop_region = ceil(stats.BoundingBox);
img_ROI = img_mask_rotate(crop_region(2):crop_region(2)+crop_region(4),crop_region(1):crop_region(1)+crop_region(3));


%% Defect detection for small defect
RowsAndCols = size(subimg);
x_orgin = 0;
y_orgin = 0;
step_size = 8;
figure();imshow(img_ROI_shrink);hold on
defect_count = 1;
sigma = 2.0;

% 高斯模糊/定義全域對比增強範圍
img_ROI_gauss = imgaussfilt(img_ROI_shrink,sigma);
hist_tmp = imhist(img_ROI_gauss);
hist_peaks = find(hist_tmp==max(hist_tmp(2:end-1)));
limit_low = (hist_peaks(1)-10-10)/255;
limit_high = (hist_peaks(1)+10-10)/255; 


% 每個區域畫面影像處理
for i = 1:RowsAndCols(1)
    for j = 1:RowsAndCols(2)
        img_defect = subimg{i,j};
        x_orgin = (j-1) * floor(Cols/step_size);
        y_orgin = (i-1) * floor(Rows/step_size);
        
        % 區域高斯模糊/區域/對比增強/二值化
        sigma = 1.8;
        img_defect_gauss = imgaussfilt(img_defect,sigma);
        img_defect_adj = imadjust(img_defect_gauss,[limit_low,limit_high],[0,1],1);
        img_defect_adj = 255 - img_defect_adj;
        threshold = 0.92;
        img_defect_adj_dark = imbinarize(img_defect_adj, threshold);
        img_defect_adj_dark = imfill(img_defect_adj_dark,'holes');
        
        % 標記瑕疵範圍
        stats = regionprops('table',img_defect_adj_dark, 'Orientation','BoundingBox','Area');
        if (~isempty(stats.Area))
            for q=1:length(stats.Area)
                if (any(stats.Area(q) > 10))
                    rectangle("Position",[x_orgin + stats.BoundingBox(q,1), y_orgin + stats.BoundingBox(q,2),stats.BoundingBox(q,3),stats.BoundingBox(q,4)],"LineWidth",1,"EdgeColor",'g');
                end
            end
        end
    end
end