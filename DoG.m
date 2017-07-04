clear all;
close all;

k=5;
sigma=1;
G1=fspecial('gauss',[round(k*sigma), round(k*sigma)], sigma);
[Gx,Gy] = gradient(G1);  
[Gxx,Gxy] = gradient(Gx);
[Gyx,Gyy] = gradient(Gy);

I=imread('street2.jpg');
J=rgb2gray(I);

%test noisy image;
J=imnoise(J,'gaussian', 0,0.01);
imshow(J);

bw=imfilter(J, G1);
figure;
imshow(bw);

bw=imfilter(J, [Gx,Gy]);
figure;
imshow(bw);

h=fspecial('sobel');
bw=imfilter(bw,h);
figure;
imshow(bw);

%K=double(J);
%K=imfilter(K,G1);
%bw=gradient(K);
%figure;
%imshow(bw);


