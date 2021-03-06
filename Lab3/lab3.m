clc
clear all
close all

load('banana.mat');
% load('spiral.mat');

%Determination of the training set. This training set includes 75% of each Table A and B
TrainingSetA = A(1:length(A)*3/4,:);
TrainingSetB = B(1:length(B)*3/4,:);

%Determination of the test set. This test set includes 25% of each Table A and B
TestSet = [ A(length(A)*3/4+1:length(A),:) ; B(length(B)*3/4+1:length(B),:) ];
TrainingSet = [ TrainingSetA ; TrainingSetB ];

%This figure depicts the two classes of the training set.
figure();
hold on
plot(A(1:length(A)*3/4,1),A(1:length(A)*3/4,2),'ks');
plot(B(1:length(B)*3/4,1),B(1:length(B)*3/4,2),'ro');
legend('Class A','Class B');
hold off
title('Training Set')

%% --------------EXCERCISE1-------------

%Prior Probabilities
pr_classA = size(A,1)/(size(A,1)+size(B,1));
pr_classB = size(B,1)/(size(A,1)+size(B,1)) ;


%means covariance matrix
sumAx=0;
sumAy=0;
sumBx=0;
sumBy=0;
for i=1:size(TrainingSetA,1)
   sumAx = sumAx + TrainingSetA(i,1);
   sumAy = sumAy + TrainingSetA(i,2);
   sumBx = sumBx + TrainingSetB(i,1);
   sumBy = sumBy + TrainingSetB(i,2);
end
meanA = [sumAx sumAy]/size(TrainingSetA,1);
meanB = [sumBx sumBy]/size(TrainingSetA,1);

%covariance matrix
covA = cov(TrainingSetA);
covB = cov(TrainingSetB);
 
%Probability of the test dataset to 
%belong in class A or class B
pA = mvnpdf(TestSet,meanA,covA);
pB = mvnpdf(TestSet,meanB,covB);


PostA = (pA .* pr_classA) ./ (pA .* pr_classA + pB .* pr_classB);
PostB = (pB .* pr_classB) ./ (pA .* pr_classA + pB .* pr_classB);

%classification1
classification=zeros(size(TestSet));
for i=1:size(TestSet,1)
   
    if PostA(i) > PostB(i)
        classification(i,1)=1;
        classification(i,2)=0;
    else
        classification(i,1)=0;
        classification(i,2)=1;
    end
end
 
%efficiency evaluation and error rate
labels=[[ones(length(TestSet)*1/2,1) zeros(length(TestSet)*1/2,1)]; [zeros(length(TestSet)*1/2,1) ones(length(TestSet)*1/2,1) ]];
[C, rate] = confmat(classification, labels);
accuracy=rate(1,2)/length(TestSet);
error_rate=1-accuracy;


%% ------------EXERCISE2-------------
%EM algorithm
num_ellipse=2;
tic
%figure();
[loglA mogA] = em_mog(TrainingSetA,num_ellipse,1);
%figure();
[loglB mogB] = em_mog(TrainingSetB,num_ellipse,1);
toc
%Posterior Probability
sumA=0;
sumB=0;
for i=1:num_ellipse 
pA = mogA{i}.PI * mvnpdf(TestSet,mogA{i}.MU,mogA{i}.SIGMA);
pB = mogB{i}.PI * mvnpdf(TestSet,mogB{i}.MU,mogB{i}.SIGMA);
sumB = sumB + pB;
sumA = sumA + pA;
end

%classification2
classification2=zeros(size(TestSet));
for i=1:size(TestSet,1)
   
    if sumA(i) > sumB(i)
        classification2(i,1)=1;
        classification2(i,2)=0;
    else
        classification2(i,1)=0;
        classification2(i,2)=1;
    end
end

%efficiency evaluation and error rate
labels2=[[ones(length(TestSet)*1/2,1) zeros(length(TestSet)*1/2,1)]; [zeros(length(TestSet)*1/2,1) ones(length(TestSet)*1/2,1) ]];
[C2, rate2] = confmat(classification2, labels);
accuracy2=rate2(1,2)/length(TestSet);
error_rate2=1-accuracy2;


%------------EXERCISE3-------------

% ln[p(a) + p(b)] when ln p(a) = -1000 and ln p(b) = -1001 computation.
y = [-1000 -1001];
check = logsumexp (y);

tic
%EM algorithm with log probabilities
%figure();
[loglA mogA] = em_mog_ex3(TrainingSetA,num_ellipse,1);
%figure();
[loglB mogB] = em_mog_ex3(TrainingSetB,num_ellipse,1);
toc
%Posterior Probability
sumA=0;
sumB=0;
for i=1:num_ellipse 
    PA = mogA{i}.PI*mvnpdf(TestSet,mogA{i}.MU,mogA{i}.SIGMA);
    sumA = sumA + PA;
    PB = mogB{i}.PI*mvnpdf(TestSet,mogB{i}.MU,mogB{i}.SIGMA);
    sumB = sumB + PB;
end

%classification3
classification3=zeros(size(TestSet));
for i=1:size(TestSet,1)
   
    if sumA(i) > sumB(i)
        classification3(i,1)=1;
        classification3(i,2)=0;
    else
        classification3(i,1)=0;
        classification3(i,2)=1;
    end
end

%efficiency evaluation and error rate
labels3=[[ones(length(TestSet)*1/2,1) zeros(length(TestSet)*1/2,1)]; [zeros(length(TestSet)*1/2,1) ones(length(TestSet)*1/2,1) ]];
[C3, rate3] = confmat(classification3, labels3);
accuracy3=rate3(1,2)/length(TestSet);
error_rate3=1-accuracy3;


BANANATIME = [0 0.07 0.18 0.42 0.62 0.5 1.97 1.14 2.13 1.48;
              0 0.06 0.15 0.36 0.59 0.42 1.92 1.12 2.09 1.37];

SPIRALTIME = [0 0.08 0.17 0.15 0.28 0.37 0.45 0.53 0.69 0.85;
    0 0.07 0.16 0.14 0.29 0.34 0.41 0.53 0.63 0.78];


figure;
bar(BANANATIME','grouped');
axis([1.5 10.5 0 2.5])
legend('Normal approach','Ln-probabilities');
xlabel('Number of Components')
ylabel('Execution Time (Sec)')
figure;
bar(SPIRALTIME','grouped')
axis([1.5 10.5 0 1])
legend('Normal approach','Ln-probabilities');
xlabel('Number of Components')
ylabel('Execution Time (Sec)')

