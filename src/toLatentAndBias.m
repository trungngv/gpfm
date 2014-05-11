function [Xlatent,Xbias] = toLatentAndBias(X, dim)
% convert X to Xlatent and Xbias
% X = [item_bias(:),item_features,context1_bias(:),context1_features,...]
  dimItem = dim(1); dimContext = dim(2:end);
  nContexts = numel(dimContext);
  biasColumns = zeros(1 + nContexts,1);
  biasColumns(1) = 1;
  lastPos = dimItem;
  for k=1:nContexts
    biasColumns(1+k) = lastPos + 1;
    lastPos = lastPos + dimContext(k);
  end
  Xbias = X(:,biasColumns);
  Xlatent = X;
  Xlatent(:, biasColumns) = [];
end