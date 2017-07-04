%% 新三步搜索法
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

fig_2 = figure(2);
set(fig_2, 'name', 'Fig2:新三步搜索——运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVectDS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_3 = figure(3);
set(fig_3, 'name', 'Fig3:新三步搜索——预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_4 = figure(4);
set(fig_4, 'name', 'Fig4:新三步搜索——残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');