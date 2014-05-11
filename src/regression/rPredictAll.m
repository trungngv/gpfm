function [errors, fpred, fvar] = rPredictAll(model,testT)
%RPREDICTALL  [errors, fpred] = rPredictAll(model)
%   Prediction for a model (test set is given by model.testT)
%
% INPUT
%   - model: a trained model
%   - testT: the test set (if empty model.testT is used)
% OUTPUT
%   - errors: [mae, rmse, const_mae, const_rmse] where const is by the
%       constant predictor which predicts using the mean rating of each user
%   - fpred : the predicted values corresponding to testT
if isempty(testT)
  testT = model.testT;
end
testUserIds = unique(testT(:,1));
constErrors = [];
fpred = zeros(size(testT,1),1);
fvar = fpred;
for i=1:numel(testUserIds)
  userId = testUserIds(i);
  if ~any(model.T(:,1) == userId),    continue;  end
  trainInd = model.T(:,1) == userId;
  testInd = testT(:,1) == userId;
  [fpred(testInd), fvar(testInd)] = predict(userId, model, testT);
  ymean = mean(model.T(trainInd, end));
  constErrors = [constErrors; abs(ymean - testT(testInd, end))];
end
errors = [mean(abs(fpred - testT(:,end))), sqrt(mean((fpred-testT(:,end)).^2)),...
  mean(constErrors), sqrt(mean(constErrors.^2))];
  