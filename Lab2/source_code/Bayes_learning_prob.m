function prob_WC = Bayes_learning_prob (T,n,d)
    
    prob_WC = [];
    
   for i=1:size(n,2)
      prob_WC = [prob_WC (T(i)+1)/(d+2)];   
   end
    
end