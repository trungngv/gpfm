function [X, index] = userParamsToMatrix(u, userId, model)
%USERPARAMSTOMATRIX  [X, index] = userParamsToMatrix(u, userId, model)
%
%  Convert the param vector (u) used in the optimization procedure to the
%  input matrix. Specifically, u is the set of all unique parameters to the
%  function f_i of the user with userId = i. The resulting matrix X is the
%  design matrix of the user.
%
% 09/10/13
% Trung Nguyen

% u = [observed_items'_feature_matrix(:)
%      observed_context1s'_feature_matrix(:)
%      .
%      .
%      observed_contextMs'_feature_matrix(:)]

rows = find(model.T(:,1) == userId);
T = model.T(rows, :);
% starting position of each matrix: 1 for items and M for contexts
nContexts = numel(model.num_context);
offsets = zeros(nContexts+1,1);
offsets(1) = 1;
itemIds = unique(T(:,2));
nItems = numel(itemIds);
% feature matrix of the observed items
V = reshape(u(1:nItems*model.dim_item), nItems, []);

% feature matrices of the observed contexts
C = cell(nContexts,1);
offsets(2) = nItems*model.dim_item + 1;
contextIds = cell(nContexts,1);
for k=1:nContexts
  contextIds{k} = unique(T(:,2+k));
  nrows = numel(contextIds{k});
  C{k} = reshape(u(offsets(k+1):offsets(k+1)+nrows*model.dim_context(k)-1),...
      nrows, []);
  if k < nContexts
    offsets(k+2) = offsets(k+1) + nrows*model.dim_context(k);
  end
end

% dimension of the feature vectors
dimX = model.dim_item + sum(model.dim_context);
X = zeros(numel(rows), dimX);
index = zeros(numel(X),1);
for i = 1:numel(rows)
  % [item_features, context1_features, ..., contextM_features]
  idx = find(itemIds == T(i,2));
  features = V(idx,:);
  uIndice = (offsets(1) - 1) + rowInd(size(V), idx);
  for k=1:nContexts
    idx = find(contextIds{k} == T(i,2+k));
    features = [features, C{k}(idx,:)];
    uIndice = [uIndice, (offsets(k+1) - 1) + rowInd(size(C{k}),idx)];
  end
  X(i,:) = features;
  index(rowInd(size(X),i)) = uIndice;
end
end

