% E-Step function in EM algorithm,
% outputs the responsibilities
function [Q LL] = mog_E_step(X,MOG)

    L = length(MOG);
    N = length(X(:,1));
    Q = zeros(N, L);
    SumProb = zeros(N, 1);
    for i = 1:L
        % responsibility of the gaussian for each datapoint 
        prob = MOG{i}.PI * mvnpdf(X, MOG{i}.MU, MOG{i}.SIGMA);
        Q(:,i) = prob;
        SumProb = SumProb + prob;
    end
   
    % evaluate responsibility of the gaussian for each datapoint
    sumMat = repmat(SumProb, [1 L]);
    Q = Q ./ sumMat;
   
    LL = sum(log(SumProb));
end
