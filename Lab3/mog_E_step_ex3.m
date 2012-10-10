function [Q LL] = mog_E_step_ex3(X,MOG)
    
    %Number of components
    L = length(X(:,1));
    K = length(MOG);
    Q = zeros(L, K);
    for k = 1:K
        Q(:,k) = log(MOG{k}.PI) + lmvnpdf(X, MOG{k}.MU, MOG{k}.SIGMA);
    end
    
    Qsum = logsumexp(Q);
  
    for k=1:k
        Q(:,k) = Q(:,k)-Qsum;
    end
    
    %exponential of the ln(prob)
    Q=exp(Q);
    LL = sum(Qsum);
    
end

