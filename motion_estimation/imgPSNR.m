% 输入
%   imgP : 原始帧 
%   imgComp : 预测帧
%   n : 图像强度峰值
%
% 输出
%   psnr : 预测帧的PSNR

function psnr = imgPSNR(imgP, imgComp, n)

[row, col] = size(imgP);
err = 0;

for i = 1:row
    for j = 1:col
        err = err + (imgP(i,j) - imgComp(i,j))^2;
    end
end
mse = err / (row*col);  % 均方误差
psnr = 10*log10(n*n/mse);