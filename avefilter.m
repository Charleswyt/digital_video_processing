close all; 
clear all;
I = imread('eight.tif');
figure, imshow(I);
J = imnoise(I,'gaussian',0.02);
figure, imshow(J)
K = filter2(fspecial('average',3),J)/255;
figure, imshow(K)

J = imnoise(I,'salt & pepper',0.02);
figure, imshow(J)
K = filter2(fspecial('average',3),J)/255;
figure, imshow(K)