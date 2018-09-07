im1 = rgb2gray(imread('toys21.gif'));
im2 = rgb2gray(imread('toys22.gif'));
figure(1)
Lucas_Kanade(im1,im2);
im1 = impyramid(im1, 'reduce');
im2 = impyramid(im2, 'reduce');
figure(2)
Lucas_Kanade(im1,im2);
