function [fmean, fvar] = predict(userId, model, testObservations)
%PREDICT predict(userId, model, testObservations)
% 
% Predict using the learned model.
% 
% INPUT
%   - userId : id of the user to make prediction
%   - model : the learned model
%   - testObservations : same format as model.T
%
% OUTPUT
% 06/11/13
[X, y] = getUserData(userId, model);
[Xtest, ytest] = getUserData(userId, model, testObservations);
if model.useBias
  [X, ~] = toLatentAndBias(X, [model.dim_item; model.dim_context]);
  [Xtest, XtestBias] = toLatentAndBias(Xtest, [model.dim_item; model.dim_context]);
end
switch model.kernel
  case 'rbf'
    hyp.cov = model.hyp{userId}(1:end-1);
    hyp.lik = model.hyp{userId}(end);
    hyp.mean = model.means(userId);
    [~,~, fmean, fvar] = gp(hyp, @infExact, @meanConst, @covSEiso, ...
        @likGauss, X, y, Xtest);
  case 'linear'
    hyp.mean = model.means(userId);
    hyp.lik = model.hyp{userId}(end);
    [~,~, fmean, fvar] = gp(hyp, @infExact, @meanConst, @covLIN, ...
       @likGauss, X, y, Xtest);
  case 'linearOne'
    hyp.cov = model.hyp{userId}(1);
    hyp.mean = model.means(userId);
    hyp.lik = model.hyp{userId}(end);
    [~,~, fmean, fvar] = gp(hyp, @infExact, @meanConst, @covLINone, ...
        @likGauss, X, y, Xtest);
end

% add bias term from context and item to predicted value
if model.useBias
  fmean = fmean + sum(XtestBias,2);
end

