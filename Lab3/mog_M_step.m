%M-Step of the EM algorithm,
%here we compute the new parameters
%using the responsibilities computed
%by e-step

function MOG = mog_M_step(X,Q,MOG)
    
    % number of component
    L = length(MOG);
    % length of the training set
    N = length(X(:,1));
    
    for i = 1:L
        
        %summation of the Q for every component
        N_i = sum(Q(:,i));
       
        %updating mean
        MOG{i}.MU = sum(repmat(Q(:,i),[1 2]) .* X) / N_i;

        %updating covariance if it does not contain singularities
        Mt1 = repmat(MOG{i}.MU, [N 1]);
        temp = (repmat(Q(:,i)', [2 1]) .* ((X - Mt1)') * (X - Mt1));
        
        %updating mixture amount
        MOG{i}.PI = N_i / N;
        
        temp = temp / N_i;
        
        if cond(temp) < 10^10
            MOG{i}.SIGMA = temp;
        end
        
    end
end