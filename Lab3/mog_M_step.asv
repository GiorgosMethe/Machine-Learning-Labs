%The M step in the EM algorithm

function MOG = mog_M_step(X,Q,MOG)
    K = length(MOG);
    N = length(X(:,1));
    
    for k = 1:K
        N_k = sum(Q(:,k));
       
        %Updating mixture amount
        MOG{k}.PI = N_k / N;
       
        %Updating mean
        MOG{k}.MU = sum(repmat(Q(:,k),1,2) .* X(:, 1:2)) / N_k;

        %Updating covariance if it does not contain singularities
        temp = (repmat(Q(:,k)',2,1) .* ((X(:,1:2) - repmat(MOG{k}.MU, N, 1))') ...
            * (X(:,1:2) - repmat(MOG{k}.MU, N, 1)));
        temp = temp / N_k;
        if cond(temp) < 10^10
            MOG{k}.SIGMA = temp;
        end
    end