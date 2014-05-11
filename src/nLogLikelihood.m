function [f, grad, gradbias] = nLogLikelihood(u, userId, model)
%NLOGLIKELIHOOD [f, grad, gradbias] = nLogLikelihood(u, userId, model)
%   
% The negative log likelihood (per user) and its gradients.
%
% INPUT
%   - u : vector of all parameters of the user
%   - userId : the user id
%   - model
%
% OUTPUT
%
% 06/11/13
% Trung Nguyen
y = model.T(model.T(:,1)==userId,end);
[X, hyp] = unwrapUserParams(u, userId, model);
x = wrapToVec(X, hyp);
if nargout == 1
  if model.useBias
    f = feval(model.gpObjective, x, y, model.means(userId), [model.dim_item; model.dim_context]);
  else
    f = feval(model.gpObjective, x, y, model.means(userId));
  end
else
  if model.useBias
    [f, gradx, gradbias] = feval(model.gpObjective, x, y, ...
      model.means(userId), [model.dim_item; model.dim_context]);
  else
    [f, gradx, gradbias] = feval(model.gpObjective, x, y, model.means(userId));
  end
  
  % convert gradx to grad
  grad = zeros(size(u));
  for i=1:numel(u)-3
    grad(i) = sum(gradx(model.map{userId} == i));
  end
  % hyperparameters
  grad(end-2:end) = gradx(end-2:end);
end
end
