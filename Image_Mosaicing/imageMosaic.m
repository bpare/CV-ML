function finalImage = imageMosaic(image1,image2)

    %First read in images
    im1 = imread(image1);
    im2 = imread(image2);
    
    %Use Harris Corner Detection Algorithm to get set of corner points
    [grayImage1 output1] = cornerdetect(im1);
    [grayImage2 output2] = cornerdetect(im2);
    
    %Find point corresponences by using normalized cross correlation
    [numMatch,points1,points2] = getCorrespondences(im1,im2,grayImage1, grayImage2,output1,output2);
    
    %Use point corresponences and RANSAC to estimate homography
    H = estimateH(numMatch,points1,points2);
    
    %Warp one image onto the other one and blend
    finalImage= warpImage(im1,im2,H);
    
end
