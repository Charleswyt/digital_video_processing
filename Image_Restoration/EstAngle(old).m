function THETA = EstAngle(ifbl, expertstatus, handle)
%Function to estimate blur angle
%Inputs: ifbl, expertstatus
%Returns: THETA
%
%ifbl:  It is the input image.
%expertstatus: It decides whether to display plots and images or no
%       1 - Display plots and images
%       0 - Do not display
%handle: It is the handle to the waitbar(progress bar)
%THETA: It is the blur angle. The angle at which the image is blurred.
%
%Example:
%       THETA = EstAngle(image, expertstatus, handle);
%       This call takes image as input and returns the blur angle.

%No of steps in the algorithm
steps = 8;

%Preprocessing
%Performing Median Filter before restoring the blurred image
ifbl = medfilt2(abs(ifbl));
waitbar(1/steps, handle);

%Display input image
if expertstatus
    figure(1);
    subplot(2,2,1);
    imshow(abs(ifbl));
    title('Input image');
end

%Performing LOG transform on blurred image
lgifbl = log(1+abs(ifbl));
waitbar(2/steps, handle);

%Converting blurred image to edged image
BW = edge(lgifbl);
waitbar(3/steps, handle);

%Display edges in input image
if expertstatus
    subplot(2,2,2);
    imshow(BW);
    title('Edges in Input image');
end

%Using Hough Transform to calculate the accumulator array
%Performing Hough Transform
H = hough(BW);
waitbar(4/steps, handle);

%Exchanging the parts of the accumulator array
%First 90 to second half i.e. 91-180 & vice-versa
%since angle returned by Hough transform is at right angle to edge
for i=1:90
    for j=1:size(H, 1)
        temp = H(j, i);
        H(j, i) = H(j, 90+i);
        H(j, 90+i) = temp;
    end
end
waitbar(5/steps, handle);

%Display Hough transform accumulator array
if expertstatus
    subplot(2,2,3);
    imshow(abs(H), []);
    title('Hough transform accumulator array');
end

%Calculating the maximum & minimum value in H
maxi = max(max(H));
mini = min(min(H));

%Finding size of image H
sizeofH = size(H);

%{ Method 1: Making the maximum as white and remaining all as black
%Converting to binary by making max value white & rest all to black
%for i=1:sizeofH(2),
%    for j=1:sizeofH(1),
%        if H(j, i)==maxi
%            H(j, i) = 1;
%        else
%            H(j, i) = 0;
%        end
%    end
%end
%}

%{ Method 3: Taking the mean of maximum and minimum to calculate threshold
%Finding mean of maximum and minimum pixel intensity
thresh=(maxi - mini)/2;
%Converting to binary
for i=1:sizeofH(2),
    for j=1:sizeofH(1),
        if H(j, i)>=thresh
            H(j, i) = 1;
        else
            H(j, i) = 0;
        end
    end
end
%}
waitbar(6/steps, handle);

%Finding size of the H matrix
sizeofH = size(H);

%Finding the sum of all columns
for i=1:sizeofH(2),
    %Initialising to zero
    ColsofH(i) = 0;
    for j=1:sizeofH(1),
        ColsofH(i) = ColsofH(i) + H(j, i);
    end
end
waitbar(7/steps, handle);

%Display collapsed Hough transform accumulator array
if expertstatus
    subplot(2,2,4);
    plot(abs(ColsofH)); grid on;
    title('Maximum element in accumulator array');
end

%Finding the maximum value and the corresponding index
%Perpendicular to the index is the blur angle
[maximum, THETA] = max(ColsofH);
waitbar(8/steps, handle);