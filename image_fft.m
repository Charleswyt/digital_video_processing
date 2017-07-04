clc;
clear all;
close all;

image_name_1 = 'lena_gray.bmp';
image_name_2 = 'Barbara.bmp';

%% 灰度图1_傅里叶变换及其幅度谱、相位谱
image_1 = imread(image_name_1);% 读取图像
image_1_double = double(image_1);% 将图像转换为double类型
image_spectrum_1 = fft2(image_1_double);% 对图像做傅里叶变换，获取频谱
image_spectrum_1 = fftshift(image_spectrum_1);% 将fft的DC分量移到频谱中心
image_magnitude_1 = abs(image_spectrum_1);% 幅度谱
image_phase_1 = angle(image_spectrum_1);% 相位谱

%% 灰度图2_傅里叶变换及其幅度谱、相位谱
image_2 = imread(image_name_2);% 读取图像
image_2_double = double(image_2);% 将图像转换为double类型
image_spectrum_2 = fft2(image_2_double);% 对图像做傅里叶变换，获取频谱
image_spectrum_2 = fftshift(image_spectrum_2);% 将fft的DC分量移到频谱中心
image_magnitude_2 = abs(image_spectrum_2);% 幅度谱
image_phase_2 = angle(image_spectrum_2);% 相位谱

fig_1 = figure(1);
set(fig_1, 'name', 'Fig1:灰度图1', 'Numbertitle', 'off');
subplot(211);imshow(image_1);title('图像1');
subplot(223);imshow(log(1 + image_magnitude_1), []);title('对数幅度谱');
subplot(224);imshow(image_phase_1, []);title('相位谱');

fig_2 = figure(2);
set(fig_2, 'name', 'Fig2:灰度图2', 'Numbertitle', 'off');
subplot(211);imshow(image_2);title('图像2');
subplot(223);imshow(log(1 + image_magnitude_2), []);title('对数幅度谱');
subplot(224);imshow(image_phase_2, []);title('相位谱');

%% 新式傅立叶变换——用相位谱和幅度谱代替原频谱
% 用相位谱代替原频谱
image_new_spectrum_1 = 128 * exp(1j * image_phase_1);
image_new_spectrum_1 = ifftshift(image_new_spectrum_1);
image_new_1 = ifft2(image_new_spectrum_1);
image_new_1 = uint8(image_new_1);

% 用幅度谱代替原频谱
image_new_spectrum_2 = image_magnitude_1;
image_new_spectrum_2 = ifftshift(image_new_spectrum_2);
image_new_2 = ifft2(image_new_spectrum_2);
image_new_2 = uint8(image_new_2);

%% 新式傅立叶变换——交换两幅图像的相位谱和幅度谱
% 图1的幅度谱与图2的相位谱相结合
image_new_spectrum_3 = image_magnitude_1 .* exp(1j * image_phase_2);
image_new_spectrum_3 = ifftshift(image_new_spectrum_3);
image_new_3 = ifft2(image_new_spectrum_3);
image_new_3 = uint8(image_new_3);

% 图2的幅度谱与图1的相位谱相结合
image_new_spectrum_4 = image_magnitude_2 .* exp(1j * image_phase_1);
image_new_spectrum_4 = ifftshift(image_new_spectrum_4);
image_new_4 = ifft2(image_new_spectrum_4);
image_new_4 = uint8(image_new_4);

fig_3 = figure(3);
set(fig_3, 'name', 'Fig3:新式傅立叶变换', 'Numbertitle', 'off');
subplot(221);imshow(image_new_1, []);title('图像1（幅度恒为256 + 图1相位谱）');
subplot(222);imshow(image_new_2, []);title('图像2（图1幅度谱 + 相位谱恒为0）');
subplot(223);imshow(image_new_3, []);title('图像3（图1幅度谱 + 图2相位谱）');
subplot(224);imshow(image_new_4, []);title('图像4（图2幅度谱 + 图1相位谱）');