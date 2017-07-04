% 输入
%   imgP : 当前帧（为其寻找运动向量）
%   imgI : 参考帧
%   mbSize : 块大小
%   p : 搜索窗口参数（搜索窗口大小为(2p+1)×(2p+1)）
%
% 输出
%   motionVect : 运动向量
%   DScomputations: 搜索每宏块所需的平均搜索点数

function [motionVect, DScomputations] = motionEstDS(imgP, imgI, mbSize, p)

[row, col] = size(imgI);
vectors = zeros(2,row*col/mbSize^2);
costs = ones(1, 9) * 65537;

% 大菱形搜索模式
LDSP(1,:) = [ 0 -2];
LDSP(2,:) = [-1 -1];
LDSP(3,:) = [ 1 -1];
LDSP(4,:) = [-2  0];
LDSP(5,:) = [ 0  0];
LDSP(6,:) = [ 2  0];
LDSP(7,:) = [-1  1];
LDSP(8,:) = [ 1  1];
LDSP(9,:) = [ 0  2];

% 小菱形搜索模式
SDSP(1,:) = [ 0 -1];
SDSP(2,:) = [-1  0];
SDSP(3,:) = [ 0  0];
SDSP(4,:) = [ 1  0];
SDSP(5,:) = [ 0  1];

% 从图像左上角开始搜索
% 从左至右，从上到下，以mbSize为块大小进行搜索
% 在每一块上、下、左、右p个像素的范围内搜索最佳匹配块
computations = 0;

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % 菱形搜索算法开始
        x = j;
        y = i;
        % 计算搜索窗口中心点的值
        costs(5) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        computations = computations + 1;
        
        % 以大菱形搜索模式开始
        for k = 1:9
            refBlkVer = y + LDSP(k,2);   % 垂直坐标
            refBlkHor = x + LDSP(k,1);   % 水平坐标
            if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                continue;% 超出图像范围，跳出循环对下一点进行搜索
            end
            
            if (k == 5)
                continue;% 若是中心点，则跳出该循环对下一点进行搜索
            end
            costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
            computations = computations + 1;
        end
        
        [cost, point] = min(costs);% 记录下MBD（最小块匹配误差）点的值以及位置
        
        % 当搜索到的MBD点在搜索模式的中心点时，将SDSPFlag置为1
        % 进入小菱形搜索模式
        
        if (point == 5)
            SDSPFlag = 1;
        else
            SDSPFlag = 0;
            if ( abs(LDSP(point,1)) == abs(LDSP(point,2)) )
                cornerFlag = 0;
            else
                cornerFlag = 1; % 当MBD点是大菱形的顶点时，将cornerFlag置为1
            end
            xLast = x;
            yLast = y;
            x = x + LDSP(point, 1); % 将搜索模式中心移至上一次的MBD点
            y = y + LDSP(point, 2);
            costs = ones(1,9) * 65537;
            costs(5) = cost;
        end
        
        
        while (SDSPFlag == 0)% 用大菱形搜索模式搜索
            if (cornerFlag == 1)% 当MBD点是大菱形的定点时，只需搜索5个点
                for k = 1:9
                    refBlkVer = y + LDSP(k,2);
                    refBlkHor = x + LDSP(k,1);
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;
                    end
                    
                    if (k == 5)
                        continue;
                    end
                    
                    if ( refBlkHor >= xLast - 1  && refBlkHor <= xLast + 1 && refBlkVer >= yLast - 1  && refBlkVer <= yLast + 1 )
                        continue;% 若已搜索过，则跳出该循环对下一点搜索
                    elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                        continue;% 超出搜素窗口范围，则跳出该循环对下一点搜索
                    else
                        costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                            imgI(refBlkVer:refBlkVer+mbSize-1, ...
                            refBlkHor:refBlkHor+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                end
                
            else% 当MBD点是大菱形4条边上的点时，只需搜索3个点
                switch point
                    case 2% 当MBD是大菱形上的2点时，只需搜索大菱形模式上的1 2 3 4点
                        refBlkVer = y + LDSP(1,2);   % row/Vert co-ordinate for ref block
                        refBlkHor = x + LDSP(1,1);   % col/Horizontal co-ordinate
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(2,2);
                        refBlkHor = x + LDSP(2,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            
                            costs(2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(4,2);
                        refBlkHor = x + LDSP(4,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                    case 3
                        refBlkVer = y + LDSP(1,2);   % row/Vert co-ordinate for ref block
                        refBlkHor = x + LDSP(1,1);   % col/Horizontal co-ordinate
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(3,2);
                        refBlkHor = x + LDSP(3,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(3) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(6,2);
                        refBlkHor = x + LDSP(6,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(6) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        
                    case 7
                        refBlkVer = y + LDSP(4,2);
                        refBlkHor = x + LDSP(4,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(7,2);
                        refBlkHor = x + LDSP(7,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(7) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(9,2);
                        refBlkHor = x + LDSP(9,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(9) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        
                    case 8
                        refBlkVer = y + LDSP(6,2);
                        refBlkHor = x + LDSP(6,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(6) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(8,2);
                        refBlkHor = x + LDSP(8,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % 超出搜索窗口范围
                        else
                            costs(8) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(9,2);
                        refBlkHor = x + LDSP(9,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % 超出图像范围
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p ...
                                || refBlkVer > i+p)
                            % 超出搜索窗口范围 
                        else
                            costs(9) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                    otherwise
                end
            end
            
            [cost, point] = min(costs);
            if (point == 5)
                SDSPFlag = 1;
            else
                SDSPFlag = 0;
                if ( abs(LDSP(point,1)) == abs(LDSP(point,2)) )
                    cornerFlag = 0;
                else
                    cornerFlag = 1;
                end
                xLast = x;
                yLast = y;
                x = x + LDSP(point, 1);
                y = y + LDSP(point, 2);
                costs = ones(1,9) * 65537;
                costs(5) = cost;
            end
        end
        
        % 用小菱形搜索模式搜索
        costs = ones(1,5) * 65537;
        costs(3) = cost;
        
        for k = 1:5
            refBlkVer = y + SDSP(k,2);
            refBlkHor = x + SDSP(k,1);
            if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                    || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                continue; %超出图像范围
            elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p ...
                    || refBlkVer > i+p)
                continue;   % 超出搜素窗口范围
            end
            
            if (k == 3)
                continue;% 若是中心点，则跳出循环对下一点进行搜索
            end
            
            costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                refBlkHor:refBlkHor+mbSize-1), mbSize);
            computations = computations + 1;
            
        end
        
        [cost, point] = min(costs);
        
        x = x + SDSP(point, 1);
        y = y + SDSP(point, 2);
        
        vectors(1,mbCount) = y - i;
        vectors(2,mbCount) = x - j;
        mbCount = mbCount + 1;
        costs = ones(1,9) * 65537;
        
    end
end

motionVect = vectors;
DScomputations = computations/(mbCount - 1);