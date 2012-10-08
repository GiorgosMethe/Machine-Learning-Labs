clc
clear all;
close all;

%Word counter for spam train
CNT_spam = countwords('spam\train');
Afields = fieldnames(CNT_spam);
Acell = struct2cell(CNT_spam);
A=[Afields,Acell];
Asorted=sortcell(A,2);
Spam_train = flipdim(Asorted,1);

clear Afields Acell A Asorted;

%Word counter for ham train
CNT_ham = countwords('ham\train');
Afields = fieldnames(CNT_ham);
Acell = struct2cell(CNT_ham);
A=[Afields,Acell];
Asorted=sortcell(A,2);
Ham_train = flipdim(Asorted,1);

clear Afields Acell A Asorted;

%Classes words and counts in ham and spam mails
[words,counts]=wordtable(CNT_ham,CNT_spam);
counts=num2cell(counts);
list=[words,counts];

%How many ham and spam mails?
num_ham = count_files('HAM/train');
num_spam = count_files('SPAM/train');

%Prior Probabilities
pr_ham=0.2;
pr_spam=1-pr_ham;

%Automated Feature selection
for i=1:size(list)
    list{i,4} = list{i,2}/num_ham;
    list{i,5} = list{i,3}/num_spam;
    list{i,6} = abs(list{i,5} - list{i,4})/(list{i,5} + list{i,4}) + ((list{i,2}+list{i,3})/(num_ham+num_spam));
end

list_srt = sortcell(list,6);
list_srt= flipdim(list_srt,1);

selected_words = word_selection(list_srt,20);

% selected_words = {'ABOUT','HOWEVER','ISSUES','THANKS','BOB','BETWEEN','NEED','HTTP','SG','MR','MEDS','PILLS'};

%Probability that is spam/ham given the word with automated selection
[CNTH,NUM] = countre('ham/train',selected_words);
[CNTS,NUM] = countre('spam/train',selected_words);

%Unigram language model
%add-one smoothing
prob_ham = Bayes_learning_prob (CNTH,selected_words,num_ham);
prob_spam = Bayes_learning_prob (CNTS,selected_words,num_spam);

%Likelihood
checkh = presentredir('ham\train_test',selected_words);
checks = presentredir('spam\train_test',selected_words);
hamTest_check_ham = ones(size(checkh));
hamTest_check_spam = ones(size(checkh));
spamTest_check_ham = ones(size(checks));
spamTest_check_spam = ones(size(checks));

%How many test mail do we have?
num_ham_test = count_files('ham\train_test');
num_spam_test = count_files('spam\train_test');

for i=1:num_ham_test
    for j=1:size(selected_words,2)
        if checkh(i,j)>0
            hamTest_check_ham(i,j) = hamTest_check_ham(i,j)*checkh(i,j)*prob_ham(1,j);
            hamTest_check_spam(i,j) = hamTest_check_spam(i,j)*checkh(i,j)*prob_spam(1,j);
        end
    end
end

hamTest_check_ham = prod(hamTest_check_ham,2);
hamTest_check_spam = prod(hamTest_check_spam,2);

for i=1:num_spam_test
    for j=1:size(selected_words,2)
        if checks(i,j)>0
            spamTest_check_ham(i,j) = spamTest_check_ham(i,j)*checks(i,j)*prob_ham(1,j);
            spamTest_check_spam(i,j) = spamTest_check_spam(i,j)*checks(i,j)*prob_spam(1,j);
        end
    end
end
spamTest_check_ham = prod(spamTest_check_ham,2);
spamTest_check_spam = prod(spamTest_check_spam,2);

%posterior probability for ham test
hamTest_probH = ProbBayes(hamTest_check_ham,pr_ham,hamTest_check_spam,pr_spam);
hamTest_probS = ProbBayes(hamTest_check_spam,pr_spam, hamTest_check_ham, pr_ham);


%posterior probability for spam test
spamTest_probH = ProbBayes(spamTest_check_ham,pr_ham,spamTest_check_spam,pr_spam);
spamTest_probS = ProbBayes(spamTest_check_spam,pr_spam, spamTest_check_ham, pr_ham);


j=1;
for Threshold=0:0.01:1
counter = 1;
for i=1:num_ham_test
    if hamTest_probS(i) > Threshold
        Classification(i,1) = 0;
        Classification(i,2) = 1;
    else
        Classification(i,1) = 1;
        Classification(i,2) = 0;
    end
    counter = counter+1;
end

for i=1:num_spam_test
    if spamTest_probS(i) > Threshold
        Classification(counter,1) = 0;
        Classification(counter,2) = 1;
    else
        Classification(counter,1) = 1;
        Classification(counter,2) = 0;
    end
    counter = counter+1;
end

targets = zeros((num_ham_test+num_spam_test),2);
targets(1:num_ham_test,1)=1;
targets((num_ham_test+1):(num_ham_test+num_spam_test),2)=1;
[C, rate] = confmat(Classification, targets);


TPR(j) = C(1,1)/(C(1,1)+C(1,2));
FPR(j) = C(2,1)/(C(2,1)+C(2,2));
accuracy_ham(j)= C(1,1)/144;
accuracy_spam(j)= C(2,2)/54;

j = j+1;
end

%Plot ROC curve
figure();
Roc = TPR./FPR;
plot(FPR,TPR)
xlabel('False positive rate (Specificity)');
ylabel('True positive rate (Sensitivity)');
title('Roc curve');

%Find minimum distance from (0,1)
min=1000;
for i=1:size(FPR,2)
    distance=sqrt((FPR(i)-0)^2+(TPR(i)-1)^2);
    if distance<min
        min=distance;
        best=i;
    end
    if FPR(i)==0.30 && TPR(i)==1
       true_threshold = i;
    end
end
FPR(best);
TPR(best);


%AUC
AUC = trapz(FPR,TPR);





% Classifier Evaluation in Test Set

%Likelihood
checkh = presentredir('ham\test',selected_words);
checks = presentredir('spam\test',selected_words);
hamTest_check_ham = ones(size(checkh));
hamTest_check_spam = ones(size(checkh));
spamTest_check_ham = ones(size(checks));
spamTest_check_spam = ones(size(checks));

%How many test mail do we have?
num_ham_test = count_files('ham\test');
num_spam_test = count_files('spam\test');

for i=1:num_ham_test
    for j=1:size(selected_words,2)
        if checkh(i,j)>0
            hamTest_check_ham(i,j) = hamTest_check_ham(i,j)*checkh(i,j)*prob_ham(1,j);
            hamTest_check_spam(i,j) = hamTest_check_spam(i,j)*checkh(i,j)*prob_spam(1,j);
        end
    end
end

hamTest_check_ham = prod(hamTest_check_ham,2);
hamTest_check_spam = prod(hamTest_check_spam,2);

for i=1:num_spam_test
    for j=1:size(selected_words,2)
        if checks(i,j)>0
            spamTest_check_ham(i,j) = spamTest_check_ham(i,j)*checks(i,j)*prob_ham(1,j);
            spamTest_check_spam(i,j) = spamTest_check_spam(i,j)*checks(i,j)*prob_spam(1,j);
        end
    end
end
spamTest_check_ham = prod(spamTest_check_ham,2);
spamTest_check_spam = prod(spamTest_check_spam,2);

%posterior probability for ham test
hamTest_probH = ProbBayes(hamTest_check_ham,pr_ham,hamTest_check_spam,pr_spam);
hamTest_probS = ProbBayes(hamTest_check_spam,pr_spam, hamTest_check_ham, pr_ham);


%posterior probability for spam test
spamTest_probH = ProbBayes(spamTest_check_ham,pr_ham,spamTest_check_spam,pr_spam);
spamTest_probS = ProbBayes(spamTest_check_spam,pr_spam, spamTest_check_ham, pr_ham);


%Classification
threshold=best/100;
for i=1:num_ham_test
if hamTest_probS(i) > true_threshold/100
        Classification_hamtest(i,1) = 0;
        Classification_hamtest(i,1) = 1;
    else
        Classification_hamtest(i,1) = 1;
        Classification_hamtest(i,1) = 0;
end

end

for i=1:num_spam_test
    if spamTest_probS(i) > true_threshold/100
        Classification_spamtest(i,1) = 0;
        Classification_spamtest(i,1) = 1;
    else
        Classification_spamtest(i,1) = 1;
        Classification_spamtest(i,1) = 0;
    end
end

%efficiency evaluation and error rate
targets=zeros(num_ham_test,1);
[C1, rate1] = confmat(Classification_hamtest, targets);


targets=ones(num_spam_test,1);
[C2, rate2] = confmat(Classification_spamtest, targets);






