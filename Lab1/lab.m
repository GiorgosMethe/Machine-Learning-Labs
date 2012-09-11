%% Machine Learning: Pattern Recognition
%% Lab 1
%% Paris Mavromoustakos
%% Georgios Methenitis
%% Marios Tzakris

close all;
clear all;
clc

%% Exercise 1

%Loading of the netlab package
addpath('netlab3_3');
load('twoclass.mat');

%Shuffling of the two given classes
A = A(randperm(length(A)),:);
B = B(randperm(length(B)),:);

%Determination of the training set. This training set includes 75% of each Table A
%and B
TrainingSet = [A(1:length(A)*3/4,:); B(1:length(B)*3/4,:)];

%Determination of the test set. This test set includes 25% of each Table A
%and B
TestSet = [A(length(A)*3/4+1:length(A),:) ; B(length(B)*3/4+1:length(B),:)];


%This figure shows the two classes of the training set.
figure();
hold on
plot(A(1:length(A)*3/4,1),A(1:length(A)*3/4,2),'ks');
plot(B(1:length(B)*3/4,1),B(1:length(B)*3/4,2),'ro');
legend('Class A','Class B');
hold off
% title('Training Set')


%This figure depicts the two classes of the test set.
figure();
hold on
plot(A(length(A)*3/4+1:length(A),1),A(length(A)*3/4+1:length(A),2),'ks');
plot(B(length(B)*3/4+1:length(B),1),B(length(B)*3/4+1:length(B),2),'ro');
legend('Class A','Class B');
hold off
% title('Test Set')


%% Exercise 2

%Number of tests (k=1,2,...,kValueMax)
kValueMax = 30;

%Results Array, including results for different K
%First column - Classification Accuracy
%Second column - Classification Error
%Each row - different k-value
ClassificationResults = zeros(kValueMax,2);

%Classification with multiple values for K
for kValue=1:2:kValueMax

ClassificationResults(kValue,:) = KnnFunction(2, 2, kValue, TrainingSet, TestSet);
 
end

%Accuracy rate for different values of K
figure();
bar(ClassificationResults(:,1));
xlabel('K');
ylabel('Accuracy rate %');
% title('Classification Accuracy');

%Error rate for different values of K
figure();
bar(ClassificationResults(:,2));
xlabel('K');
ylabel('Error rate %');
% title('Classification Error');

%% Exercise 3
%10-Fold Cross Validation

% % Shuffling one more time the two classes
% A = A(randperm(length(A)),:);
% B = B(randperm(length(B)),:);

%Determination of each fold in k-fold cross validation process
foldSize = 10;

%Number of tests (k=1,2,...,kValueMax)
kValueMax = 30;

%Results Array, including results for different K
%First column - Classification Accuracy
%Second column - Classification Error
%Each row - different k-value
ClassificationResultsCross = zeros(kValueMax,2);

%Classification with multiple values for K
for kValue = 1:2:kValueMax
    
  %For each K value, we perform cross validation to derive more accurate conclusions
  ClassificationResultsCross(kValue,:) = CrossValidation(A, B, foldSize, kValue);
      
end


%Error rate for different values of K
figure();
bar(ClassificationResultsCross(:,2));
xlabel('K');
ylabel('Error rate %');
% title('Classification Error');


% Arg Min to determine the best value for k
min =100000;
argmin = 0;
for kValue=1:length(ClassificationResultsCross)
    if ClassificationResultsCross(kValue,2) < min
        min = ClassificationResultsCross(kValue,2);
        argmin = kValue;
    end
end
argmin


