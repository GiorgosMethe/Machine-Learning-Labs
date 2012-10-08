%Divides the datapoints of X equally according to C, the amount of mixtures
%wanted, and stores them as C cells in MOG.

function MOG = init_mog(X,C)

step = length(X(:,1)) / C;
pos = 1;
MOG = cell(C,1);
for i = 1:C
    temp = X(pos:(pos + step - 1), 1:2);
    pos= pos + step;
    MOG{i} = struct('MU', mean(temp), 'SIGMA', cov(temp), 'PI', 1/C);
end