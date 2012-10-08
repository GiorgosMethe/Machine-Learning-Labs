%The E step in the EM algorithm

function [Q LL] = mog_E_step(X,MOG)
    %Number of components
    K = length(MOG);
    N = length(X(:,1));
    Q = zeros(N, K);
    total = zeros(N, 1);
    for k = 1:K
        Q(:,k) = MOG{k}.PI * mvnpdf(X, MOG{k}.MU, MOG{k}.SIGMA);
        total = total + Q(:,k);
    end
   
    Q = Q ./ repmat(total, 1, K);
   
    LL = sum(log(total));

