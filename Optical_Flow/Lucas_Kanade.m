function Lucas_Kanade(im1,im2)
WINDOWSIZE = 4;%windowsize of neighborhood for LK method.
 
%smooth images
im1 = imgaussfilt(im1, 1);
im2 = imgaussfilt(im2, 1);
 
%compute spatial intensity gradients
im2 = im2double(im2);
im1 = im2double(im1);
[SIGx, SIGy] = imgradientxy(im2);
 

%compute temporal gradient
TG = im1 - im2;
 
%Neighborhood Lucas-Kanade method
W = WINDOWSIZE;
u = zeros(size(im1), 'double');
v = zeros(size(im1), 'double');
for i = W+1:size(SIGx,1) - W
    for j = W+1:size(SIGx,2) - W
       %v = (At * A)^-1  * At * B
 
       Ix = SIGx(i - W : i + W, j - W : j + W);
       Iy = SIGy(i - W : i + W, j - W : j + W);
       T = TG(i - W : i + W, j - W : j + W);
       
       Ix = Ix(:);
       Iy = Iy(:);
       T = T(:);
       
       A = [Ix, Iy];
       b = -T;
       %vel = inv(A' * A) * A' * b;
       vel = pinv(A) * b;
       
       u(i,j) = vel(1);
       v(i,j) = vel(2);
       
    end
end
 
%sampling vectors for output
 [m, n] = size(im1);
 K = floor(m/50);
u = u(1:K:end, 1:K:end);
v = v(1:K:end, 1:K:end);
[X,Y] = meshgrid(1:n, 1:m);
X = X(1:K:end, 1:K:end);
Y = Y(1:K:end, 1:K:end);
 
%display results
figure;
imshow(im1);
hold on;
quiver(X,Y,u,v,'cyan');
end
