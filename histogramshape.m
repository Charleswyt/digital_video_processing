close all; 
clear all;
A = imread('concordaerial.png');
%Ref = imread('concordorthophoto.png');
%Ref = imread('pollen.tif');
Ref = imread('rice.png');
size(A);
size(Ref);
B = imhistmatch(A,Ref);

subplot(1,3,1), subimage(A);
subplot(1,3,2), subimage(Ref);
subplot(1,3,3), subimage(B);
