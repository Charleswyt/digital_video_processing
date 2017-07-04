clear all;
close all;

I = checkerboard(50,2,2);
C = corner(I);
imshow(I);
hold on
plot(C(:,1), C(:,2), 'r*');
title('Harris Corner');

figure;
I = imread('street2.jpg'); 
J=rgb2gray(I);
C = corner(J);
imshow(J);
hold on
plot(C(:,1), C(:,2), 'r*');
title('Harris Corner');

figure;
C = corner(J,'MinimumEigenvalue');
imshow(J);
hold on
plot(C(:,1), C(:,2), 'r*');
title('MinimumEigenvalue Corner');
