function [image_4, image_2, image] = pyramid_3D(image_path)
image = imread(image_path);
[m, n, dim] = size(image);
filter = fspecial('gaussian', [3, 3]);
image_2 = imresize(imfilter(image, filter), [m/2, n/2]);% 2倍下采样
image_4 = imresize(imfilter(image, filter), [m/4, n/4]);% 4倍下采样
% figure;imshow(image_4);title('level-1');
% figure;imshow(image_2);title('level-2');
% figure;imshow(image);title('level-3');
