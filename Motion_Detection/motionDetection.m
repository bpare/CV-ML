NUM_FRAMES = 354;
LOAD_FRAMES = 9;
 
for n = 2:NUM_FRAMES
 
    originalImage(:,:,:,n) = imread(strcat('advbgst1_21_', sprintf('%04d', n), '.jpg'));
   
    %% Smoothing Filters 
        %% 3x3 Box Filter
         %imageMatrix(:,:,n) = imboxfilt(rgb2gray(originalImage(:,:,:,n)),3);
        
        %% 5x5 Box Filter
         %imageMatrix(:,:,n) = imboxfilt(rgb2gray(originalImage(:,:,:,n)),5);
        
        %% Gaussian Filter with sigma defined by user
        %imageMatrix(:,:,n) = imgaussfilt(rgb2gray(originalImage(:,:,:,n)),.25);
        
    %No smoothing filter    
   % imageMatrix(:,:,n) = rgb2gray(originalImage(:,:,:,n));
    if(n > LOAD_FRAMES)
 
        % Load next frames of video
        for i = 1:LOAD_FRAMES
        imageMatrixCut(:,:,i) = imageMatrix(:,:,n - (i - 1));
        end
        
       %%Using diffing method
        %{
         diffMatrix = (diff(imageMatrixCut(:,:,3:4),1,3));
         binaryMask = imbinarize(diffMatrix (:,:),max(.07,graythresh(diffMatrix (:,:))));
         imshow( originalImage(:,:,:,n-2).*uint8(binaryMask));
         if n == 55
         imwrite(originalImage(:,:,:,n-2).*uint8(binaryMask),strcat('adv_img01_2', sprintf('%04d', n), '.jpg'));
         end
         %}
         
       %% Using simple Filter 
       %{
         diffMatrix = imageMatrixCut;
         diffMatrix(:,:,(3)) = (diffMatrix(:,:,2) - diffMatrix(:,:,4)) * .5;
         binaryMask = imbinarize(diffMatrix (:,:,3),min((max(.07,graythresh(diffMatrix (:,:)))),.07));
         imshow( originalImage(:,:,:,n-2).*uint8(binaryMask));
       %}
       
       %% Use 1D Gaussian Filter
       %{
        diffMatrix = imageMatrixCut;
        [h N]= gaussianfilter(1);
        convSum = zeros(size(diffMatrix(:,:,(floor(N/2)+1))),'uint8');
        for k = 1:floor(N/2)
             convSum = convSum + h(floor(N/2)+1+k)*(diffMatrix(:,:,floor(N/2)+1+k)-diffMatrix(:,:,floor(N/2)+1-k));
         end
         diffMatrix(:,:,(floor(N/2)+1)) = convSum;
         binaryMask = imbinarize(diffMatrix (:,:,floor(N/2)+1),min((max(.07,graythresh(diffMatrix (:,:)))),.07));
         imshow( originalImage(:,:,:,n-floor(N/2)).*uint8(binaryMask));
       %}
    end
    

