function resim = Inverse(ifbl, LEN, THETA, handle)
%Function to restore the image using Inverse Filter
%Inputs: ifbl, LEN, THETA.
%Returns: resim.
%
%ifbl:  It is the input image.
%THETA: It is the blur angle. The angle at which the image is blurred.
%LEN:   It is the blur length. The length is the number
%       of pixels by which the image is blurred.
%handle:It is the handle to the waitbar(progress bar).
%resim: It is the restored image.
%
%Example:
%       resim = Inverse(image, LEN, THETA);
%       This call takes image, blur length & blur angle as input
%       and returns the restored image.

%No of steps in the algorithm
steps = 6;

%Converting to frequency domain
fbl = fft2(ifbl);
waitbar(1/steps, handle);

%Create PSF of degradation
PSF = fspecial('motion',LEN,THETA);
waitbar(2/steps, handle);

%Convert psf to otf of desired size
%OTF is Optical Transfer Function
OTF = psf2otf(PSF, size(fbl));
waitbar(3/steps, handle);

%To avoid divide by zero error
for i = 1:size(OTF, 1)
    for j = 1:size(OTF, 2)
        if OTF(i, j) == 0
            OTF(i, j) = 0.000001;
        end
    end
end
waitbar(4/steps, handle);

%Restoring the image using Inverse Filter
fdebl = fbl./OTF;
waitbar(5/steps, handle);

%Converting back to spatial domain using IFFT
resim = ifft2(fdebl);
waitbar(6/steps, handle);