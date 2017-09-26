img = imread('Imagenes/an-u3-15-03.tif');
cuttedImg = imcrop(img,[120 110 420 350]);

pascal13=[1 12 66 220 495 792 924 792 495 220 66 12 1];
matrizGausiana13=pascal13'*pascal13/(sum(pascal13)^2);
blur=uint8(conv2(cuttedImg,matrizGausiana13,'same'));

pixelsH=double(0);
pixelsP=double(0);
pixelsB=double(0);

[nRows,nCols] = size(blur);
for x=1:nRows
    for y=1:nCols
        if (blur(x,y)>=graylevelAverageProstate) && (blur(x,y)<=graylevelAverageHalo)
            pixelsP = pixelsP + double(1);
            blur(x,y);
        elseif (blur(x,y)<=graylevelAverageProstate) && (blur(x,y)>=graylevelAverageHalo)
            pixelsH = pixelsH + double(1);
        else
            pixelsB = pixelsB + double(1);
        end
    end
end


%Tengo una duda con la formula del discriminante bayesiano. Segun como la
%veo, si multiplican escalares por la inversa de una matriz. �Eso no
%regresa una matriz?

%%Falta implementar la funcion que regrese las funciones de bayes.

[nRows, nColumns] = size(blur);

difP = 0;
difH = 0;
difPB = 0;

discriminants=[3];

meanP = pixelsP / nRows*nColumns;
meanH = pixelsH / nRows*nColumns;
meanB = pixelsB / nRows*nColumns;

for x=1:nRows
    for y=1:nColumns
        difP = blur(x,y) - meanP;
        difH = blur(x,y) - meanH;
        difB = blur(x,y) - meanB;

        discriminants(1) = -1/2 * difP' * inv(covP) * difP -1/2 * log(det(covP)) + log(probP);
        discriminants(2) = -1/2 * difH' * inv(covH) * difH -1/2 * log(det(covH)) + log(probH);
        discriminants(3) = -1/2 * difB' * inv(covB) * difP -1/2 * log(det(covB)) + log(probB);
    end
end

