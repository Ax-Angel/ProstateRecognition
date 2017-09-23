
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
prostateImgCutBlurry=uint8(conv2(prostateImgCut,matrizGausiana13,'same'));
figure();
imshow(prostateImgCutBlurry);

%%Getting grayscale average for prostate
hFH1 = imfreehand();
xypositionP = getPosition(hFH1);
[i,z] = size(xypositionP);
sumVals = double(0);
matValuesP = [i,z];
for x=1:i
    for y=1:z
        sumVals = sumVals + double(prostateImgCutBlurry(int16(xypositionP(x)),int16(xypositionP(x,y))));
        matValuesP(x,y) = double(prostateImgCutBlurry(int16(xypositionP(x)),int16(xypositionP(x,y))));
    end
end
graylevelAverageProstate = sumVals/(i*z);
close;

%Getting grayscale average for halo
figure();
imshow(prostateImgCutBlurry);
hFH2 = imfreehand();
xypositionH = getPosition(hFH2);
[i,z] = size(xypositionH);
matValuesH = [i,z];
sumVals = double(0);
for x=1:i
    for y=1:z
        if int16(xypositionH(x)) > 351
            sumVals = sumVals + double(prostateImgCutBlurry(351,int16(xypositionH(x,y))));
            matValuesH(x,y) = double(prostateImgCutBlurry(351,int16(xypositionH(x,y))));
        else
             sumVals = sumVals + double(prostateImgCutBlurry(int16(xypositionH(x)),int16(xypositionH(x,y))));
             matValuesH(x,y) = double(prostateImgCutBlurry(int16(xypositionH(x)),int16(xypositionH(x,y))));
        end
    end
end
graylevelAverageHalo = sumVals/(i*z);
close;

%Getting region of background
figure();
imshow(prostateImgCutBlurry);
hFH3 = imfreehand();
xypositionB = getPosition(hFH3);
[i,z] = size(xypositionB);
matValuesB = [i,z];
for x=1:i
    for y=1:z
        if int16(xypositionB(x)) > 351
            matValuesB(x,y) = double(prostateImgCutBlurry(351,int16(xypositionB(x,y))));
        else
             matValuesB(x,y) = double(prostateImgCutBlurry(int16(xypositionB(x)),int16(xypositionB(x,y))));
        end
    end
end
close;

[nR,nC]=size(prostateImgCutBlurry);
[nRP,nCP]=size(matValuesP);
[nRH,nCH]=size(matValuesH);

%%NO LOGRO DESCIFRAR EL ERROR, ENTIENDO PORQUE SUCEDE PERO NO SE COMO
%%CORREGIRLO
%%EL PROBLEMA ES QUE LA MATRIZ DE VALORES DE HALO ES MAS GRANDE QUE LA
%%MATRIZ TOTAL DE LA IMAGEN, EL ERROR VIENE DE IMFREEHAND PERO NO ENTIENDO
%%PORQUE SUCEDE. RIP
probP = (nR*nC - nRP*nCP)/ nR*nC;
probH = (nR*nC - nRH*nCH)/ nR*nC;%%ESTA PROBABILIDAD DA NEGATIVA
probB = 1 - probP - probH;

covP = cov(matValuesP);
covH = cov(matValuesH);
covB = cov(matValuesB);
