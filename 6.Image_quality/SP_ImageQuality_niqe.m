%% Image Quality 
% Fred Liu 2023.03.15
E = imread('q01.png');
%E = imread('q02.jpg');

%% add noise & gauss
Inoise = imnoise(E,'salt & pepper',0.02);
Iblur = imgaussfilt(E,2);
%% use niqe
figure
montage({E,Inoise,Iblur},'Size',[1 3])

niqeI = niqe(E);
fprintf('NIQE score for original image is %0.4f.\n',niqeI)

niqeInoise = niqe(Inoise);
fprintf('NIQE score for noisy image is %0.4f.\n',niqeInoise)

niqeIblur = niqe(Iblur);
fprintf('NIQE score for blurry image is %0.4f.\n',niqeIblur)

title(['Original Image:',num2str(niqeI),'             |           ',...
       ' Noisy Image:',num2str(niqeInoise),'            |            ',...
       ' Blurry Image:',num2str(niqeIblur)])