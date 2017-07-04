function [THETAS] = EstAngle(ifbl, expertstatus, handle)
%Function to estimate blur angle
%Inputs: ifbl, expertstatus
%Returns: THETAS
%
%ifbl:  It is the input image.
%expertstatus: It decides whether to display plots and images or no
%       1 - Display plots and images
%       0 - Do not display
%handle: It is the handle to the waitbar(progress bar)
%THETAS: It is the blur angle. The angle at which the image is blurred. It
%        is a collection of possible blur angles.
%
%Example:
%       [THETAS] = EstAngle(image, expertstatus, handle);
%       This call takes image as input and returns a group of blur angle.

%No of steps in the algorithm
steps = 8;

%Number of estimates required
noofest = 10;

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

%Converting image from spatial domain to frequency domain
fbl = abs(fft2(ifbl));
waitbar(2/steps, handle);

%Performing Log Transform
lg = log(1+fbl);
lgpow = abs(lg).^2;
waitbar(3/steps, handle);

%Converting to cepstral domain
lgcep = ifft2(lgpow);
waitbar(4/steps, handle);

%Finding edges in image
BW = edge(lgcep);
BW = ifftshift(BW);
waitbar(5/steps, handle);

%Display Edge image
if expertstatus
    subplot(1,2,2);
    imshow(abs(BW));
    title('Edge image');
end

%Calling hough transform
h = Hough(BW);
siz = size(ifbl);
rl = ceil(sqrt(siz(1)^2+siz(2)^2));
waitbar(6/steps, handle);

%Finding first maximum in the accumulator
maxi = 0;
theta = 0;
for i = 1:rl
    for j = 1:360
        if h(i,j)>maxi
            maxi = h(i,j);
            theta = j;
        end
    end
end
waitbar(7/steps, handle);

%Storing first maximum in the array
g = 1;
maxarr(g) = theta;   
g = g + 1;

%Saving our original accumulator array
h2 = h;

%Iterating 10 times to find 10 highest angle values
for p = 1:(noofest-1)
    %Band Elimination the region of +5 & -5 degrees of the maximum angle
    %If angle is between 0 and 5     
    if theta<=5
        for j = 1:theta+5
            for i = 1:rl
                h2(i,j)=0;
            end
        end

        for j = 355:360
            for i = 1:rl
                h2(i,j)=0;
            end
        end

    %If angle is between 355 and 360     
    elseif theta>=355
        for j = theta-5:360
            for i = 1:rl
                h2(i,j)=0;
            end
        end
        for j = 1:360-theta
            for i = 1:rl
                h2(i,j)=0;
            end
        end

    %For any other angle    
    else
        for j = theta-5:theta+5
            for i = 1:rl
                h2(i,j)=0;
            end
        end
    end

    %Finding the next maximum
    maxi = 0;
    theta = 0;
    for i = 1:rl
        for j = 1:360
            if h2(i,j)>maxi
                maxi = h2(i,j);
                theta = j;
                r1 = i;
            end
        end
    end

    %Storing next maximum in the array
    maxarr(g) = theta;   
    g = g + 1;
end

newarr = maxarr;
arrsiz = size(maxarr);

%Fitting it into 180 degrees
for i = 1:arrsiz(2)
    if newarr(i)>180
        newarr(i) = newarr(i)-180;
    end
end
waitbar(8/steps, handle);

%Possible values of THETA
THETAS = newarr;