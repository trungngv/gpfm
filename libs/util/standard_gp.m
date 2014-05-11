function model = standardGP(initModel,X,Y,Xtest,Ytest,zeromean)
%STANDARDGP model = standardGP(initModel,X,Y,Xtest,Ytest,zeromean)
%   Quick wrapper for a standard GP model.
%   No data pre-processing for input is performed by this method. The
%   output is transformed to have zero mean.
%
% INPUT
%   - initModel : init the gp from this init model (empty if not available)
%   - X : input data (N x d)
%   - Y : output data (N x 1)
%   - Xtest : test input data (can be optional or empty)
%   - Ytest : output (for evaluation only; can be optional or empty)
%   - zeromean: whether to zero-mean
%
% OUTPUT: the trained model as a structure with following members
%   - inithyp: initial hyp
%   - hyp: learned hyp
%   - ymean : predictive mean (if Xtest specified)
%   - yvar : predictive variance (if Xtest specified)
%   - nlm : negative log marginal
%   - lp : log predictive probabilities
%
% Trung V. Nguyen
% 14/01/13
% init and train model
model.covfunc = {@covSEard}; %covfunc = {@covSEiso};
model.likfunc = @likGauss;
model.infFunc = @infExact;
if zeromean
  Y0 = Y-mean(Y); % zero-mean the outputs
else
  Y0 = Y;
end

if ~isempty(initModel)
  model.inithyp = initModel.hyp;
else
  model.inithyp = gpml_init_hyp(X,Y,zeromean);
end

[model.hyp, model.nlm] = minimize(model.inithyp,@gp,-200,...
    model.infFunc, [], model.covfunc, model.likfunc, X, Y0);
model.nlm = model.nlm(end);

% prediction
if nargin >= 4
  if ~isempty(Ytest)
    [~,model.yvar,model.fmean,model.fvar,model.lp] = gp(model.hyp,model.infFunc,[],model.covfunc,...
      model.likfunc,X,Y,Xtest,Ytest-mean(Y));
  else
    [~,model.yvar,model.fmean,model.fvar] = gp(model.hyp,model.infFunc,[],model.covfunc,...
      model.likfunc,X,Y,Xtest);
  end
  if zeromean
    model.fmean = model.fmean + mean(Y);
  end  
end
end

