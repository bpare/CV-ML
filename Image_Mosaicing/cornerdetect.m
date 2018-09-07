%This is an implementation of the Harris Corner Detection Algorithm
function [grayImage output] = cornerdetect(image)
    grayImage = rgb2gray((image));

    %Compute the x and y image gradient 
    sigma = 1;
    halfwid = sigma * 3;
    [xx, yy] = meshgrid(-halfwid:halfwid, -halfwid:halfwid);
    Gxy = exp(-(xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));
    [Gx, Gy] = imgradientxy(grayImage);

    %Compute product of derivatives at each pixel
    l2x = Gx .* Gx;
    l2y = Gy .* Gy;
    lxy = Gx .* Gy;

    %Compute the sums of products at each pixel
    Sx2 = conv2(Gxy, l2x);
    Sy2 = conv2(Gxy, l2y);
    Sxy = conv2(Gxy, lxy);

    %Compute the M matrix and the Response (R) at each pixel, and then
    %threshold R
    threshold =19000000000;
    F = zeros(size(grayImage,1), size(grayImage,2));
    for x = 1:size(grayImage,1)

        for y = 1:size(grayImage,2)
            M = [Sx2(x,y) Sxy(x,y); Sxy(x,y) Sy2(x,y)];   
            R = det(M) - (.04).*(trace(M)^2);

            if R > threshold
                F(x,y) = R;
            end

        end
    end

    %Use matlab's imdilate function to compute nonmax suppression
    output = F > imdilate(F, [1 1 1; 1 0 1; 1 1 1]);

end
