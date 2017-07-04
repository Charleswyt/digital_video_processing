clear all;
close all;
I = imread('street2.jpg'); 
J=rgb2gray(I);

%test noisy image;
%J=imnoise(J,'gaussian', 0,0.01);
%imshow(J);
%title('noisy');

bw=imgradient(J);
bw1=uint8(bw);
imshow(bw1)
title('Gradient');
[gx gy]=imgradientxy(J);
gx=uint8(gx);
gy=uint8(gy);
figure;
imshow(gx);
figure;
imshow(gy);

figure;
bw=edge(J,'sobel');  
imshow(bw);
title('Sobel');

figure;
bw=edge(J,'prewitt');  
imshow(bw)
title('Prewitt');

figure;
bw=edge(J,'roberts');  
imshow(bw)
title('Roberts');

figure;
bw=edge(J,'canny');  
imshow(bw)
title('Canny');
