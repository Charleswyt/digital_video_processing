% This script uses all the Motion Estimation algorithms written for the
% final project and save their results.
% The algorithms being used are Exhaustive Search, Three Step Search, New
% Three Step Search, Simple and Efficient Search, Four Step Search, Diamond
% Search, and Adaptive Rood Pattern Search.
%
%
% Aroh Barjatya
% For DIP ECE 6620 final project Spring 2004

%close all
%clear all

% the directory and files will be saved based on the image name
% Thus we just change the sequence / image name and the whole analysis is
% done for that particular sequence

imageName = 'caltrain';
mbSize = 16;
p = 7;

for i = 20:20

    imgINumber = i;
    imgPNumber = i+2;

    if imgINumber < 10
        imgIFile = sprintf('./%s/gray/%s00%d.ras',imageName, imageName, imgINumber);
    elseif imgINumber < 100
        imgIFile = sprintf('./%s/gray/%s0%d.ras',imageName, imageName, imgINumber);
    end

    if imgPNumber < 10
        imgPFile = sprintf('./%s/gray/%s00%d.ras',imageName, imageName, imgPNumber);
    elseif imgPNumber < 100
        imgPFile = sprintf('./%s/gray/%s0%d.ras',imageName, imageName, imgPNumber);
    end

    imgI = double(imread(imgIFile));
    imgP = double(imread(imgPFile));
    imgI = imgI(:,1:512);
    imgP = imgP(:,1:512);

    % Three Step Search
    [motionVect,computations ] = motionEstTSS(imgP,imgI,mbSize,p);
    imgComp = motionComp(imgI, motionVect, mbSize);
    imgRes0 = Residual(imgI,imgP,mbSize);
    imgRes = Residual(imgP,imgComp,mbSize);
    TSSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
    TSScomputations(i+1) = computations;
    
    u=zeros(512/mbSize,400/mbSize);
    v=zeros(512/mbSize,400/mbSize);

    for j=1:512/mbSize
        for k=1:400/mbSize
        u(k,j) = motionVect(2,(k-1)*512/mbSize+j);
        v(k,j) = motionVect(1,(k-1)*512/mbSize+j);
        end
    end

    gridx=zeros(512/mbSize,400/mbSize);
    gridy=zeros(512/mbSize,400/mbSize);
    for j=1:512/mbSize
        for k=1:400/mbSize
        gridx(k,j) = j*mbSize;
        gridy(k,j) = k*mbSize;
        end
    end
    
    figure;
    subplot(2,2,1);
    imshow(imgI,[0 511]);
    
    t1 = num2str(computations);
    t1 = strcat('Computations = ',t1);
    text(200,-30,t1);
    
    t2 = num2str(TSSpsnr(i+1));
    t2 = strcat('PSNR = ',t2);
    text(1100,-30,t2);
    
    text(600,-60,'Èý²½ËÑË÷·¨');
    
    subplot(2,2,2);
    imshow(imgP,[0 511]);
    hold on;
    quiver(gridx,gridy,u,v,1,'g','filled');
    
    subplot(2,2,3);
    imshow(imgRes0,[0 511]);
    
    subplot(2,2,4);
    imshow(imgRes,[0 511]);
end