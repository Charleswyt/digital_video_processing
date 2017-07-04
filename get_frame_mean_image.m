function mean_image = get_frame_mean_image(frame_sequence_path, total_frame_number)

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% 获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);% 获取图像总数量

if img_num < total_frame_number
    total_frame_number = img_num;
end

% 在计算过程中一定要将图像转换为double类型，否则输出图像会变黑
image_name = img_path_list(1).name;% 图像名
image =  imread(strcat(frame_sequence_path, image_name));% 打开图像
image_sum = double(image);

for j = 2 : total_frame_number% 逐一读取图像
    image_name = img_path_list(j).name;% 图像名
    image =  imread(strcat(frame_sequence_path, image_name));% 打开图像
    image_double = double(image);
    
    %------- 图像处理过程 -------%
    
    image_sum = image_sum + image_double;
    
    %----------- End -----------%
end
mean_image = image_sum / total_frame_number;
mean_image = uint8(mean_image);
end