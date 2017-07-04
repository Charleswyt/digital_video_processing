clear all;
close all;

I0 = imread('cameraman.tif');
I1 = impyramid(I0, 'reduce');
I2 = impyramid(I1, 'reduce');
I3 = impyramid(I2, 'reduce');
  
imshow(I0)
set(gcf,'position',get(0,'ScreenSize'));
figure, imshow(I1)
set(gcf,'position',get(0,'ScreenSize'));
figure, imshow(I2)
set(gcf,'position',get(0,'ScreenSize'));
figure, imshow(I3)
set(gcf,'position',get(0,'ScreenSize'));