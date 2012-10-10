%Divides the datapoints of X equally according to C, the amount of mixtures
%wanted, and stores them as C cells in MOG.

function MOG = init_mog(X,C)

start = 0;
step = length(X(:,1)) / C;
MOG = cell(C,1);
for i = 1:C
    temp = X((start+1):(start + step), 1:2);
    MOG{i} = struct('MU', mean(temp), 'SIGMA', cov(temp), 'PI', 1/C);
    start= start + step;
end
end