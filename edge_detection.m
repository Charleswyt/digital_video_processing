clc;
clear all;
close all;

%% 读取RGB图像，分别获取其三通道
image_RGB = imread('RGB.jpg');
[high, width, channel_num] = size(image_RGB);
image_RGB_R = image_RGB(:, :, 1);
image_RGB_G = image_RGB(:, :, 2);
image_RGB_B = image_RGB(:, :, 3);

fig_1 = figure(1);
set(fig_1, 'name', 'Fig 1:RGB图像', 'Numbertitle', 'off');
subplot(221);imshow(image_RGB);title('RGB图像');
subplot(222);imshow(image_RGB_R);title('R通道');
subplot(223);imshow(image_RGB_G);title('G通道');
subplot(224);imshow(image_RGB_B);title('B通道');

%% RGB图像转YCrCb图像
 image_YCrCb_Y  = 0.299 * image_RGB_R + 0.587 * image_RGB_G + 0.114 * image_RGB_B;
 image_YCrCb_Cb = -0.169 * image_RGB_R - 0.331 * image_RGB_G + 0.500 * image_RGB_B + 128;
 image_YCrCb_Cr = 0.500 * image_RGB_R - 0.419 * image_RGB_G - 0.081 * image_RGB_B + 128;
 image_YCrCb = cat(3, image_YCrCb_Y, image_YCrCb_Cb, image_YCrCb_Cr);
 
fig_2 = figure(2);
set(fig_2, 'name', 'Fig 2:YCrCb图像', 'Numbertitle', 'off');
subplot(221);imshow(image_YCrCb);title('YCrCb图像');
subplot(222);imshow(image_YCrCb_Y);title('Y通道');
subplot(223);imshow(image_YCrCb_Cb);title('Cb通道');
subplot(224);imshow(image_YCrCb_Cr);title('Cr通道');

%% 分别使用Sobel、Prewitt、LoG、Canny方法进行YCrCb图像的Y通道进行边缘提取
%% 无噪情形下的边缘提取
image_YCrCb_Y_edge_sobel = edge(image_YCrCb_Y, 'sobel');
image_YCrCb_Y_edge_prewitt = edge(image_YCrCb_Y, 'prewitt');
image_YCrCb_Y_edge_LoG = edge(image_YCrCb_Y, 'log');
image_YCrCb_Y_edge_canny = edge(image_YCrCb_Y, 'canny');

fig_3 = figure(3);
set(fig_3, 'name', 'Fig 3:基于YCrCb图像Y通道的边缘提取', 'Numbertitle', 'off');
subplot(221);imshow(image_YCrCb_Y_edge_sobel);title('Sobel算子');
subplot(222);imshow(image_YCrCb_Y_edge_prewitt);title('prewitt算子');
subplot(223);imshow(image_YCrCb_Y_edge_LoG);title('log算子');
subplot(224);imshow(image_YCrCb_Y_edge_canny);title('canny算子');

%% 加噪情形下的边缘提取，分别测试高斯噪声、椒盐噪声以及两种噪声的混合
%% 高斯噪声，均值为0，方差为0.001
image_YCrCb_Y_gaussian_noise = imnoise(image_YCrCb_Y, 'gaussian', 0, 0.001);
image_YCrCb_Y_gaussian_noise_edge_sobel = edge(image_YCrCb_Y_gaussian_noise, 'sobel');
image_YCrCb_Y_gaussian_noise_edge_prewitt = edge(image_YCrCb_Y_gaussian_noise, 'prewitt');
image_YCrCb_Y_gaussian_noise_edge_LoG = edge(image_YCrCb_Y_gaussian_noise, 'log');
image_YCrCb_Y_gaussian_noise_edge_canny = edge(image_YCrCb_Y_gaussian_noise, 'canny');

fig_4 = figure(4);
set(fig_4, 'name', 'Fig 4:0.001方差高斯噪声下YCrCb图像Y通道图像', 'Numbertitle', 'off');
subplot(121);imshow(image_YCrCb_Y_gaussian_noise);title('高斯噪声下YCrCb图像Y通道图像');
subplot(122);imshow(image_YCrCb_Y);title('无噪YCrCb图像Y通道图像');

fig_5 = figure(5);
set(fig_5, 'name', 'Fig 5:0.001方差高斯噪声下YCrCb图像Y通道的边缘提取', 'Numbertitle', 'off');
subplot(221);imshow(image_YCrCb_Y_gaussian_noise_edge_sobel);title('Sobel算子');
subplot(222);imshow(image_YCrCb_Y_gaussian_noise_edge_prewitt);title('prewitt算子');
subplot(223);imshow(image_YCrCb_Y_gaussian_noise_edge_LoG);title('log算子');
subplot(224);imshow(image_YCrCb_Y_gaussian_noise_edge_canny);title('canny算子');

%% 高斯噪声，均值为0，方差为0.01
image_YCrCb_Y_gaussian_noise = imnoise(image_YCrCb_Y, 'gaussian', 0, 0.01);
image_YCrCb_Y_gaussian_noise_edge_sobel = edge(image_YCrCb_Y_gaussian_noise, 'sobel');
image_YCrCb_Y_gaussian_noise_edge_prewitt = edge(image_YCrCb_Y_gaussian_noise, 'prewitt');
image_YCrCb_Y_gaussian_noise_edge_LoG = edge(image_YCrCb_Y_gaussian_noise, 'log');
image_YCrCb_Y_gaussian_noise_edge_canny = edge(image_YCrCb_Y_gaussian_noise, 'canny');

fig_6 = figure(6);
set(fig_6, 'name', 'Fig 6:0.01方差高斯噪声下YCrCb图像Y通道图像', 'Numbertitle', 'off');
subplot(121);imshow(image_YCrCb_Y_gaussian_noise);title('高斯噪声下YCrCb图像Y通道图像');
subplot(122);imshow(image_YCrCb_Y);title('无噪YCrCb图像Y通道图像');

fig_7 = figure(7);
set(fig_7, 'name', 'Fig 7:0.01方差高斯噪声下YCrCb图像Y通道的边缘提取', 'Numbertitle', 'off');
subplot(221);imshow(image_YCrCb_Y_gaussian_noise_edge_sobel);title('Sobel算子');
subplot(222);imshow(image_YCrCb_Y_gaussian_noise_edge_prewitt);title('prewitt算子');
subplot(223);imshow(image_YCrCb_Y_gaussian_noise_edge_LoG);title('log算子');
subplot(224);imshow(image_YCrCb_Y_gaussian_noise_edge_canny);title('canny算子');

%% 椒盐噪声，强度为0.01
image_YCrCb_Y_salt_noise = imnoise(image_YCrCb_Y, 'salt & pepper', 0.01);
image_YCrCb_Y_salt_noise_edge_sobel = edge(image_YCrCb_Y_salt_noise, 'sobel');
image_YCrCb_Y_salt_noise_edge_prewitt = edge(image_YCrCb_Y_salt_noise, 'prewitt');
image_YCrCb_Y_salt_noise_edge_LoG = edge(image_YCrCb_Y_salt_noise, 'log');
image_YCrCb_Y_salt_noise_edge_canny = edge(image_YCrCb_Y_salt_noise, 'canny');

fig_8 = figure(8);
set(fig_8, 'name', 'Fig 8:0.01强度椒盐噪声下YCrCb图像Y通道图像', 'Numbertitle', 'off');
subplot(121);imshow(image_YCrCb_Y_salt_noise);title('椒盐噪声下YCrCb图像Y通道图像');
subplot(122);imshow(image_YCrCb_Y);title('无噪YCrCb图像Y通道图像');

fig_9 = figure(9);
set(fig_9, 'name', 'Fig 9:0.01强度椒盐噪声下YCrCb图像Y通道的边缘提取', 'Numbertitle', 'off');
subplot(221);imshow(image_YCrCb_Y_salt_noise_edge_sobel);title('Sobel算子');
subplot(222);imshow(image_YCrCb_Y_salt_noise_edge_prewitt);title('prewitt算子');
subplot(223);imshow(image_YCrCb_Y_salt_noise_edge_LoG);title('log算子');
subplot(224);imshow(image_YCrCb_Y_salt_noise_edge_canny);title('canny算子');

%% 椒盐噪声，强度为0.1
image_YCrCb_Y_salt_noise = imnoise(image_YCrCb_Y, 'salt & pepper', 0.1);
image_YCrCb_Y_salt_noise_edge_sobel = edge(image_YCrCb_Y_salt_noise, 'sobel');
image_YCrCb_Y_salt_noise_prewitt = edge(image_YCrCb_Y_salt_noise, 'prewitt');
image_YCrCb_Y_salt_noise_LoG = edge(image_YCrCb_Y_salt_noise, 'log');
image_YCrCb_Y_salt_noise_canny = edge(image_YCrCb_Y_salt_noise, 'canny');

fig_10 = figure(10);
set(fig_10, 'name', 'Fig 10:0.1强度椒盐噪声下YCrCb图像Y通道图像', 'Numbertitle', 'off');
subplot(121);imshow(image_YCrCb_Y_salt_noise);title('椒盐噪声下YCrCb图像Y通道图像');
subplot(122);imshow(image_YCrCb_Y);title('无噪YCrCb图像Y通道图像');

fig_11 = figure(11);
set(fig_11, 'name', 'Fig 11:0.1强度椒盐噪声下YCrCb图像Y通道的边缘提取', 'Numbertitle', 'off');
subplot(221);imshow(image_YCrCb_Y_salt_noise_edge_sobel);title('Sobel算子');
subplot(222);imshow(image_YCrCb_Y_salt_noise_edge_prewitt);title('prewitt算子');
subplot(223);imshow(image_YCrCb_Y_salt_noise_edge_LoG);title('log算子');
subplot(224);imshow(image_YCrCb_Y_salt_noise_edge_canny);title('canny算子');

%% 高斯噪声+椒盐噪声
image_YCrCb_Y_gaussian_noise = imnoise(image_YCrCb_Y, 'gaussian', 0, 0.001);
image_YCrCb_Y_gaussian_salt_noise = imnoise(image_YCrCb_Y_gaussian_noise, 'salt & pepper', 0.01);
image_YCrCb_Y_gaussian_salt_edge_sobel = edge(image_YCrCb_Y_gaussian_salt_noise, 'sobel');
image_YCrCb_Y_gaussian_salt_edge_prewitt = edge(image_YCrCb_Y_gaussian_salt_noise, 'prewitt');
image_YCrCb_Y_gaussian_salt_edge_LoG = edge(image_YCrCb_Y_gaussian_salt_noise, 'log');
image_YCrCb_Y_gaussian_salt_edge_canny = edge(image_YCrCb_Y_gaussian_salt_noise, 'canny');

fig_12 = figure(12);
set(fig_12, 'name', 'Fig 12:混合噪声下YCrCb图像Y通道图像', 'Numbertitle', 'off');
subplot(121);imshow(image_YCrCb_Y_gaussian_noise);title('混合噪声下YCrCb图像Y通道图像');
subplot(122);imshow(image_YCrCb_Y);title('无噪YCrCb图像Y通道图像');

fig_13 = figure(13);
set(fig_13, 'name', 'Fig 13:混合噪声下YCrCb图像Y通道的边缘提取', 'Numbertitle', 'off');
subplot(221);imshow(image_YCrCb_Y_gaussian_salt_edge_sobel);title('Sobel算子');
subplot(222);imshow(image_YCrCb_Y_gaussian_salt_edge_prewitt);title('prewitt算子');
subplot(223);imshow(image_YCrCb_Y_gaussian_salt_edge_LoG);title('log算子');
subplot(224);imshow(image_YCrCb_Y_gaussian_salt_edge_canny);title('canny算子');