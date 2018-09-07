function [h N] = gaussianfilter(sigma) 
%size of filter
N=ceil(sigma*5);
 
 
%Create corresponding values for both X and Y
ind = -floor(N/2) : floor(N/2);
[X] = meshgrid(ind, 1);
 
%// Create Gaussian Mask
h = (X./(sigma*sigma)).*exp(-(X.^2) / (2*sigma*sigma));
 
end
