close all; 
clear all;
I = imread('pout.tif');
J = imadjust(I);
subplot(1,2,1), subimage(I);
subplot(1,2,2), subimage(J);

K = imadjust(I,[0.3 0.7],[]);
figure;
subplot(1,2,1), subimage(I);
subplot(1,2,2), subimage(K);

I = imread('cameraman.tif');
J = imadjust(I,[0 0.2],[0.5 1]);
figure;
subplot(1,2,1), subimage(I);
subplot(1,2,2), subimage(J);

RGB1 = imread('football.jpg');
RGB2 = imadjust(RGB1,[.2 .3 0; .6 .7 1],[]);
figure;
subplot(1,2,1), subimage(RGB1);
subplot(1,2,2), subimage(RGB2);
