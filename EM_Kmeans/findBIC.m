%Calculates the BIC and returns list of K,log likelihood, and BIC
maxbic = -Inf;
[n, dim] = size(X);
bicList = zeros(10,2);

for K = 1:10
    pk = K-1 + K*dim + K*dim*(dim+1)/2;
    [cparams ,E ,L] = GMMC(X,K,10);
    bic = L - (.5*pk*log(n));
    
    bicList(K,1) = L;
    bicList(K,2) = bic;
    if bic > maxbic
       maxK = K;
        
       maxbic = bic;
    end
    
end
