function logsum = logsumexp (X)


    n = size(X,2);
    
    for i=1 : (n-1)
        
        lnpa = X(:,i);
        lnpb = X(:,i+1);
        
        maxv = max(lnpa,lnpb);
        minv = min (lnpa,lnpb);
        
        X(:,i+1) = (maxv + log(ones(size(lnpa,1),1)+exp(minv-maxv))); 
    end
    
    logsum = X(:, end);
    
end