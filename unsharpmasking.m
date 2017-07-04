close all
clear all
a = imread('hestain.png');
imshow(a), title('Original Image');
b = imsharpen(a);
figure, imshow(b), title('Sharpened Image');

%Control the Amount of Sharpening at the EdgesRead image and display it.
a = imread('rice.png');
figure, imshow(a), title('Original Image');
%Sharpen image, specifying the radius and amount parameters.
b = imsharpen(a,'Radius',2,'Amount',1);
figure, imshow(b), title('Sharpened Image');