
clear
clc


import recognition.*

%%Image Cutting
prostateImg = imread('Imagenes/an-u3-15-03.tif');
imshow(prostateImg);
prostateImgCut = imcrop(prostateImg,[120 110 420 350]);
imshow(prostateImgCut);

%%Aplying Gausian filter of thirteenth order
pascal13=[1 12 66 220 495 792 924 792 495 220 66 12 1];
matrizGausiana13=pascal13'*pascal13/(sum(pascal13)^2);
prostateImgCutBlurry=uint8(conv2(prostateImgCut,matrizGausiana13,'same'));
imshow(prostateImgCutBlurry);

%%Getting grayscale average for prostate
hFH1 = imfreehand();
xypositionP = getPosition(hFH1);
graylevelAverageProstate = sum(xypositionP)/size(xypositionP);

%Getting grayscale average for halo
hFH2 = imfreehand();
xypositionH = getPosition(hFH2);
graylevelAverageHalo = sum(xypositionH)/size(xypositionH);

%Getting region of background
hFH3 = imfreehand();
xypositionB = getPosition(hFH3);

probP = (size(prostateImgCutBlurry) - size(xypositionP))/ size(prostateImgCutBlurry);
probH = (size(prostateImgCutBlurry) - size(xypositionH))/ size(prostateImgCutBlurry);
probB = 1 - probP - probH;

covP = cov(xypositionP);
covH = cov(xypositionH);
covB = cov(xypositionB);
