function model = sgdUpdateUser(gradX, gradMean, userid, model, opt)
%SGDUPDATEUSER model = sgdUpdateUser(gradX, gradMean, userid, model, opt)
%   Update the latent parameters of the user with given userid. This is
%   called for a single SGD update.
%
% INPUT
%   - gradX : structure containing gradients corresponding to getX()
%   - gradMean : gradient of the const mean 
%   - userid: the user id
%   - model: the model
%   - opt : optimization options
% OUTPUT
%   - the updated model
%
% 16/01/14
% Trung V. Nguyen
model.deltaMean(userid) = opt.momentum * model.deltaMean(userid) - opt.learnRate * gradMean;
model.means(userid) = model.means(userid) + model.deltaMean(userid);

Grad = unwrap(gradX,model);
% update item latent features
T = model.T(model.T(:,1) == userid, :);
cgV = collapse(Grad.V,T(:,2));
uniqueids = unique(T(:,2));
model.deltaV(uniqueids,:) = opt.momentum * model.deltaV(uniqueids,:) - opt.learnRate * cgV;
model.V(uniqueids,:) = model.V(uniqueids,:) + model.deltaV(uniqueids,:);

% update context latent features
nContexts = numel(model.num_context);
for k=1:nContexts
  cgC = collapse(Grad.C{k},T(:,2+k));
  uniqueids = unique(T(:,2+k));
  model.deltaC{k}(uniqueids,:) = opt.momentum * model.deltaC{k}(uniqueids,:) - opt.learnRate * cgC;
  model.C{k}(uniqueids,:) = model.C{k}(uniqueids,:) + model.deltaC{k}(uniqueids,:);
end

% update covariance hyperparameters
model.deltaHyp{userid} = opt.momentum * model.deltaHyp{userid} - opt.learnRate * Grad.hyp;
model.hyp{userid} = model.hyp{userid} + model.deltaHyp{userid};
end

% collapse gX such that all items and contexts appearing in multiple
% observations are collected into one
function R = collapse(gX,indice)
  indiceSet = unique(indice);
  R = zeros(numel(indiceSet), size(gX,2));
  for i = 1:numel(indiceSet)
    R(i,:) = sum(gX(indice == indiceSet(i),:),1);
  end
end

% unwrap X to V,C, and hyp
% X.latent = [V,C_1,...,C_K]
function R = unwrap(X,model)
  R.hyp = X.hyp;
  if model.useBias
    [~,S] = fromLatentAndBias(X.latent,X.bias,[model.dim_item;model.dim_context]);
  else
    S = X.latent;
  end
  R.V = S(:,1:size(model.V,2));
  offset = size(model.V,2);
  nContexts = numel(model.num_context);
  R.C = cell(nContexts,1);
  for i=1:nContexts
    R.C{i} = S(:,offset+1:offset+size(model.C{i},2));
    offset = offset+size(model.C{i},2);
  end
end    

