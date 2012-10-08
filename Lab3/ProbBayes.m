function pr_Bayes = ProbBayes(pr_XnCk,pr_Ck,pr_WH,pr_ham)

%probality that is a spam mail given the word is in it


for i=1:size(pr_XnCk)
pr_Bayes(i) = (pr_XnCk(i)*pr_Ck)/(pr_WS(i)*pr_spam+pr_WH(i)*pr_ham);
end