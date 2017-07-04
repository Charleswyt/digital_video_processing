close all; 
clear all;
I = imread('pollen.tif');
imshow(I);
imdisplayrange;
figure;
imhist(I);