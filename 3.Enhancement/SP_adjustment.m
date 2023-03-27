%% Histogram Adjustment
% Fred liu 2023.3.15
%% Input Data
%--------------------------------------
I = imread("pout.tif");
%I = imread('Demo_3_1.jpg');
%--------------------------------------
I = im2gray(I);

figure
subplot(5,5,1), imshow(I)
title('Original')

h1 = imhist(I);
axis1 = subplot(5,5,[2 5]);
bar(h1);
axis1.XLim = [0 256];
title('Original')

%% Histogram Imadjust
A = imadjust(I,stretchlim(I,0.01),[]);

subplot(5,5,6), imshow(A)
title('imadjust')

h3 = imhist(A);
axis3 = subplot(5,5,[7 10]);
bar(h3)
axis3.XLim = [0 256];
title('imadjust')

%%  Histogram Equalization

[eq_im, T] = histeq(I);

subplot(5,5,11), imshow(eq_im)
title('histeq')

h4 = imhist(eq_im);
axis4 = subplot(5,5,[12 15]); 
bar(h4)
axis4.XLim = [0 256];
title('histeq')

%% Adaptive Histogram Equalization 

adpt = adapthisteq(I);

subplot(5,5,16), imshow(adpt)
title('adapthisteq')

h5 = imhist(adpt);
axis5 = subplot(5,5,[17 20]);
bar(h5)
axis5.XLim = [0 256];
title('adapthisteq')

%% Adjust histogram of image to match histogram of reference image

% use the result of CHAHE to adjust the result of HE
rematch = imhistmatch(eq_im, adpt);

subplot(5,5,21), imshow(rematch)
title('imhistmatch')

h5 = imhist(rematch);
axis5 = subplot(5,5,[22 25]);
bar(h5)
axis5.XLim = [0 256];
title('imhistmatch')
