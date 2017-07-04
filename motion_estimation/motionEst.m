clc;
clear all;
close all;

mbSize = 16;
p = 7;

image_I = imread('19.jpg');
image_P = imread('18.jpg');

fig_1 = figure(1);
set(fig_1, 'name', 'Fig1:当前帧与预测帧', 'Numbertitle', 'off');
subplot(121);imshow(image_I);title('当前帧');
subplot(122);imshow(image_P);title('参考帧');

imgI = double(rgb2gray(image_I));
imgP = double(rgb2gray(image_P));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(height/mbSize, width/mbSize);
mvy = zeros(height/mbSize, width/mbSize);

%%  选用不同的算法得到运动向量图、预测帧和残差帧
%% 全搜索法

motionVectES = motionEstES(imgP, imgI, mbSize, p);

%绘制运动向量图
a = zeros(1, width * height / mbSize^2);
a(:) = motionVectES(1,1:width * height / mbSize^2);
b = zeros(1, width * height / mbSize^2);
b(:) = motionVectES(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% 运动向量的x坐标
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% 运动向量的y坐标
    end
end

fig_2 = figure(2);
set(fig_2, 'name', 'Fig2:全搜索——运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVectES, mbSize);
I1 = uint8(imgComp(1: height - 8,1: width));
fig_3 = figure(3);
set(fig_3, 'name', 'Fig3:全搜索——预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_4 = figure(4);
set(fig_4, 'name', 'Fig4:全搜索——残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');

%% 对数搜索法

motionVectTSS = motionEstTSS(imgP, imgI, mbSize, p);

%绘制运动向量图
a = zeros(1, width * height / mbSize^2);
a(:) = motionVectTSS(1,1:width * height / mbSize^2);
b = zeros(1,width * height / mbSize^2);
b(:) = motionVectTSS(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% 运动向量的x坐标
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% 运动向量的y坐标
    end
end

fig_5 = figure(5);
set(fig_5, 'name', 'Fig5:对数搜索——运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVectTSS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_6 = figure(6);
set(fig_6, 'name', 'Fig6:对数搜索——预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1 : height - mbSize / 2
    for j = 1 : width
        canc(i, j) = 255 - abs(imgP(i, j) - imgComp(i, j));
    end
end
fig_7 = figure(7);
set(fig_7, 'name', 'Fig7:对数搜索——残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');

%% 四步搜索法

motionVect4SS = motionEst4SS(imgP, imgI, mbSize, p);

%绘制运动向量图
a = zeros(1, width * height / mbSize^2);
a(:) = motionVect4SS(1,1:width * height / mbSize^2);
b = zeros(1,width * height / mbSize^2);
b(:) = motionVect4SS(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% 运动向量的x坐标
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% 运动向量的y坐标
    end
end

fig_8 = figure(8);
set(fig_8, 'name', 'Fig8:四步搜索——运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVect4SS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_9 = figure(9);
set(fig_9, 'name', 'Fig9:四步搜索——预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_10 = figure(10);
set(fig_10, 'name', 'Fig10:四步搜索——残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');

%% 菱形搜索法

motionVectDS = motionEstDS(imgP, imgI, mbSize, p);

%绘制运动向量图
a = zeros(1, width * height / mbSize^2);
a(:) = motionVectDS(1,1:width * height / mbSize^2);
b = zeros(1,width * height / mbSize^2);
b(:) = motionVectDS(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% 运动向量的x坐标
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% 运动向量的y坐标
    end
end

fig_11 = figure(11);
set(fig_11, 'name', 'Fig11:菱形搜索——运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVectDS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_12 = figure(12);
set(fig_12, 'name', 'Fig12:菱形搜索——预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_13 = figure(13);
set(fig_13, 'name', 'Fig13:菱形搜索——残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');