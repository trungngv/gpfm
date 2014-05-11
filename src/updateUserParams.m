function model = updateUserParams(userId, u, model)
%UPDATEUSERPARAMS model = updateUserParams(userId, u, model)
%
%  Update the model to synchronize the parameters of userId with the new
%  parameters u.
%  
% INPUT
%   - userId : id of the user
%   - u : new parameter values of the user
%   - model
% 
% OUTPUT
%   - the updated model
% 
% 09/10/13
% Trung Nguyen
T = model.T(model.T(:,1) == userId, :);

% update for items
itemIds = unique(T(:,2));
nItems = numel(itemIds);
V = reshape(u(1:nItems*model.dim_item), nItems, []);
model.V(itemIds,:) = V;
offset = numel(V) + 1;

% update for contexts
nContexts = numel(model.num_context);
for k=1:nContexts
  observedIds = unique(T(:,2+k));
  nrows = numel(observedIds);
  nElements = nrows * model.dim_context(k);
  model.C{k}(observedIds,:) = reshape(...
      u(offset:offset + nElements - 1), nrows, []);
  offset = offset + nElements;
end

% update hyper-parameters
model.hyp{userId} = u(offset:end);

