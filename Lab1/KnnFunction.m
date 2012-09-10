function [ ClassificationResults ] = KnnFunction( nin,nout,k,TrainingSet, TestSet )

%Determination of the training target data
Target = zeros(length(TrainingSet),2);
Target(1:length(Target)/2,1) = 1;
Target(length(Target)/2+1:length(Target),2) = 1;

%Generation of the knn model
KnnModel = knn(nin,nout,k,TrainingSet,Target);

%Classification results
Classification = knnfwd(KnnModel,TestSet);

%Generation of the target set
TargetTest = zeros(length(TestSet),2);
TargetTest(1:length(TargetTest)/2,1) = 1;
TargetTest(length(TargetTest)/2+1:length(TargetTest),2) = 1;

%Classification results
ClassificationRes = confmat(Classification,TargetTest);

%Classification Accuracy
ClassificationAcc = 0;
for i=1:length(ClassificationRes)
    ClassificationAcc = ClassificationAcc + ClassificationRes(i,i);
end
ClassificationAcc = ClassificationAcc/length(TestSet);

ClassificationResults(1) = ClassificationAcc * 100;

%Classification Error
ClassificationError = 1 - ClassificationAcc;
ClassificationResults(2) = ClassificationError * 100;

end

