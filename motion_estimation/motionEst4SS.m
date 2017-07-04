% 输入
%   imgP : 当前帧（为其寻找运动向量）
%   imgI : 参考帧
%   mbSize : 块大小
%   p : 搜索窗口参数（搜索窗口大小为(2p+1)×(2p+1)）
%
% 输出
%   motionVect : 运动向量
%   SS4computations: 搜索每宏块所需的平均搜索点数

function [motionVect, SS4Computations] = motionEst4SS(imgP, imgI, mbSize, p)

[row, col] = size(imgI);

vectors = zeros(2,row*col/mbSize^2);
costs = ones(3, 3) * 65537;

% 从图像左上角开始搜索
% 从左至右，从上到下，以mbSize为块大小进行搜索
% 在每一块上、下、左、右p个像素的范围内搜索最佳匹配块
computations = 0;
mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % 4步搜索法开始
        x = j;
        y = i;
        
        % 计算搜索窗口的中心值
        costs(2,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        computations = computations + 1;
        
        % 第一步将计算9个点
        for m = -2 : 2 : 2
            for n = -2 : 2 : 2
                refBlkVer = y + m;% 垂直坐标
                refBlkHor = x + n;% 水平坐标
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;% 超出图像范围，跳出循环对下一点进行搜索
                end
                
                costRow = m/2 + 2;
                costCol = n/2 + 2;
                if (costRow == 2 && costCol == 2)
                    continue;% 若是中心点，则跳出该循环对下一点进行搜索
                end
                costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
                
            end
        end
        
        [dx, dy, cost] = minCost(costs);
        
        % 当MBD点在搜索模式的中心时，flag_4ss置为1
        % 以步长为1的方形模式进行搜索
        if (dx == 2 && dy == 2)
            flag_4ss = 1;
        else
            flag_4ss = 0;
            xLast = x;
            yLast = y;
            x = x + (dx-2)*2;
            y = y + (dy-2)*2;
        end
        
        costs = ones(3,3) * 255;
        costs(2,2) = cost;
        
        % 当MBD点不在搜索模式的中心时，flag_4ss置为0
        % 继续以步长为2的方形模式进行搜索
        stage = 1;
        while (flag_4ss == 0 && stage <=2)
            for m = -2 : 2 : 2
                for n = -2 : 2 : 2
                    refBlkVer = y + m;
                    refBlkHor = x + n;
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;
                    end
                    
                    if (refBlkHor >= xLast - 2 && refBlkHor <= xLast + 2 ...
                            && refBlkVer >= yLast - 2 && refBlkVer <= yLast + 2 )
                        continue;
                    end
                    
                    costRow = m/2 + 2;
                    costCol = n/2 + 2;
                    if (costRow == 2 && costCol == 2)
                        continue
                    end
                    
                    costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVer:refBlkVer+mbSize-1, ...
                        refBlkHor:refBlkHor+mbSize-1), mbSize);
                    computations = computations + 1;
                    
                end
            end
            
            [dx, dy, cost] = minCost(costs);
            
            
            if (dx == 2 && dy == 2)
                flag_4ss = 1;
            else
                flag_4ss = 0;
                xLast = x;
                yLast = y;
                x = x + (dx-2)*2;
                y = y + (dy-2)*2;
            end
            
            costs = ones(3,3) * 65537;
            costs(2,2) = cost;
            stage = stage + 1;   
        end
        
        
        % 进入最后一步，以步长为1的方形模式进行搜索
        for m = -1 : 1 : 1
            for n = -1 : 1 : 1
                refBlkVer = y + m;
                refBlkHor = x + n;
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;
                end
                
                costRow = m + 2;
                costCol = n + 2;
                if (costRow == 2 && costCol == 2)
                    continue
                end
                costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
            end
        end
        
        [dx, dy, cost] = minCost(costs);
        
        x = x + dx - 2;
        y = y + dy - 2;
        
        vectors(1,mbCount) = y - i;
        vectors(2,mbCount) = x - j;
        mbCount = mbCount + 1;
        costs = ones(3,3) * 65537;
        
    end
end

motionVect = vectors;
SS4Computations = computations/(mbCount - 1);