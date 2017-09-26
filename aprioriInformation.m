
clear
clc


import recognition.*

%%Image Cutting
prostateImg = imread('Imagenes/an-u3-15-03.tif');
imshow(prostateImg);
prostateImgCut = imcrop(prostateImg,[120 110 420 350]);
figure();
imshow(prostateImgCut);

%%Aplying Gausian filter of thirteenth order
pascal13=[1 12 66 220 495 792 924 792 495 220 66 12 1];
matrizGausiana13=pascal13'*pascal13/(sum(pascal13)^2);
prostateImgCutBlurry=double(conv2(prostateImgCut,matrizGausiana13,'same'));

figure();
imagesc(prostateImgCutBlurry);
colormap gray;

%%Getting grayscale average for prostate
hFH1 = imfreehand();
xypositionP = hFH1.createMask();
sectionImgP = xypositionP .* prostateImgCutBlurry;
close;
imagesc(sectionImgP);
graylevelAverageProstate = sum(sum(sectionImgP))/sum(sum(xypositionP));
close;

%Getting grayscale average for halo
figure();
imagesc(prostateImgCutBlurry);
colormap gray;
hFH2 = imfreehand();
xypositionH = hFH2.createMask();
sectionImgH = xypositionH .* prostateImgCutBlurry;
close;
imagesc(sectionImgH);
graylevelAverageHalo = sum(sum(sectionImgH))/sum(sum(xypositionH)); %%Agregar la informacion extra de los promedios en las coordenadas x y y
close;


%%Getting region of background
figure();
xypositionB = ((xypositionP+xypositionH)-1)*-1;
sectionImgB = xypositionB .* prostateImgCutBlurry;
close;
imagesc(sectionImgB);
colormap gray;
graylevelAverageBack = sum(sum(sectionImgB))/sum(sum(xypositionB));
close;



[nR,nC]=size(prostateImgCutBlurry);

%%NO LOGRO DESCIFRAR EL ERROR, ENTIENDO PORQUE SUCEDE PERO NO SE COMO
%%CORREGIRLO
%%EL PROBLEMA ES QUE LA MATRIZ DE VALORES DE HALO ES MAS GRANDE QUE LA
%%MATRIZ TOTAL DE LA IMAGEN, EL ERROR VIENE DE IMFREEHAND PERO NO ENTIENDO
%%PORQUE SUCEDE. RIP
probP = (nR*nC - sum(sum(xypositionP)))/ nR*nC;
probH = (nR*nC - sum(sum(xypositionH)))/ nR*nC;
probB = 1 - probP - probH;

covP = cov(sectionImgP);
covH = cov(sectionImgH);
covB = cov(sectionImgB);
