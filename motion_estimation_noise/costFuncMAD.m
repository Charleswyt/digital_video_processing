% 输入
%       currentBlk : 当前帧中块的灰度值
%       refBlk : 当前帧中块的灰度值
%       n : 宏块的大小
%
% 输出
%       cost : 宏块的MAD值

function cost = costFuncMAD(currentBlk, refBlk, n)

error = 0;
for i = 1 : n
    for j = 1 : n
        error = error + abs((currentBlk(i, j) - refBlk(i, j)));
    end
end
cost = error / (n * n);