function pr_Bayes = ProbBayes(pr_WS,pr_spam,pr_WH,pr_ham)

%probality that is a spam mail given the word is in it


for i=1:size(pr_WS)
pr_Bayes(i) = (pr_WS(i)*pr_spam)/(pr_WS(i)*pr_spam+pr_WH(i)*pr_ham);
end