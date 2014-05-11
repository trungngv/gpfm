function u = getUserParams(userId, model)
%getUserParams u = getUserParams(userId, model)
%  Gets all parameters associated with the user with given id. 
%  The parameters are latent features of all items and contexts that userId
%  interacted with and the covariance hyper-parameters of the function of
%  the user.
%
% INPUT:
%   - userId : id of the user
%   - model 
%   
% OUTPUT
%   - u : a vector containing all parameters of userId including latent
%   features and hyper-parameters
%
% 08/10/13
% Trung Nguyen

% T(i,:) = [userId, itemId, context1Id, ..., contextMId, rating]
% u = [observed_items'_feature_matrix(:)
%      observed_context1s'_feature_matrix(:)
%      .
%      .
%      observed_contextMs'_feature_matrix(:)]

T = model.T(model.T(:,1) == userId, :);
observedIds = unique(T(:,2));
% features of observed items
u = model.V(observedIds,:);
u = u(:);

% features of observed contexts
nContexts = numel(model.num_context);
for k=1:nContexts
  observedIds = unique(T(:,2+k));
  C = model.C{k}(observedIds,:);
  u = [u; C(:)];
end
u = [u; model.hyp{userId}(:)];
