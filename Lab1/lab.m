close all;
clear all;
clc
addpath('netlab3_3');
load('twoclass.mat');
A(randperm(length(A)));
B(randperm(length(B)));

%Determination of the training set. This training set includes 75% of each Table A
%and B
TrainingSet = [A(1:length(A)*3/4,:); B(1:length(B)*3/4,:)];


%This figure depicts the two classes of the training set.
figure();
hold on
plot(A(1:length(A)*3/4,1),A(1:length(A)*3/4,2),'ks');
plot(B(1:length(B)*3/4,1),B(1:length(B)*3/4,2),'ro');
legend('Class A','Class B');
hold off
title('Training Set')

%Determination of the test set. This test set includes 25% of each Table A
%and B
TestSet = [A(length(A)*3/4+1:length(A),:) ; B(length(B)*3/4+1:length(B),:)];


%This figure depicts the two classes of the test set.
figure();
hold on
plot(A(length(A)*3/4+1:length(A),1),A(length(A)*3/4+1:length(A),2),'ks');
plot(B(length(B)*3/4+1:length(B),1),B(length(B)*3/4+1:length(B),2),'ro');
legend('Class A','Class B');
hold off
title('Test Set')

%Determination of the training target data
Target = zeros(1500,2);
Target(1:length(Target)/2,1) = 1;
Target(length(Target)/2+1:length(Target),2) = 1;

%Test Array, including different values for K
ClassificationResults = zeros(30,2);

for test=1:30
    
    %Genaration of the knn model
    KnnModel = knn(2,2,test,TrainingSet,Target);
    
    %Classification results
    Classification = knnfwd(KnnModel,TestSet);
    
    
    Target1 = zeros(500,2);
    Target1(1:length(Target1)/2,1) = 1;
    Target1(length(Target1)/2+1:length(Target1),2) = 1;
    
    %Classification results
    ClassificationRes = confmat(Classification,Target1);
    
    %Classification Accuracy
    i=1;
    ClassificationAcc = 0;
    for i=1:length(ClassificationRes)
        ClassificationAcc = ClassificationAcc + ClassificationRes(i,i);
    end
    ClassificationAcc = ClassificationAcc/length(TestSet);
    
    ClassificationResults(test,1) = ClassificationAcc * 100;
    
    %Classification Error
    ClassificationError = 1 - ClassificationAcc;
    ClassificationResults(test,2) = ClassificationError * 100;
    
    
end


figure();
bar(ClassificationResults(:,1));
axis([0 31 80 90])
xlabel('K');
ylabel('Accuracy rate %');
title('Classification Accuracy');


figure();
bar(ClassificationResults(:,2));
axis([0 31 12 18])
xlabel('K');
ylabel('Error rate %');
title('Classification Error');


% 10-Fold Cross Validation

% Shuffle the two Arrays
AShuffled = A(randperm(length(A)),:);
BShuffled = B(randperm(length(B)),:);


% Generation of the 10 folds
start=0;
for i=1:10
    fold(:,:,i) = [AShuffled(start+1:start + length(AShuffled)/10,:); BShuffled(start+1:start + length(BShuffled)/10,:)];
    start = start + length(AShuffled)/10;
end



for k=1:30
    for iteration=1:10
        
        % We take one fold as the test set and all others as training sets
        TestSetCross = fold(:,:,iteration);
        TrainSetCross = 0;
        
        % Generation of each training set. Each training set includes elements
        % from both classes A,B except from the training set.
        for j=1:10
            if j ~= iteration
                if(TrainSetCross ~= 0)
                    TrainSetCross = [TrainSetCross; fold(1:100,:,j)];
                else
                    TrainSetCross = fold(1:100,:,j);
                end
            end
        end
        for j=1:10
            if j ~= iteration
                TrainSetCross = [TrainSetCross; fold(101:200,:,j)];
            end
        end
        
        
        % Now we have to compute the averaged error rate for each combination
        % of training and test set over the different k-parameter of the
        % algorithm
        
        
        TargetCross = zeros(((10-1)*length(A)+(10-1)*length(B))/10,2);
        TargetCross(1:length(TargetCross)/2,1) = 1;
        TargetCross(length(TargetCross)/2+1:length(TargetCross),2) = 1;
        
        %Genaration of the knn model
        KnnModelCross = knn(2,2,k,TrainSetCross,TargetCross);
        
        %Classification results
        ClassificationCross = knnfwd(KnnModelCross,TestSetCross);
        
        TargetCross1 = zeros(200,2);
        TargetCross1(1:length(TargetCross1)/2,1) = 1;
        TargetCross1(length(TargetCross1)/2+1:length(TargetCross1),2) = 1;
        
        %Classification results
        ClassificationResCross(:,:,iteration,k) = confmat(ClassificationCross,TargetCross1);
        
        
        %Classification Accuracy
        ClassificationAccCross = 0;
        for i=1:length(ClassificationResCross(:,:,iteration,k))
            ClassificationAccCross = ClassificationAccCross + ClassificationResCross(i,i,iteration,k);
        end
        ClassificationAccCross = ClassificationAccCross/length(TestSetCross);
        
        ClassificationResultsCross(iteration,k,1) = ClassificationAccCross * 100;
        
        %Classification Error
        ClassificationErrorCross = 1 - ClassificationAccCross;
        ClassificationResultsCross(iteration,k,2) = ClassificationErrorCross * 100;
        
        
    end
    
    
end



for k=1:30
    SumError = 0;
    SumAcc = 0;
    for iteration = 1:10
        
        SumError = SumError + ClassificationResultsCross(iteration,k,2);
        SumAcc = SumAcc + ClassificationResultsCross(iteration,k,1);
        
    end
    Error(k) = SumError/10;
    Accuracy(k) = SumAcc/10;
end


figure();
bar(Error);
axis([0 31 10 18])
xlabel('K');
ylabel('Error rate %');
title('Classification Error');


% Arg Min
min =100000;
index = 0;
for k=1:30
    if Error(k) < min
        min = Error(k);
        index = k;
    end
end
index


