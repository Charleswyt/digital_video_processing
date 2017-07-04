mbSize = 16;
p = 7;

%% 原始帧
image_I = imread('15.jpg');
image_P = imread('14.jpg');

fig_1 = figure(1);
set(fig_1, 'name', 'Fig1:当前帧与参考帧', 'Numbertitle', 'off');
subplot(121);imshow(image_I);title('当前帧');
subplot(122);imshow(image_I);title('参考帧');

imgI = double(rgb2gray(image_I));
imgP = double(rgb2gray(image_P));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(height/mbSize, width/mbSize);
mvy = zeros(height/mbSize, width/mbSize);

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
set(fig_2, 'name', 'Fig2:原始视频运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVectES, mbSize);
I1 = uint8(imgComp(1: height - 8,1: width));
fig_3 = figure(3);
set(fig_3, 'name', 'Fig3:原始视频预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_4 = figure(4);
set(fig_4, 'name', 'Fig4:原始视频残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');

%% 加噪帧
image_I_noise = imread('14_noise.jpg');
image_P_noise = imread('15_noise.jpg');

fig_5 = figure(5);
set(fig_5, 'name', 'Fig5:当前帧与参考帧', 'Numbertitle', 'off');
subplot(121);imshow(image_I_noise);title('当前帧');
subplot(122);imshow(image_P_noise);title('参考帧');

imgI = double(rgb2gray(image_I_noise));
imgP = double(rgb2gray(image_P_noise));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(height/mbSize, width/mbSize);
mvy = zeros(height/mbSize, width/mbSize);

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

fig_6 = figure(6);
set(fig_6, 'name', 'Fig6:加噪视频运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVectES, mbSize);
I1 = uint8(imgComp(1: height - 8,1: width));
fig_7 = figure(7);
set(fig_7, 'name', 'Fig7:加噪视频预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_8 = figure(8);
set(fig_8, 'name', 'Fig8:加噪视频残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');

%% 滤波
imgI = double(wiener2(rgb2gray(image_I_noise), [16,16]));
imgP = double(wiener2(rgb2gray(image_P_noise), [16,16]));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(height/mbSize, width/mbSize);
mvy = zeros(height/mbSize, width/mbSize);

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

fig_9 = figure(9);
set(fig_9, 'name', 'Fig9:去噪视频运动向量图', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% 绘制预测帧
imgComp = motionComp(imgI, motionVectES, mbSize);
I1 = uint8(imgComp(1: height - 8,1: width));
fig_10 = figure(10);
set(fig_10, 'name', 'Fig10:去噪视频预测帧', 'Numbertitle', 'off');
imshow(I1);title('预测帧');

% 绘制残差图
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_11 = figure(11);
set(fig_11, 'name', 'Fig11:去噪视频残差帧', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('残差帧');