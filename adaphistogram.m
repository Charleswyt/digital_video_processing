I = imread('tire.tif');
A = adapthisteq(I,'clipLimit',0.02,'Distribution','rayleigh');
B = histeq(I);
figure, imshow(I);
figure, imshow(A);
figure, imshow(B);