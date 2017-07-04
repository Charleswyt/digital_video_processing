clc;
clear all;
close all;

video_name = 'singleball.avi';% 视频文件名
frame_sequence_path = '.\frame_sequence\';
total_frame_number = 30;% 待处理视频帧总数
frame_number = 10;
reference_frame_number = 15;
current_image_number = reference_frame_number + 1;% 当前视频帧

% 获取视频参数信息
show_video_info(video_name);

% 提取视频帧
get_frame_sequence(video_name, frame_sequence_path, total_frame_number);

% 获取多帧图像的平均值并显示
mean_image_10 = get_frame_mean_image(frame_sequence_path, frame_number);
fig_1 = figure(1);
set(fig_1,'name', 'Fig_1：均值图像', 'Numbertitle', 'off');
imshow(mean_image_10);
title(strcat('前', num2str(reference_frame_number), '帧图像的平均值图像'));

% 获取多帧图像的中值并显示
median_image_10 = get_frame_median_image(frame_sequence_path, frame_number);
fig_2 = figure(2);
set(fig_2, 'name', 'Fig_2：中值图像', 'Numbertitle', 'off');
imshow(median_image_10);
title(strcat('前', num2str(reference_frame_number), '帧图像的中值图像'));

% 读取视频流中的特定帧
image_current = read_image_from_sequence(frame_sequence_path, current_image_number);

%% 将平均值模型和中值模型应用于当前图像帧
% 平均值模型
mean_image = get_frame_mean_image(frame_sequence_path, reference_frame_number);
image_difference_mean = image_current - mean_image;
image_difference_mean = uint8(image_difference_mean);
fig_3 = figure(3);
set(fig_3, 'name', 'Fig_3：当前帧与平均帧的差值图像', 'Numbertitle', 'off');
imshow(image_difference_mean);
title('当前帧与平均帧的差值图像');

% 中值模型
median_image = get_frame_median_image(frame_sequence_path, reference_frame_number);
image_difference_median = image_current - median_image;
image_difference_median = uint8(image_difference_median);
fig_4 = figure(4);
set(fig_4, 'name', 'Fig_4：当前帧与中值帧的差值图像', 'Numbertitle', 'off');
imshow(image_difference_median);
title('当前帧与中值帧的差值图像');

fig_5 = figure(5);
set(fig_5, 'name', 'Fig_5：均值法和中值法结果差异(幅度扩大128倍)', 'Numbertitle', 'off');
dif = 128 * uint8(image_difference_mean - image_difference_median);
imshow(rgb2gray(dif));
title('均值法和中值法结果差异');
