% E-Step function in EM algorithm,
% outputs the responsibilities
function [Q LL] = mog_E_step(X,MOG)

    L = length(MOG);
    N = length(X(:,1));
    Q = zeros(N, L);
    total = zeros(N, 1);
    for i = 1:L
        % responsibility of the gaussian for each datapoint 
        prob = MOG{i}.PI * lmvnpdf(X, MOG{i}.MU, MOG{i}.SIGMA);
        Q(:,i) = prob;
        total = total + prob;
    end
   
    % evaluate responsibility of the gaussian for each datapoint 
    Q = Q ./ repmat(total, [1 L]);
   
    LL = sum(log(total));
end
