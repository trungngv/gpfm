function X = getX(model, userid)
%GETX  X = getX(model, userid)
%   Returns the structure containing parameters of the user with given userid.
% 
% INPUT
%   - model : a model
%   - userid : id of the user
%
% OUTPUT
%   X.latent = [item_feature_matrix,context1_feature_matrix,...,contextK_feature_matrix]
%   X.hyp = covariance hyperparameter of userid
%
% 13/01/14
% Trung Nguyen
T = model.T(model.T(:,1) == userid, :);
latent = model.V(T(:,2),:); % item
% features of observed contexts
nContexts = numel(model.num_context);
for k=1:nContexts
  latent = [latent, model.C{k}(T(:,2+k),:)];
end
X.latent = latent;
X.hyp = model.hyp{userid};
end

