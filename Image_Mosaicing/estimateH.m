function H = estimateH(numMatch,points1,points2);

    %Initialize
    minError = 6;
    A = zeros(8, 8);
    b = zeros(8, 1);
    H = zeros(3,3);
    maxInliers = -Inf;
    p=zeros(4,2);
    p1=zeros(4,2);
    for ind = 1 : 500

        %Generate 4 random point correspondences
        randSample = randperm(numMatch, 4);
        i = 1;
        for j = 1:4

            x1 = points1(randSample(j), 1);
            y1 = points1(randSample(j), 2);
            x2  = points2(randSample(j), 1); 
            y2  = points2(randSample(j), 2);

            %Compute the A and b matrices
            A(i, :) = [x1 y1 1 0 0 0 -x1*x2 -y1*x2];
            b(i) = x2;
            i = i + 1;      
            A(i, :) = [0 0 0 x1 y1 1 -x1*y2 -y1*y2];
            b(i) = y2;
            i = i + 1; 
 

        end


    x = A\b;
    
    homography = [x(1) x(2) x(3); x(4) x(5) x(6); x(7) x(8) 1];
    numInliers = 0;
    
    %Find the number of inliers to determine if this is a max homography
    for ind = 1:numMatch
        
        x1 = points1(ind, 1);
        y1 = points1(ind, 2);
        x2  = points2(ind, 1);
        y2  = points2(ind, 2);
    
        point1 = [x1; y1; 1];
        point2  = [x2; y2; 1];
        
        M = homography*point1;
        M = M ./ M(3);
        error = norm((M - point2),2);
        if error <= minError
            numInliers = numInliers + 1;
        end
    end
    if numInliers > maxInliers
       maxInliers = numInliers;
       H = homography;
    end
end
 
 
