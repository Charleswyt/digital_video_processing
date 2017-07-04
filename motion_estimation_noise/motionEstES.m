% 输入
%   imgP : 当前帧
%   imgI : 参考帧
%   mbSize : 块大小
%   p : 搜索窗口数（搜索窗口大小为(2p+1)×(2p+1)）
%
% 输出
%   motionVect : 运动向量
%   EScomputations: 搜索每宏块所需的平均搜索点数

function [motionVect, EScomputations] = motionEstES(imgP, imgI, mbSize, p)

[row, col] = size(imgI);

vectors = zeros(2, floor(row*col/mbSize^2));
costs = ones(2*p + 1, 2*p +1) * 65537;

computations = 0;

% 从图像的左上角开始
% 从左至右，从上到下，以mbSize为块大小进行搜索
% 在每一块的上、下、左、右p个像素的范围内搜索最佳匹配块

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % 全搜索算法开始
        % m是行（垂直）向量
        % n是列（水平）向量
        % this means we are scanning in raster order
        
        for m = -p : p
            for n = -p : p
                refBlkVer = i + m;   % 垂直坐标
                refBlkHor = j + n;   % 水平坐标
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;% 超出图像范围，跳出循环对下一个点进行搜索
                end
                % 计算MAD（平均绝对误差）
                costs(m+p+1,n+p+1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
                
            end
        end
        
        [dx, dy, min] = minCost(costs);  % 记录下MBD点的值以及位置
        vectors(1,mbCount) = dy-p-1;    % 运动向量的y坐标
        vectors(2,mbCount) = dx-p-1;    % 运动向量的x坐标
        mbCount = mbCount + 1;
        costs = ones(2*p + 1, 2*p +1) * 65537;
    end
end

motionVect = vectors;
EScomputations = computations/(mbCount - 1);