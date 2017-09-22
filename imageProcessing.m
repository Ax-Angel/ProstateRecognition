clear
clc

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
xyposition = getPosition(hFH);
[m,n] = size(xyposition);
graylevel=0;
for x=1:m
    for y=1:n
        graylevel = graylevel + xyposition(x,y);
    end
end
graylevelAverageProstate = graylevel / m*n;

%Getting grayscale average for halo
hFH = imfreehand();
xyposition = getPosition(hFH);
[m,n] = size(xyposition);
graylevel=0;
for x=1:m
    for y=1:n
        graylevel = graylevel + xyposition(x,y);
    end
end
graylevelAverageHalo = graylevel / m*n;
