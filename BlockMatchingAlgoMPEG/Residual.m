

function imageRes = Residual(imgP, imgComp, mbSize)

[row col] = size(imgP);

mbCount = 1;
for i = 1:row
    for j = 1:col
        imageRes(i,j) = abs(imgP(i,j)-imgComp(i,j));
    end
end

imgRes = imageRes;