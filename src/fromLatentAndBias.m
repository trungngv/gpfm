function [x,X] = fromLatentAndBias(Xlatent, Xbias, dim)
% convert Xlatent and Xbias back to X and returns X(:)
  dimItem = dim(1); dimContext = dim(2:end);
  X = zeros(size(Xlatent,1),dimItem + sum(dimContext));
  nContexts = numel(dimContext);
  biasColumns = zeros(2 + nContexts,1);
  biasColumns(1) = 1;
  biasColumns(end) = size(X,2) + 1;
  lastPos = dimItem;
  for k=1:nContexts
    biasColumns(1+k) = lastPos + 1;
    lastPos = lastPos + dimContext(k);
  end
  X(:,biasColumns(1:end-1)) = Xbias;
  X(:,2:2+dimItem-2) = Xlatent(:,1:dimItem-1);
  latentPos = dimItem;
  for k=1:nContexts
    X(:,biasColumns(k+1)+1:biasColumns(k+2)-1) = Xlatent(:,latentPos:latentPos+dimContext(k)-2);
    latentPos = latentPos + dimContext(k) - 1;
  end
  x = X(:);
end