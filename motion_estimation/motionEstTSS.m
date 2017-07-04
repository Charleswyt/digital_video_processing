% Input
%   imgP : 当前帧（为其寻找运动向量）
%   imgI : 参考帧
%   mbSize : 块大小
%   p : 搜索窗口（搜索窗口大小为(2p+1)×(2p+1)）
%
% Ouput
%   motionVect : 运动向量
%   NTSScomputations: 搜索每宏块所需的平均搜索点数

function [motionVect, TSScomputations] = motionEstTSS(imgP, imgI, mbSize, p)

[row,  col] = size(imgI);

vectors = zeros(2,row*col/mbSize^2);
costs = ones(3, 3) * 65537;
computations = 0;

% 计算所需搜索步数以及最大步长
L = floor(log10(p+1)/log10(2));
stepMax = 2^(L-1);

% 从图像左上角开始搜索
% 从左至右，从上到下，以mbSize为块大小进行搜索
% 在每一块上、下、左、右p个像素的范围内搜索最佳匹配块

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % 三步搜索法开始
        % 每一步将计算9个点
        x = j;
        y = i;
        
        % 计算搜索窗口中心点的值
        costs(2,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        computations = computations + 1;
        stepSize = stepMax;
        
        while(stepSize >= 1)
            % m 是行（垂直）向量
            % n 是列（水平）向量
            for m = -stepSize : stepSize : stepSize
                for n = -stepSize : stepSize : stepSize
                    refBlkVer = y + m;% 垂直坐标
                    refBlkHor = x + n;% 水平坐标
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;% 超出图像范围，跳出循环对下一点进行搜索
                    end
                                       
                    costRow = m/stepSize + 2;
                    costCol = n/stepSize + 2;
                    if (costRow == 2 && costCol == 2)
                        continue;% 若是中心点，则跳出该循环对下一点进行搜索
                    end
                    costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                    computations = computations + 1;
                end
            end
            
            % 记录下MBD（最小块匹配误差）点的值以及位置
            [dx, dy, min] = minCost(costs);
            x = x + (dx-2)*stepSize;
            y = y + (dy-2)*stepSize;
            stepSize = stepSize / 2;
            costs(2,2) = costs(dy,dx);
            
        end
        vectors(1,mbCount) = y - i;
        vectors(2,mbCount) = x - j;
        mbCount = mbCount + 1;
        costs = ones(3,3) * 65537;
    end
end

motionVect = vectors;
TSScomputations = computations/(mbCount - 1);