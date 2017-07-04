close all; 
clear all;
I = imread('pollen.tif');
J = histeq(I);
imshow(I)
figure, imshow(J);
figure, imhist(J);