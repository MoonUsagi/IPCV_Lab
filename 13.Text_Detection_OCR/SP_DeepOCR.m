%% Deep OCR
% Fred liu 2023.4.10
%% 基礎版 
Img = imread("OCR_1.jpg");
%Img = imrotate(Img,90);
ocrResults = ocr(Img);
disp(ocrResults.Text)
bboxes = locateText(ocrResults,"Fred Liu",IgnoreCase=true);
Iocr = insertShape(Img,"FilledRectangle",bboxes);

figure; imshow(Iocr); 

%% 中文語言包
Img = imread("OCR_1.jpg");
%Img = imrotate(Img,90);
ocrResults = ocr(Img,Model="chinesetraditional");
disp(ocrResults.Text)
bboxes = locateText(ocrResults,"劉 Fred Liu",IgnoreCase=true);
Iocr = insertShape(Img,"FilledRectangle",bboxes);

figure; imshow(Iocr);

%% 中文語言包
Img = imread("OCR_1.jpg");
%Img = imrotate(Img,90);
ocrResults = ocr(Img,Model="chinesetraditional");
disp(ocrResults.Text)
bboxes = locateText(ocrResults,"工程",IgnoreCase=true);
Iocr = insertShape(Img,"FilledRectangle",bboxes);

figure; imshow(Iocr);
