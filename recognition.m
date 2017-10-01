img = imread('Imagenes/U3-14-04.BMP');
cuttedImg = imcrop(img,[120 110 420 350]);

pascal13=[1 12 66 220 495 792 924 792 495 220 66 12 1];
matrizGausiana13=pascal13'*pascal13/(sum(pascal13)^2);
blur=uint8(conv2(cuttedImg,matrizGausiana13,'same'));
figure();
imagesc(blur);
colormap gray;

pixelsH=double(0);
pixelsP=double(0);
pixelsB=double(0);
sumValsP=double(0);
sumValsH=double(0);
sumValsB=double(0);
xP=double(0);
yP=double(0);
xH=double(0);
yH=double(0);
xB=double(0);
yB=double(0);
[nRows,nCols] = size(blur);
for x=1:nRows
    for y=1:nCols
        if (blur(x,y)>=graylevelAverageHalo(1)) 
            pixelsH = pixelsH + double(1);
            sumValsH = sumValsH + double(blur(x,y));
            xH = xH + x;
            yH = yH + y;
        elseif (blur(x,y)>=graylevelAverageProstate(1)) 
            pixelsP = pixelsP + double(1);
            sumValsP = sumValsP + double(blur(x,y));
            xP = xP + x;
            yP = yP + y;
        else
            pixelsB = pixelsB + double(1);
            sumValsB = sumValsB + double(blur(x,y));
            xB = xB + x;
            yB = yB + y;
        end
    end
end
    
discriminants=(3);
X_t = (double(3));

meanP(1) = sumValsP / pixelsP;
meanP(2) = xP / pixelsP;
meanP(3) = yP / pixelsP;

meanH(1) = sumValsH / pixelsH;
meanH(2) = xH / pixelsH;
meanH(3) = yH / pixelsH;

meanB(1) = sumValsB / pixelsB;
meanB(2) = xB / pixelsB;
meanB(3) = yB / pixelsB;


filteredImg = blur;

for x=1:nRows
    for y=1:nCols
        X_t(1) = blur(x,y);
        X_t(2) = x;
        X_t(3) = y;
        
        difP = double(X_t) - meanP;
        difH = double(X_t) - meanH;
        difB = double(X_t) - meanB;

        discriminants(1) = -1/2 * difP * inv(covP) * difP' -1/2 * log(det(covP)) + log(probP);
        discriminants(2) = -1/2 * difH * inv(covH) * difH' -1/2 * log(det(covH)) + log(probH);
        discriminants(3) = -1/2 * difB * inv(covB) * difB' -1/2 * log(det(covB)) + log(probB);
        %discriminants
        
        if (discriminants(1) > discriminants(2)) && (discriminants(1) > discriminants(3))
            filteredImg(x,y) = 255;
        elseif (discriminants(2) > discriminants(1)) && (discriminants(2) > discriminants(3))
            filteredImg(x,y) = 128;
        else
            filteredImg(x,y) = 0;
        end
    end
end

figure();
imagesc(filteredImg);
colormap gray;

