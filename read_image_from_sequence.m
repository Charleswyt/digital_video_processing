function image = read_image_from_sequence(frame_sequence_path, current_image_number)

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% 获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);% 获取图像总数量

if img_num < current_image_number
    current_image_number = img_num;
end

image_name = img_path_list(current_image_number).name;% 图像名
image =  imread(strcat(frame_sequence_path, image_name));% 打开图像

end