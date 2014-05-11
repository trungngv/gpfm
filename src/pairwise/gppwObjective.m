function obj = gppwObjective(model)
%GPPPWOBJECTIVE obj = gppwObjective(model)
%  Compute the total objective (negative log marginal) value for the
%  current pairwise regression model.
% 
% 14/01/14
% Trung Nguyen
obj = 0;
for userId = 1:model.num_users
  if ~any(model.pairT(:,1) == userId),    continue,   end;
  obj = obj + gppwInf(model, userId);
end
