% 输入
%   costs : 宏块的MAD值矩阵
%
% Output
%   dx : 对应的运动向量的x坐标
%   dy : 对应的运动向量的y坐标

function [dx, dy, min] = minCost(costs)

[row, col] = size(costs);

min = 255;

for i = 1 : row
    for j = 1 : col
        if (costs(i, j) < min)
            min = costs(i,j);
            dx = j;
            dy = i;
        end
    end
end