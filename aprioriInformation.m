
clear
clc


import recognition.*

%%Image Cutting
prostateImg = imread('Imagenes/an-u3-16-03.tif');
imshow(prostateImg);
prostateImgCut = imcrop(prostateImg,[120 110 420 350]);
imshow(prostateImgCut);

%%Aplying Gausian filter of thirteenth order
pascal13=[1 12 66 220 495 792 924 792 495 220 66 12 1];
matrizGausiana13=pascal13'*pascal13/(sum(pascal13)^2);
prostateImgCutBlurry=uint8(conv2(prostateImgCut,matrizGausiana13,'same'));
imshow(prostateImgCutBlurry);

%%Getting grayscale average for prostate
hFH = imfreehand();
xypositionP = getPosition(hFH);
graylevelAverageProstate = sum(xypositionP)/size(xypositionP);

%Getting grayscale average for halo
hFH = imfreehand();
xypositionH = getPosition(hFH);
graylevelAverageHalo = sum(xypositionH)/size(xypositionH);

xypositionB=positionsback(xypositionP,xypositionH,prostateImgCutBlurry);
%No se como obtener el conjunto de valores que no pertenecen ni a la
%prostata ni el halo. La linea de abajo me regresa un conjunto vacio.
%xypositionB = double(setdiff(prostateImgCutBlurry, union(xypositionP, xypositionH)));

probP = (size(prostateImgCutBlurry) - size(xypositionP))/ size(prostateImgCutBlurry);
probH = (size(prostateImgCutBlurry) - size(xypositionH))/ size(prostateImgCutBlurry);
probB = 1 - probP - probH;

covP = cov(xypositionP);
covH = cov(xypositionH);


%Como no puedo obtener el conjunto de pixeles del background, no puedo
%calcular su matriz de covarianza
%covB = cov(xypositionB);