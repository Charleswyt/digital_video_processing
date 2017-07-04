clc;
clear all;
close all;

mbSize = 16;
p = 7;
file_path =  'C:\\Users\\Administrator\\MatlabProject\\digital_video_process\\frame_sequence\\';
image_path_list = dir(strcat(file_path, '*.jpg'));              % 获取该文件夹中所有jpg格式的图像
image_num = length(image_path_list);                                % 获取图像总数量

%% ---------------------------------------------------------------------------------------------------------------------------------------------- %%
if image_num > 0                                                         % 有满足条件的图像
    for i = 1:image_num-2                                                 % 逐一读取图像
        imagel_name = image_path_list(i).name;           % 图像名
        imageP_name = image_path_list(i+2).name;
        imagel_path = strcat(file_path,imagel_name);% 图像路径
        imageP_path = strcat(file_path,imageP_name);
        imgI = double(imread(imagel_path));
        imgP = double(imread(imageP_path));
        [height, width, dim] = size(imgI);
        imgI = imgI(1:height-mbSize/2, 1:width);
        imgP = imgP(1:height-mbSize/2, 1:width);
        
        % 全搜索法
        [motionVect, computations] = motionEstES(imgP, imgI, mbSize,p);
        imgComp = motionComp(imgI, motionVect, mbSize);
        ESpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
        EScomputations(i+1) = computations;
        
        % 三步搜索法
        [motionVect,computations ] = motionEstTSS(imgP, imgI, mbSize,p);
        imgComp = motionComp(imgI, motionVect, mbSize);
        TSSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
        TSScomputations(i+1) = computations;
        
        % 简化版的三步搜索法
        [motionVect, computations] = motionEstSESTSS(imgP,imgI,mbSize,p);
        imgComp = motionComp(imgI, motionVect, mbSize);
        SESTSSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
        SESTSScomputations(i+1) = computations;
        
        % 新三步搜索法
        [motionVect,computations ] = motionEstNTSS(imgP,imgI,mbSize,p);
        imgComp = motionComp(imgI, motionVect, mbSize);
        NTSSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
        NTSScomputations(i+1) = computations;
        
        % 四步搜索法
        [motionVect, computations] = motionEst4SS(imgP,imgI,mbSize,p);
        imgComp = motionComp(imgI, motionVect, mbSize);
        SS4psnr(i+1) = imgPSNR(imgP, imgComp, 255);
        SS4computations(i+1) = computations;
        
        % 菱形搜索法
        [motionVect, computations] = motionEstDS(imgP,imgI,mbSize,p);
        imgComp = motionComp(imgI, motionVect, mbSize);
        DSpsnr(i+1) = imgPSNR(imgP, imgComp, 255);
        DScomputations(i+1) = computations;
        
    end
end

i = 1:1:image_num-1;% 显示前image_num-2帧的信噪比与平均搜索点数
% psnr比较
fig_1 = figure(1);
set(fig_1, 'name', 'Fig1:PSNR比较', 'Numbertitle', 'off');
plot(i, ESpsnr, 'r', i, TSSpsnr, 'c-+', i, SS4psnr, 'b-.', i, DSpsnr, 'k:');
set(gca, 'XLim', [2, 30]);
legend('ESpsnr', 'TSSpsnr', 'SS4psnr', 'DSpsnr');
title('各种搜索算法下图像的PSNR');

% 搜索速度比较
fig_2 = figure(2);
set(fig_2, 'name', 'Fig2:搜索速度比较', 'Numbertitle', 'off');
plot(i, EScomputations, 'r--', i, TSScomputations, 'c-+', i, SS4computations, 'b-', i, DScomputations, 'k:');
set(gca, 'XLim', [2, 30]);
legend('ES computations', 'TSS computations', 'SS4 computations', 'DS computations');
title('各种搜索算法的搜索速度-平均搜索点数');