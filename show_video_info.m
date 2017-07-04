function show_video_info(video_path)

video = VideoReader(video_path);% 读取视频
output = sprintf('视频总时长为：%0.1f秒', video.Duration);disp(output);
output = sprintf('视频帧率为：%0.1f帧/秒', video.FrameRate);disp(output);
output = sprintf('视频总帧数为：%d帧', video.NumberOfFrames);disp(output);
output = sprintf('视频高度为：%d像素', video.Height);disp(output);
output = sprintf('视频宽度为：%d像素', video.Width);disp(output);
disp(['视频类型为：', video.VideoFormat]);