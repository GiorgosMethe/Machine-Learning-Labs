function [ ReturnResults ] = CrossValidation( A, B, foldSize, kValue )
%CROSSVALIDATION Summary of this function goes here
%   Detailed explanation goes here


%Generation of the folds, each fold contains half of its elements from
%class A and the other half from class B.
start=0;
for i=1:foldSize
    fold(:,:,i) = [A(start+1:start + length(A)/foldSize,:); B(start+1:start + length(B)/foldSize,:)];
    start = start + length(A)/foldSize;
end

ClassificationResultsCross = zeros(foldSize,2);

%Each iteration of the algorithm use different test and training sets
for iteration=1:foldSize
    
    % We take one fold as the test set and all others as training sets
    TestSetCross = fold(:,:,iteration);
    TrainSetCross = 0;
    
    % Generation of each training set. Each training set includes elements
    % from both classes A,B except from the training set.
    for j=1:foldSize
        if j ~= iteration
            if(TrainSetCross ~= 0)
                TrainSetCross = [TrainSetCross; fold(1:length(fold(:,:,j))/2,:,j)];
            else
                TrainSetCross = fold(1:length(fold(:,:,j))/2,:,j);
            end
        end
    end

    for j=1:foldSize
        if j ~= iteration
            TrainSetCross = [TrainSetCross; fold(length(fold(:,:,j))/2+1:length(fold(:,:,j)),:,j)];
        end
    end

    ClassificationResultsCross(iteration,:) = KnnFunction(2, 2, kValue, TrainSetCross, TestSetCross);
   
end


% Now we have to compute the averaged error and accuracy rate for each combination
% of training and test set over the iterations of the algorithm
SumError = 0;
SumAcc = 0;
for iteration = 1:foldSize
    
    SumError = SumError + ClassificationResultsCross(iteration,2);
    SumAcc = SumAcc + ClassificationResultsCross(iteration,1);
    
end
Error = SumError/foldSize;
Accuracy = SumAcc/foldSize;

%for each value of k we return an average result over the iterations of the
%algorithm
ReturnResults(1) = Accuracy;
ReturnResults(2) = Error;

end

