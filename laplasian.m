clear all;
close all;
I = imread('street2.jpg'); 
J=rgb2gray(I);

%test noisy image;
J=imnoise(J,'gaussian', 0,0.01);
%imshow(J);
%title('noisy');

figure;
h = fspecial('laplacian');
bw = imfilter(J, h);
imshow(bw);
title('Laplacian');

figure;
bw=edge(J,'log');  
imshow(bw)
title('LoG');