function median_image = get_frame_median_image(frame_sequence_path, total_frame_number)

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% 获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);% 获取图像总数量

if img_num < total_frame_number
    total_frame_number = img_num;
end

median_image = [ ];

for j = 1 : total_frame_number% 逐一读取图像
    image_name = img_path_list(j).name;% 图像名
    image =  imread(strcat(frame_sequence_path, image_name));% 打开图像
    median_image = [median_image, double(image(:))];
end
siz = size(image);
median_image = median_image';
median_image = median(median_image);
median_image = reshape(median_image,siz);
median_image = uint8(median_image);
end