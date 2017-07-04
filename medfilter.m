close all; 
clear all;
I = imread('eight.tif');
imshow(I);
J = imnoise(I,'salt & pepper',0.02);
figure, imshow(J)
L = medfilt2(J,[3 3]);
figure, imshow(L)

J = imnoise(I,'gaussian',0.02);
figure, imshow(J)
L = medfilt2(J,[3 3]);
figure, imshow(L)

