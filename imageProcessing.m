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