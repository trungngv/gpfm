function [f, grad, gradmean] = rMarginal(x, userid, model)
%RMARGINAL [f, grad, gradmean] = rMarginal(x, userid, model)
%   
% The negative log likelihood (per user) and its gradients using a regression model.
% This is a wrapper which redirects the call to different inference
% procedure depending on the covariance functions.
%
% INPUT
%   - x : structure containing all parameters of the user 
%   - userId : the user id
%   - model
%
% OUTPUT
%
% 13/01/14
% Trung V. Nguyen
y = model.T(model.T(:,1)==userid,end);
switch model.kernel
  case 'rbf'
    inf = @rInferenceRbf;
  case 'linearOne'
    inf = @rInferenceLinearOne;
end

if nargout == 1
  if model.useBias
    f = feval(inf, x, y, model.means(userid), [model.dim_item; model.dim_context]);
  else
    f = feval(inf, x, y, model.means(userid));
  end
else
  if model.useBias
    [f, grad, gradmean] = feval(inf, x, y, ...
      model.means(userid), [model.dim_item; model.dim_context]);
  else
    [f, grad, gradmean] = feval(inf, x, y, model.means(userid));
  end
end
end
