function [cparams] = M_Step(X,K,E, cparams)

    [n,d] = size(X);
    %Calculate the new mu,sigma,and priors based on given EM equations
    for i=1:K
        cparams(i).prior = 0;
        cparams(i).mu = 0;
        cparams(i).sigma = 0;
    end

    for i=1:K  
        for j=1:n
            cparams(i).prior = cparams(i).prior + E(j,i);
            cparams(i).mu = cparams(i).mu + E(j,i)*X(j,:)';
        end
        cparams(i).mu = cparams(i).mu/(cparams(i).prior);
    end
    
    for i=1:K
        for j=1:n
            XM = X(j,:)'-cparams(i).mu;
            cparams(i).sigma = cparams(i).sigma + E(j,i)*XM*XM';
        end
        cparams(i).sigma = cparams(i).sigma/(cparams(i).prior);
    end
    
    for i=1:K
        cparams(i).prior=cparams(i).prior/n;
    end

end
