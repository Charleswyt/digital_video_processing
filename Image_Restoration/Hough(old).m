function h = hough(f)
%Function to perform Hough Transform on an image
%Inputs:  f
%Returns: h
%
%f: It is the input image.
%h: It is the accumulator array
%
%Example:
%       h = Hough(image);
%       This call takes image as input and returns accumulator array

%dtheta specifies the spacing (in degress) of the hough tranform bins along the theta axis
%drho specifies the spacing of the hough trnsform bins along the rho axis

if nargin<3
    drho = 1;
end

if nargin<2
    dtheta = 1;
end

f = double(f);
[M, N] = size(f);
theta = linspace(-90, 0, ceil(90/dtheta)+1);
theta = [theta -fliplr(theta(2:end-1))];
ntheta = length(theta);
D = sqrt((M-1)^2 + (N-1)^2);
q = ceil(D/drho);
nrho = 2*q-1;
rho = linspace(-q*drho, q*drho, nrho);
[x, y, val] = find(f);
x = x-1;
y = y-1;
h = zeros(nrho, length(theta));

%To avoid excessive memory usage, process 1000 nonzero pixel values at a time
for k=1:ceil(length(val)/1000)
    first = (k-1)*1000+1;
    last = min(first+999, length(x));
    x_matrix = repmat(x(first:last), 1, ntheta);
    y_matrix = repmat(y(first:last), 1, ntheta);
    val_matrix = repmat(val(first:last), 1, ntheta);
    theta_matrix = repmat(theta, size(x_matrix, 1), 1)*pi/180;
    rho_matrix = x_matrix .* cos(theta_matrix) + y_matrix .* sin(theta_matrix);
    slope = (nrho-1)/(rho(end)-rho(1));
    rho_bin_index = round(slope*(rho_matrix-rho(1))+1);
    theta_bin_index = repmat(1:ntheta, size(x_matrix, 1), 1);
    h = h + full(sparse(rho_bin_index(:), theta_bin_index(:), val_matrix(:), nrho, ntheta));
end