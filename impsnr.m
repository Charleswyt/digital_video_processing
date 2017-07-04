ref = imread('pout.tif');
A = imnoise(ref,'salt & pepper', 0.02);
[peaksnr, snr] = psnr(A, ref);

subplot(1,2,1); imshow(ref); title('Reference Image');
subplot(1,2,2); imshow(A);   title('Noisy Image');
figure;
imshow(abs(A-ref));

title(sprintf('The PSNR Value is %0.4f',peaksnr));
  
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The SNR value is %0.4f \n', snr);