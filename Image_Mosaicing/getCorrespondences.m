function [numMatch,points1,points2] = getCorrespondences(im1,im2,grayImage1, grayImage2,output1,output2)

    %Set the threshold for the correlation
    corThresh = .9;

    %Set neighborhood size to use
    patchsize = .5*80;

    %Find the number of available corners (avoiding borders)
    numCorners1 = sum(sum(output1((patchsize+1):(size(output1,1)-(patchsize+1)),(patchsize+1):(size(output1,2)-(patchsize+1)))));

    %Initialize
    cornerPosition1 = zeros(numCorners1,2);
    patch1 = uint8(zeros((2*patchsize)+1,(2*patchsize)+1,numCorners1));

    %Find the image patches corresponding to the corners in the 1st image
    i = 0;
    for x = (patchsize+1):(size(output1,1)-(patchsize+1))
        for y = (patchsize+1):(size(output1,2)-(patchsize+1))
            if output1(x,y) == 1
                i = i+1;
                cornerPosition1(i,:) = [y,x];
                patch1(:,:,i) = grayImage1((x-patchsize):(x+patchsize),(y-patchsize):(y+patchsize));
            end

        end
    end

    %Repeat for 2nd image

    %Find the number of available corners (avoiding borders)
    numCorners2 = sum(sum(output2((patchsize+1):(size(output1,1)-(patchsize+1)),(patchsize+1):(size(output1,2)-(patchsize+1)))));

    %Initialize
    cornerPosition2 = zeros(numCorners1,2);
    patch2 = uint8(zeros((2*patchsize)+1,(2*patchsize)+1,numCorners2));

    %Find the image patches corresponding to the corners in the 2nd image
    i = 0;
    for x = (patchsize+1):(size(output2,1)-(patchsize+1))
        for y = (patchsize+1):(size(output2,2)-(patchsize+1))
            if output2(x,y) == 1
                i = i+1;
                cornerPosition2(i,:) = [y,x];
                patch2(:,:,i) = grayImage2((x-patchsize):(x+patchsize),(y-patchsize):(y+patchsize));

            end
        end
    end

    %Initialize
    correlation= zeros(numCorners1,numCorners2);
    points1 = zeros(1,2);
    points2 = zeros(1,2);
    numMatch = 0;

    %Find the NCC score for each pair of patches, and create the point
    %correspondences if the correlation is above a threshold
    %Also, keep track of the number of matches found
    
    for i = 1:numCorners1
        for j = 1:numCorners2
            K = normxcorr2(patch1(:,:,i),patch2(:,:,j));
            correlation(i,j) = max(K(:));
            if correlation(i,j) > corThresh
                  numMatch = numMatch +1;
                  points1 = [points1;cornerPosition1(i,:)];
                  points2 = [points2;cornerPosition2(j,:)];
            end
        end
    end
    points1 = points1(2:(numMatch+1),:);
    points2 = points2(2:(numMatch+1),:);

    %Plot the point correspondences
    width = size(grayImage1, 2);
    im = horzcat(im1, im2);
    figure
    imshow(im)    
    hold on
    
    for i = 1:numMatch
             plot(points1(i, 1), points1(i, 2), 'y+', points2(i, 1) + width, ...
             points2(i, 2), 'y+');
             line([points1(i, 1) points2(i, 1) + width], [points1(i, 2) points2(i, 2)], ...
             'color',rand(1,3));
    end
end
         


