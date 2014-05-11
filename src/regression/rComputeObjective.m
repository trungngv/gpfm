function f = rComputeObjective(model)
%RCOMPUTEOBJECTIVE f = rComputeObjective(model)
%  Compute the total objective value (negative log marginal) of a regression model.
% 
% 14/01/14
% Trung Nguyen
f = 0;
for userId = 1:model.num_users
  if ~any(model.T(:,1) == userId),    continue,   end;
  X = getX(model, userId);
  f = f + rMarginal(X, userId, model);
end
