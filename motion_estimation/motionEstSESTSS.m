% Computes motion vectors using Simple and Efficient TSS method
%
% Based on the paper by Jianhua Lu and Ming L. Liou
% 输入
%   imgP : 当前帧（为其寻找运动向量）
%   imgI : 参考帧
%   mbSize : 块大小
%   p : 搜索窗口参数（搜索窗口大小为(2p+1)×(2p+1)）
%
% 输出
%   motionVect : 运动向量
%   DScomputations: 搜索每宏块所需的平均搜索点数

function [motionVect, SESTSScomputations] = motionEstSESTSS(imgP, imgI, mbSize, p)

[row, col] = size(imgI);

vectors = zeros(2,row*col/mbSize^2);

L = floor(log10(p+1)/log10(2));  
stepMax =  2^(L-1);
costs = ones(1,6)*65537;

computations = 0;

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1

        stepSize = stepMax;
        x = j;
        y = i;
        while (stepSize >= 1)
            refBlkVerPointA = y;
            refBlkHorPointA = x;
            
            refBlkVerPointB = y;
            refBlkHorPointB = x + stepSize;
            
            refBlkVerPointC = y + stepSize;
            refBlkHorPointC = x;
            
            if ( refBlkVerPointA < 1 || refBlkVerPointA+mbSize-1 > row ...
                    || refBlkHorPointA < 1 || refBlkHorPointA+mbSize-1 > col)
                % do nothing %
                
            else
                costs(1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                              imgI(refBlkVerPointA:refBlkVerPointA+mbSize-1, ...
                                 refBlkHorPointA:refBlkHorPointA+mbSize-1), mbSize);
                computations = computations + 1;
            end
            
            if ( refBlkVerPointB < 1 || refBlkVerPointB+mbSize-1 > row ...
                    || refBlkHorPointB < 1 || refBlkHorPointB+mbSize-1 > col)
                % do nothing %
                
            else
                costs(2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVerPointB:refBlkVerPointB+mbSize-1, ...
                            refBlkHorPointB:refBlkHorPointB+mbSize-1), mbSize);
                computations = computations + 1;
            end
                       

            if ( refBlkVerPointC < 1 || refBlkVerPointC+mbSize-1 > row ...
                    || refBlkHorPointC < 1 || refBlkHorPointC+mbSize-1 > col)
                % do nothing %
                
            else
                costs(3) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVerPointC:refBlkVerPointC+mbSize-1, ...
                            refBlkHorPointC:refBlkHorPointC+mbSize-1), mbSize);
                computations = computations + 1;
            end
     
            if (costs(1) >= costs(2) && costs(1) >= costs(3))
                quadrant = 4;
            elseif (costs(1) >= costs(2) && costs(1) < costs(3))
                quadrant = 1;
            elseif (costs(1) < costs(2) && costs(1) < costs(3))
                quadrant = 2;
            elseif (costs(1) < costs(2) && costs(1) >= costs(3))
                quadrant = 3;
            end
            
            switch quadrant
                case 1
                    refBlkVerPointD = y - stepSize;
                    refBlkHorPointD = x;
                    
                    refBlkVerPointE = y - stepSize;
                    refBlkHorPointE = x + stepSize;
                    
                    if ( refBlkVerPointD < 1 || refBlkVerPointD+mbSize-1 > row ...
                            || refBlkHorPointD < 1 || refBlkHorPointD+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointD:refBlkVerPointD+mbSize-1, ...
                                        refBlkHorPointD:refBlkHorPointD+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                    
                    if ( refBlkVerPointE < 1 || refBlkVerPointE+mbSize-1 > row ...
                            || refBlkHorPointE < 1 || refBlkHorPointE+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(5) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointD:refBlkVerPointD+mbSize-1, ...
                                        refBlkHorPointD:refBlkHorPointD+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                    
                         
                case 2
                    refBlkVerPointD = y - stepSize;
                    refBlkHorPointD = x;
                    
                    refBlkVerPointE = y - stepSize;
                    refBlkHorPointE = x - stepSize;
                    
                    refBlkVerPointF = y;
                    refBlkHorPointF = x - stepSize;
                    
            
                    if ( refBlkVerPointD < 1 || refBlkVerPointD+mbSize-1 > row ...
                            || refBlkHorPointD < 1 || refBlkHorPointD+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointD:refBlkVerPointD+mbSize-1, ...
                                        refBlkHorPointD:refBlkHorPointD+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                    
                    if ( refBlkVerPointE < 1 || refBlkVerPointE+mbSize-1 > row ...
                            || refBlkHorPointE < 1 || refBlkHorPointE+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(5) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointE:refBlkVerPointE+mbSize-1, ...
                                        refBlkHorPointE:refBlkHorPointE+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                    
                    if ( refBlkVerPointF < 1 || refBlkVerPointF+mbSize-1 > row ...
                            || refBlkHorPointF < 1 || refBlkHorPointF+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(6) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointF:refBlkVerPointF+mbSize-1, ...
                                        refBlkHorPointF:refBlkHorPointF+mbSize-1), mbSize);
                        computations = computations + 1;
                    end

                   
                case 3
                    refBlkVerPointD = y;
                    refBlkHorPointD = x - stepSize;
                    
                    refBlkVerPointE = y - stepSize;
                    refBlkHorPointE = x - stepSize;
                    
                    if ( refBlkVerPointD < 1 || refBlkVerPointD+mbSize-1 > row ...
                            || refBlkHorPointD < 1 || refBlkHorPointD+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointD:refBlkVerPointD+mbSize-1, ...
                                        refBlkHorPointD:refBlkHorPointD+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                    
                    if ( refBlkVerPointE < 1 || refBlkVerPointE+mbSize-1 > row ...
                            || refBlkHorPointE < 1 || refBlkHorPointE+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(5) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointD:refBlkVerPointD+mbSize-1, ...
                                        refBlkHorPointD:refBlkHorPointD+mbSize-1), mbSize);
                        computations = computations + 1;
                    end

                    
                 case 4
                    refBlkVerPointD = y + stepSize;
                    refBlkHorPointD = x + stepSize;
                    
                    if ( refBlkVerPointD < 1 || refBlkVerPointD+mbSize-1 > row ...
                            || refBlkHorPointD < 1 || refBlkHorPointD+mbSize-1 > col)
                        % do nothing %
                        
                    else
                        costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                    imgI(refBlkVerPointD:refBlkVerPointD+mbSize-1, ...
                                        refBlkHorPointD:refBlkHorPointD+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                otherwise
                    

            end
                  
            [cost, dxy] = min(costs);      % finds which macroblock in imgI gave us min Cost
            
            switch dxy
                 case 1
                     % x = x; y = y;  
                 case 2
                     x = refBlkHorPointB; 
                     y = refBlkVerPointB;
                 case 3
                     x = refBlkHorPointC;
                     y = refBlkVerPointC; 
                 case 4
                     x = refBlkHorPointD;
                     y = refBlkVerPointD; 
                 case 5
                     x = refBlkHorPointE;
                     y = refBlkVerPointE;
                 case 6
                     x = refBlkHorPointF;
                     y = refBlkVerPointF;
                     
             end
        
            costs = ones(1,6) * 65537  ;
            stepSize = stepSize / 2;
            
        end
        
        vectors(1,mbCount) = y - i;    % row co-ordinate for the vector
        vectors(2,mbCount) = x - j;    % col co-ordinate for the vector            
        mbCount = mbCount + 1;
    end
end

motionVect = vectors;
SESTSScomputations = computations/(mbCount - 1);               