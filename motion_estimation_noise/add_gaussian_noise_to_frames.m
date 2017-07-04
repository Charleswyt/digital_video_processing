function add_gaussian_noise_to_frames(frame_sequence_path, frame_noise_sequence_path, mean, variance)

%%
% frame_sequence_path = '.\frame_sequence\'
% frame_noise_sequence_path = '.\frame_noise_sequence\'
% mean = 0
% variance = 0.1

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% 获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);% 获取图像总数量
if img_num > 0% 有满足条件的图像
    for j = 1:img_num% 逐一读取图像
        image_name = img_path_list(j).name;% 图像名
        image =  imread(strcat(frame_sequence_path, image_name));% 打开图像
        dot_index = strfind(image_name, '.');% 获取dot的位置
        image_write_name = strcat(frame_noise_sequence_path, image_name(1:dot_index - 1), '_noise', '.jpg');% 输出图像名
        
        %------- 图像处理过程 -------%
        iamge_noise = imnoise(image, 'gaussian', mean, variance);
        imwrite(iamge_noise, image_write_name);
        %----------- End -----------%
    end
end