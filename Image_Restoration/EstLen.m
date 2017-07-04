function LEN = EstLen(ifbl, THETA, expertstatus, handle)
%Function to estimate blur length
%Inputs:  ifbl, THETA, expertstatus
%Returns: LEN
%
%ifbl:  It is the input image.
%THETA: It is the blur angle returned from angle estimation.
%expertstatus: It decides whether to display plots and images or no
%       1 - Display plots and images
%       0 - Do not display
%handle: It is the handle to the waitbar(progress bar)
%LEN:   It is the blur length. The length is the number
%       of pixels by which the image is blurred.
%
%Example:
%       LEN = EstLen(image, THETA, expertstatus);
%       This call takes image as input and returns the blur length.

%No of steps in the algorithm
steps = 8;

%Preprocessing
%Performing Median Filter before restoring the blurred image
ifbl = medfilt2(abs(ifbl));
waitbar(1/steps, handle);

%Display input image
if expertstatus
    figure(1);
    subplot(1,2,1);
    imshow(abs(ifbl));
    title('Input image');
end

%We have to convert the image to Cepstrum domain
%This is how we represent Cepstrum Domain
%Cep(g(x,y)) = invFT{log(FT(g(x,y)))}

%Converting to fourier domain
fin = fft2(ifbl);
waitbar(2/steps, handle);

%Performing log transform
lgfin = abs(log(1 + abs(fin)));
waitbar(3/steps, handle);

%Performing inverse fourier transform to get the image in Cepstrum domain
cin = ifft2(lgfin);
waitbar(4/steps, handle);

%Rotating the image
cinrot = imrotate(cin, -THETA);
waitbar(5/steps, handle);

%Taking average of all the columns
for i=1:size(cinrot, 2)
    avg(i) = 0;
    for j=1:size(cinrot, 1)
        avg(i) = avg(i) + cinrot(j, i);
    end
    avg(i) = avg(i)/size(cinrot, 1);
end
avgr = real(avg);
waitbar(6/steps, handle);

%Displaying the average of all the pixels
if expertstatus
    subplot(1,2,2);
    plot(avgr); grid on;
    title('Average of pixels in cepstrum domain');
end

%Calculating the blur length using first negative value
index = 0;
for i = 1:round(size(avg,2)),
    if real(avg(i))<0,
        index = i;
        break;
    end
end
waitbar(7/steps, handle);

%If Zero Crossing found then return it as the blur length
if index~=0,
    LEN = index;
else
    %If Zero Crossing not found then find the lowest peak
    %Calculating the blur length using Lowest Peak
    index = 1;
    startval = avg(index);
    for i = 1 : round(size(avg, 2)/2),
        if startval>avg(i),
            startval = avg(i);
            index = i;
        end
    end

    LEN = index;
end
waitbar(8/steps, handle);