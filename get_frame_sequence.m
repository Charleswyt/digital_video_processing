function get_frame_sequence(video_name, frame_sequence_path, total_frame_number)
video = VideoReader(video_name);% 读取视频
frame_number = floor(video.Duration * video.FrameRate);% 获取当前视频总帧数
if total_frame_number > frame_number
    total_frame_number = frame_number;
end
for i = 1 : total_frame_number
    image_name = strcat(frame_sequence_path, num2str(i), '.jpg');
    image = read(video, i);% 读出图片
    imwrite(image, image_name, 'jpg');% 写图片
end
end