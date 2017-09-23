function cuttedImg = Cut( image )
    cuttedImg = imcrop(image,[120 110 420 350]);
end

function blur = Blur( grayImage )

    pascal13=[1 12 66 220 495 792 924 792 495 220 66 12 1];
    matrizGausiana13=pascal13'*pascal13/(sum(pascal13)^2);
    blur=uint8(conv2(grayImage,matrizGausiana13,'same'));

end

function [pixelsP, pixelsH, pixelsB] = countPixels( image )
    [nRows,nCols] = size(image);
    for x=1:nRows
        for y=1:nCols
            if image(x,y)>=graylevelAverageHalo
                pixelsH = pixelsH + 1;
            elseif (image(x,y)<graylevelAverageHalo) && (image(x,y)>=graylevelAverageProstate)
                pixelsP = pixelsP + 1;
            else
                pixelsB = pixelsB + 1;
            end
        end
    end
end

function xyBack = positionsback(xyHalo,xyPros,image)
    xyBack=[1,1];
    [nRows,nCols] = size(image);
    [nr1,nc1]=size(xyHalo);
    [nr2,nc2]=size(xyPros);
    for x=1:nRows
        for y=1:nCols
            for i=1:nr1
                if xyHalo(i,:)~= [x,y]
                    xyBack=[xyBack;x,y];
                    break
                end
            end
            for i=1:nr2
                if xyPros(i,:)~= [x,y]
                    xyBack=[xyBack;x,y];
                    break
                end
            end
        end
    end
end
%Tengo una duda con la formula del discriminante bayesiano. Segun como la
%veo, si multiplican escalares por la inversa de una matriz. ¿Eso no
%regresa una matriz?

%%Falta implementar la funcion que regrese las funciones de bayes.



