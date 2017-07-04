% 输入
%   imgI : 参考帧
%   motionVect : 运动向量
%   mbSize : 块大小
%
% 输出
%   imgComp : 预测帧

function imgComp = motionComp(imgI, motionVect, mbSize)

[row, col] = size(imgI);

% 从图像的左上角开始
% 将参考帧响应的位置放置最佳匹配块的像素值，从而得到预测帧

mbCount = 1;
for i = 1: mbSize : row - mbSize + 1
    for j = 1: mbSize : col - mbSize + 1
        
        dy = motionVect(1, mbCount);
        dx = motionVect(2, mbCount);
        refBlkVer = i + dy;
        refBlkHor = j + dx;
        imageComp(i : i + mbSize - 1, j : j + mbSize - 1) = imgI(refBlkVer : refBlkVer + mbSize - 1, refBlkHor : refBlkHor + mbSize - 1);
        mbCount = mbCount + 1;
    end
end

imgComp = imageComp;