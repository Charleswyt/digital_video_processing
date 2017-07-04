clc;
clear all;
close all;

[image_I_4, image_I_2, image_I] = pyramid_3D('19.jpg');
[image_P_4, image_P_2, image_P] = pyramid_3D('18.jpg');

% figure;imshow(image_4);title('level-1');
% figure;imshow(image_2);title('level-2');
% figure;imshow(image);title('level-3');


EtEs_function(image_I_4, image_P_4);
EtEs_function(image_I_2, image_P_2);
EtEs_function(image_I, image_P);