% 输入
%   imgP : 当前帧（为其寻找运动向量）
%   imgI : 参考帧
%   mbSize : 块大小
%   p : 搜索窗口参数（搜索窗口大小为(2p+1)×(2p+1)）
%
% 输出
%   motionVect : 运动向量
%   DScomputations: 搜索每宏块所需的平均搜索点数

function [motionVect, NTSScomputations] = motionEstNTSS(imgP, imgI, mbSize, p)

[row, col] = size(imgI);

vectors = zeros(2,row*col/mbSize^2);
costs = ones(3, 3) * 65537;

L = floor(log10(p+1)/log10(2));
stepMax = 2^(L-1);

computations = 0;

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        
        x = j;
        y = i;
        costs(2,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
            imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        stepSize = stepMax;
        computations = computations + 1;
        
        for m = -stepSize : stepSize : stepSize
            for n = -stepSize : stepSize : stepSize
                refBlkVer = y + m;
                refBlkHor = x + n;
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;
                end
                
                costRow = m/stepSize + 2;
                costCol = n/stepSize + 2;
                if (costRow == 2 && costCol == 2)
                    continue
                end
                costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
            end
        end
        
        [dx, dy, min1] = minCost(costs);
        
        x1 = x + (dx-2)*stepSize;
        y1 = y + (dy-2)*stepSize;
        
        stepSize = 1;
        for m = -stepSize : stepSize : stepSize
            for n = -stepSize : stepSize : stepSize
                refBlkVer = y + m;   % row/Vert co-ordinate for ref block
                refBlkHor = x + n;   % col/Horizontal co-ordinate
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;
                end
                
                costRow = m/stepSize + 2;
                costCol = n/stepSize + 2;
                if (costRow == 2 && costCol == 2)
                    continue
                end
                costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
            end
        end
        
        % now find the minimum amongst this
        
        [dx, dy, min2] = minCost(costs);      % finds which macroblock in imgI gave us min Cost
        
        
        % Find the exact co-ordinates of this point
        
        x2 = x + (dx-2)*stepSize;
        y2 = y + (dy-2)*stepSize;
        
        % the only place x1 == x2 and y1 == y2 will take place will be the
        % center of the search region
        
        if (x1 == x2 && y1 == y2)
            % then x and y still remain pointing to j and i;
            NTSSFlag = -1; % this flag will take us out of any more computations
        elseif (min2 <= min1)
            x = x2;
            y = y2;
            NTSSFlag = 1; % this flag signifies we are going to go into NTSS mode
        else
            x = x1;
            y = y1;
            NTSSFlag = 0; % This value of flag says, we go into normal TSS
        end
        
        
        if (NTSSFlag == 1)
            % Now in order to make sure that we dont calcylate the same
            % points again which were in the initial center window we take
            % care as follows
            
            costs = ones(3,3) * 65537;
            costs(2,2) = min2;
            stepSize = 1;
            for m = -stepSize : stepSize : stepSize
                for n = -stepSize : stepSize : stepSize
                    refBlkVer = y + m;   % row/Vert co-ordinate for ref block
                    refBlkHor = x + n;   % col/Horizontal co-ordinate
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;
                    end
                    
                    if ( (refBlkVer >= i - 1  && refBlkVer <= i + 1) ...
                            && (refBlkHor >= j - 1  && refBlkHor <= j + 1) )
                        continue;
                    end
                    
                    costRow = m/stepSize + 2;
                    costCol = n/stepSize + 2;
                    if (costRow == 2 && costCol == 2)
                        continue
                    end
                    costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                    computations = computations + 1;
                end
            end
            
            % now find the minimum amongst this
            
            [dx, dy, min2] = minCost(costs);      % finds which macroblock in imgI gave us min Cost
            
            % Find the exact co-ordinates of this point and stop
            
            x = x + (dx-2)*stepSize;
            y = y + (dy-2)*stepSize;
            
        elseif (NTSSFlag == 0)
            % this is when we are going about doing normal TSS business
            costs = ones(3,3) * 65537;
            costs(2,2) = min1;
            stepSize = stepMax / 2;
            while(stepSize >= 1)
                for m = -stepSize : stepSize : stepSize
                    for n = -stepSize : stepSize : stepSize
                        refBlkVer = y + m;   % row/Vert co-ordinate for ref block
                        refBlkHor = x + n;   % col/Horizontal co-ordinate
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                                || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            continue;
                        end
                        
                        costRow = m/stepSize + 2;
                        costCol = n/stepSize + 2;
                        if (costRow == 2 && costCol == 2)
                            continue
                        end
                        costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                            imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                        computations = computations + 1;
                        
                    end
                end
                
                [dx, dy, min] = minCost(costs);
                
                x = x + (dx-2)*stepSize;
                y = y + (dy-2)*stepSize;
                
                stepSize = stepSize / 2;
                costs(2,2) = costs(dy,dx);
                
            end
        end
        
        vectors(1,mbCount) = y - i;    % row co-ordinate for the vector
        vectors(2,mbCount) = x - j;    % col co-ordinate for the vector
        mbCount = mbCount + 1;
        costs = ones(3,3) * 65537;
    end
end

motionVect = vectors;
NTSScomputations = computations/(mbCount - 1);