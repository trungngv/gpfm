function f = computeObjective(model)
%COMPUTEOBJECTIVE f = computeObjective(model)
%  Compute the total objective value
% 
% 16/10/13
% Trung Nguyen
f = 0;
for userId = 1:model.num_users
  if ~any(model.T(:,1) == userId),    continue,   end;
  u = getUserParams(userId, model);
  fu = nLogLikelihood(u, userId, model);
  f = f + fu;
end
