function finalImage = warpImage(im1,im2,H)

    % Pad the final image
    finalImage = im1;
    finalImage = padarray(finalImage, [0 size(im2, 2)], 0, 'post');
    finalImage = padarray(finalImage, [size(im2, 1) 0], 0, 'both');

    % Seperate the 1st image and the 2nd warped image
    im1padded = finalImage;
    warpedImage = uint8(zeros(size(finalImage,1),size(finalImage,2),3));

    %Use the homography matrix to translate all points into new warped image
    for i = 1:size(finalImage, 2)
        for j = 1:size(finalImage, 1)
            p1 = H * [i; j-floor(size(im2, 1)); 1];
            p1 = p1 ./ p1(3);
            x2 = floor(p1(1));
            y2 = floor(p1(2));

            %Check for boundaries
            if x2 > 0 && x2 <= size(im2, 2)
                if y2 > 0 && y2 <= size(im2, 1)
                finalImage(j, i,:) = im2(y2, x2,:);
                warpedImage(j, i,:) = im2(y2, x2,:);
                end
            end
        end
    end

     %Blend the overlap of the images by averaging the pixel values
    for i = 1:size(finalImage, 2)
        for j = 1:size(finalImage, 1)
            if sum(im1padded(j,i,:)) ~= 0 && sum(warpedImage(j,i,:)) ~= 0
                finalImage(j, i,:) = (im1padded(j,i,:)/2)+(warpedImage(j,i,:)/2);
            end
        end
    end

    %Crop the image to the appropriate size
    i = 1;
    rowsize = size(finalImage, 1);
    while i < rowsize
            if sum(sum(finalImage(i,:,:))) == 0
                finalImage(i,:,:) = [];
                i = 1;
            end
    i=i+1;
    rowsize = size(finalImage, 1);
    end

    j = 1;
    colsize = size(finalImage, 2);
    while j < colsize
            if sum(sum(finalImage(:,j,:))) == 0
                finalImage(:,j,:) = [];
                j = 1;
            end
    j=j+1;
    colsize = size(finalImage, 2);
    end
    
    figure
    imshow(finalImage);

end
