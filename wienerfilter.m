close all; 
clear all;
RGB = imread('saturn.png');
I = rgb2gray(RGB);
J = imnoise(I,'gaussian',0,0.02);
imshow(J);
K = wiener2(J,[5 5]);
figure, imshow(K)

I = imread('lena.png');
J = imnoise(I,'gaussian',0,0.02);
figure, imshow(J);
K = wiener2(J,[5 5]);
figure, imshow(K)

I = imread('eight.tif');
J = imnoise(I,'gaussian',0,0.02);
figure, imshow(J);
K = wiener2(J,[5 5]);
figure, imshow(K)