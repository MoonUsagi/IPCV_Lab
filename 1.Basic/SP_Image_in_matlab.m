%% Image Basic 
% Fred liu 2022.6.14
close all;clear all;clc
%% Color image
rgbImg = imread('RGBImg.png');
figure,imshow(rgbImg);

%% Gray scale image
grayImg = imread('grayImg.png');
figure,imshow(grayImg);

%% Binary image
bwImg = imread('bwImg.png');
figure,imshow(bwImg);

%% Color to Grayscale image
color2gray = im2gray(rgbImg);
figure,imshow(color2gray);

%% Grayscale to Binary image
thresh = graythresh(color2gray);

gray2binary = imbinarize(color2gray, thresh);
figure,imshow(gray2binary);
%% Grayscale to Binary image - define thresh
BW1 = color2gray > 70;
BW2 = color2gray > 150;

figure
subplot(1,2,1), imshow(BW1);
title('I > 70')
subplot(1,2,2), imshow(BW2);
title('I > 150')

%% Imtool 

imtool(rgbImg)
imtool(color2gray)