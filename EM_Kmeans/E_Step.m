function [E P] = E_Step(X,K,cparams)

    [n,d] = size(X);

    E = zeros(n,K);

    %Find the expected likelihood for each point and cluster
    for i=1:n    
        for j=1:K
            
            %Ensure covariance is symmetric postivie & semidefinite
            if cparams(j).sigma==zeros(d,d)
                cparams(j).sigma=ones(d,d)*eps;
            end
            
            E(i,j) = mvnpdf(X(i,:),cparams(j).mu',cparams(j).sigma)*cparams(j).prior;

        end
        E(i,:) = E(i,:)/sum(E(i,:));

    end
end
