function [train,test] = loadFold(dataset, k)
%GETFOLD [A,B] = loadFold(dataset, k)
%
train = load(['data/' dataset '/' dataset '-5folds/fold' num2str(k) '-train.csv']);
test = load(['data/' dataset '/' dataset '-5folds/fold' num2str(k) '-test.aug.csv']);
%test = load(['data/' dataset '/' dataset '-5folds/fold' num2str(k) '-test.csv']);
end

