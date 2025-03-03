%% 2025/2/27
%Fred Liu


%%
I = imread('circuit.tif');
figure,imshow(I)
BW1 = edge(I,'Canny');
BW2 = edge(I,'Prewitt');
figure,imshowpair(BW1,BW2,'montage')