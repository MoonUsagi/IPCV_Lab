%% Dark Image Enhancement
% Fred liu 2023.3.15

%%
mImgb = imread('Demo_3_2.jpg');
[Bblend2] = imlocalbrighten(mImgb,'AlphaBlend',true);
figure,imshowpair(mImgb,Bblend2,'montage');

%%
mImgc = imread('Demo_3_3.jpg');
[Bblend3] = imlocalbrighten(mImgc,'AlphaBlend',true);
figure,imshowpair(mImgc,Bblend3,'montage');