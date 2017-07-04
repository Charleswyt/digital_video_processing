mbSize=16;
p=7;
filename='foreman.yuv';
fp=fopen(filename,'r');
width=176;
height=144;

i=47;
fseek(fp,i*1.5*width*height,'bof');
bufI=fread(fp,width*height,'uchar');
imgI=double((reshape(bufI,width,height))');
fseek(fp,0.5*width*height,'cof');
bufP=fread(fp,width*height,'uchar');
imgP0=uint8((reshape(bufP,width,height))');
figure,imshow(imgP0);
imgP=double(imgP0);

[motionVect,computations]=motionEstDS(imgP,imgI,mbSize,p);

a=zeros(1,width*height/mbSize^2);
a(:)=motionVect(1,1:width*height/mbSize^2);
b=zeros(1,width*height/mbSize^2);
b(:)=motionVect(2,1:width*height/mbSize^2);
for i=1:height/mbSize
    for j=1:width/mbSize
        mvx(i,j)=b(1,j+(i-1)*(width/mbSize));
        mvy(i,j)=-(a(1,j+(i-1)*(width/mbSize)));
    end
end
figure;quiver(flipud(mvx),flipud(mvy));
title('‘À∂Ø ∏¡øÕº');
set(gca,'Xlim',[-1,width/mbSize+2],'YLim',[-1,height/mbSize+2]);

imgComp=motionComp(imgI,motionVect,mbSize);
I1=uint8(imgComp);
figure:imshow(I1);

canc=zeros(height,width);
for i=1:height
    for j=1:width
        canc(i,j)=255-abs(imgP(i,j)-imgComp(i,j));
    end
end
figure,imshow(uint8(canc));
title('≤–≤Ó÷°');