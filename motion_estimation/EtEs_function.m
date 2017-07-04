function EtEs_function(image_I, image_P)

mbSize = 16;
p = 7;

figure;
subplot(121);imshow(image_I);title('当前帧');
subplot(122);imshow(image_P);title('参考帧');

imgI = double(rgb2gray(image_I));
imgP = double(rgb2gray(image_P));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(floor(height/mbSize), floor(width/mbSize));
mvy = zeros(floor(height/mbSize), floor(width/mbSize));

%% 全搜索法

motionVectES = motionEstES(imgP, imgI, mbSize, p);

%绘制运动向量图
a = zeros(1, floor(width * height / mbSize^2));
a(:) = motionVectES(1,floor(1:width * height / mbSize^2));
b = zeros(1, floor(width * height / mbSize^2));
b(:) = motionVectES(2,1:floor(width * height / mbSize^2));
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, floor(j+(i-1) * (width / mbSize)));% 运动向量的x坐标
        mvy(i, j) = -(a(1, floor(j+(i-1) * (width / mbSize))));% 运动向量的y坐标
    end
end

figure;
quiver(flipud(mvx), flipud(mvy));% flipud函数上下翻转矩阵
title('运动向量图'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);