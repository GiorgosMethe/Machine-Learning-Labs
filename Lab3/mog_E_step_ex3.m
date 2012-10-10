%The E step in the EM algorithm

function [Q LL] = mog_E_step_ex3(X,MOG)
    %Number of components
    N = length(X(:,1));
    K = length(MOG);
    Q = zeros(N, K);
    for k = 1:K
        Q(:,k) = log(MOG{k}.PI) + lmvnpdf(X, MOG{k}.MU, MOG{k}.SIGMA);
    end
    Qsum = logsumexp(Q);
    
    for k=1:k
    Q(:,k) = Q(:,k)-Qsum;
    end
    Q=exp(Q);
    LL = sum(Qsum);

