img = imread('Imagenes/an-u3-15-03.tif');
cuttedImg = imcrop(img,[120 110 420 350]);

pascal13=[1 12 66 220 495 792 924 792 495 220 66 12 1];
matrizGausiana13=pascal13'*pascal13/(sum(pascal13)^2);
blur=uint8(conv2(cuttedImg,matrizGausiana13,'same'));

pixelsH=double(0);
pixelsP=double(0);
pixelsB=double(0);
xP=double(0);
yP=double(0);
xH=double(0);
yH=double(0);
xB=double(0);
yB=double(0);
[nRows,nCols] = size(blur);
for x=1:nRows
    for y=1:nCols
        if (blur(x,y)>graylevelAverageProstate(1))
            pixelsH = pixelsH + double(blur(x,y));
            xH = xH + x;
            yH = yH + y;
        elseif (blur(x,y)>graylevelAverageBack(1)) 
            pixelsP = pixelsP + double(blur(x,y));
            xP = xP + x;
            yP = yP + y;
        else
            pixelsB = pixelsB + double(blur(x,y));
            xB = xB + x;
            yB = yB + y;
        end
    end
end
    
[nRows, nColumns] = size(blur);
discriminants=(3);
X_t = (double(3));

meanP(1) = pixelsP / (nRows*nColumns);
meanP(2) = xP / (nRows);
meanP(3) = yP / (nColumns);

meanH(1) = pixelsH / (nRows*nColumns);
meanH(2) = xH / (nRows);
meanH(3) = yH / (nColumns);

meanB(1) = pixelsB / (nRows*nColumns);
meanB(2) = xB / (nRows);
meanB(3) = yB / (nColumns);


filteredImg = blur;

for x=1:nRows
    for y=1:nColumns
        X_t(1) = blur(x,y);
        X_t(2) = x;
        X_t(3) = y;
        
        difP = double(X_t) - meanP;
        difH = double(X_t) - meanH;
        difB = double(X_t) - meanB;

        discriminants(1) = -1/2 * difP' * inv(covP) * difP -1/2 * log(det(covP)) + log(probP)
        discriminants(2) = -1/2 * difH' * inv(covH) * difH -1/2 * log(det(covH)) + log(probH)
        discriminants(3) = -1/2 * difB' * inv(covB) * difB -1/2 * log(det(covB)) + log(probB) 
        
        if (discriminants(1) > discriminants(2)) && (discriminants(1) > discriminants(3))
            filteredImg(x,y) = 250;
        elseif (discriminants(2) > discriminants(1)) && (discriminants(2) > discriminants(3))
            filteredImg(x,y) = 128;
        else
            filteredImg(x,y) = 0;
        end
    end
end

imagesc(filteredImg);
colormap gray;

