
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
graylevelAverageProstate = (3);
imagesc(sectionImgP);
graylevelAverageProstate(1) = sum(sum(sectionImgP))/sum(sum(xypositionP));
[i,z] = size(sectionImgP);
sumX=double(0);
sumY=double(0);
contP = double(0);
iii = double(0);
matrixOfValuesP = [i*z,3];
for x=1:i
    for y=1:z
        if sectionImgP(x,y) ~= 0
            sumX = sumX + x;
            sumY = sumY + y;
            contP = contP + 1;
        end
        iii = iii + 1;
        matrixOfValuesP(iii,1) = sectionImgP(x,y);
        matrixOfValuesP(iii,2) = x;
        matrixOfValuesP(iii,3) = y;
    end
end
graylevelAverageProstate(2) = sumX / contP;
graylevelAverageProstate(3) = sumY / contP;
close;

%Getting grayscale average for halo
figure();
imagesc(prostateImgCutBlurry);
colormap gray;
hFH2 = imfreehand();
xypositionH = hFH2.createMask();
sectionImgH = xypositionH .* prostateImgCutBlurry;
close;
graylevelAverageHalo = (3);
imagesc(sectionImgH);
graylevelAverageHalo(1) = sum(sum(sectionImgH))/sum(sum(xypositionH));
[i,z] = size(sectionImgH);
sumX=double(0);
sumY=double(0);
contH = double(0);
matrixOfValuesH = [i*z,3];
iii = double(0);
for x=1:i
    for y=1:z
        if sectionImgH(x,y) ~= 0
            sumX = sumX + x;
            sumY = sumY + y;
            contH = contH + 1;
        end
        iii = iii + 1;
        matrixOfValuesH(iii,1) = sectionImgH(x,y);
        matrixOfValuesH(iii,2) = x;
        matrixOfValuesH(iii,3) = y;
    end
end
graylevelAverageHalo(2) = sumX / contH;
graylevelAverageHalo(3) = sumY / contH;
close;


%%Getting region of background
xypositionB = ((xypositionP+xypositionH)-1)*-1;
sectionImgB = xypositionB .* prostateImgCutBlurry;
close;
graylevelAverageBack = (3);
imagesc(sectionImgB);
graylevelAverageBack(1) = sum(sum(sectionImgB))/sum(sum(xypositionB));
[i,z] = size(sectionImgB);
sumX=double(0);
sumY=double(0);
cont = double(0);
matrixOfValuesB = [i*z,3];
iii = double(0);
for x=1:i
    for y=1:z
        if sectionImgB(x,y) ~= 0
            sumX = sumX + x;
            sumY = sumY + y;
            cont = cont + 1;
        end
        iii = iii + 1;
        matrixOfValuesB(iii,1) = sectionImgB(x,y);
        matrixOfValuesB(iii,2) = x;
        matrixOfValuesB(iii,3) = y;
    end
end
graylevelAverageBack(2) = sumX / cont;
graylevelAverageBack(3) = sumY / cont;
close;

[nR,nC]=size(prostateImgCutBlurry);
probP = contP / (nR*nC);
probH = contH / (nR*nC);
probB = 1 - probP - probH;

covP = cov(matrixOfValuesP);
covH = cov(matrixOfValuesH);
covB = cov(matrixOfValuesB);
