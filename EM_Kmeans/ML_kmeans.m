function [minError,means, maxCluster, sumError, maxr] = ML_kmeans(X,r,K)
 
    [n, dim] = size(X);

    %Initialize
    minError = 1000000;
    sumError = zeros(100,2);
    maxr = 0;

    for i = 1:r

    %Choose random point for starting mean
    rand_n= randperm(n);
    rand_n= rand_n(1:K);
    means = X(rand_n,:);
    iterations = 1;

        while 1 
            distance= pdist2(X,means);

            %find index, or 'labels'
            [minVal ,index] = min(distance',[],1);

            for k=1:K
                %calculate new means
                means(k, :) = sum(X(find(index == k), :))/ length(find(index == k));
            end

            %Compute sum squared error
            error = 0;

            for j=1:n
                error = error + norm(X(j, :) - means(index(j),:), 2);
            end

            error = error / n;
            sumError(iterations,2)=error;
            sumError(iterations,1)=iterations;

            if iterations > 100
                break;
            end

            iterations=iterations+1;
       end

         %Keep track of max clustering so far
         if error < minError
            maxCluster = index;
            maxr = r;
            minError = error;
         end
    end

    %plot results 

    colors = {'bs', 'g*', 'magentao','k*','y+','ro','c.','bs','g*','k*'};
    figure;
    subplot(2,2,1)

        for j=1:K
           hold on, plot(X(find(maxCluster == j), 1), X(find(maxCluster == j), 2),  colors{j})
           hold on
           plot(means(j,1),means(j,2),'ro','MarkerSize',10,'MarkerFaceColor','r')
           hold on

        end

    legend('class1','mean1','class2','mean2','class3','mean2');
    title('Dataset4: K-means');
    xlabel('feature 1');
    ylabel('feature 2');
    subplot(2,2,2)
    plot(sumError(:,1), sumError(:,2),  'b')
    title('Dataset4: K-means');
    xlabel('Iteration');
    ylabel('sum-squared error');
end
