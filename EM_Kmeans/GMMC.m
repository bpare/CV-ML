%This is the main function for the EM algorithm
function [maxParams, E ,maxL, labels, LList] = GMMC(X,K,r)
 
[n, dim] = size(X);
maxL = -Inf;
labels = zeros(n,1);

    for i = 1:r
        rand_n= randperm(n);
        rand_n= rand_n(1:K);

        % Initialize random start
        for j = 1:K
                cparams(j).mu = X(rand_n(j),:)';
                cparams(j).sigma = [1,0;0,1];
                cparams(j).prior = 1/K;
        end

        Lprev = -Inf;
        L = 0;
        iterations = 1;
        clear LList;

        while 1
                %Perform EM until convergence or max iterations
               [E] = E_Step(X,K,cparams);
               cparams = M_Step(X,K,E, cparams);
               Lprev = L;
               L = getLikelihood(X,K,cparams,n);

               LList(iterations,1) = L; % keep track of likelihoods
               LList(iterations,2) = iterations;

               if abs(100*(L-Lprev)/Lprev)<0.1 %convergence criteria
                   break;
               end

               if iterations > 40
                  break
               end

               iterations = iterations +1;
        end

        %Find the parameters so far that give max L
        if L > maxL
            maxL = L;
            maxParams = cparams;
            maxE = E;
        end

    end

    %Find labels
    for i = 1:n
        [maxInd,Ind] = max(E(i,:));
        labels(i) = Ind;
    end
 
end
