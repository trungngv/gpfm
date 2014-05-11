function model = gppwUpdate(grad, gradMean, userid, model, opt)
%GPPWUPDATE model = gppwUpdate(grad, gradMean, userid, model, opt)
%   Update the latent parameters of the user with given userid in a pairwise
%   preference model. This method is called for a single SGD update.
%
% INPUT
%   - grad : structure containing gradients of the Xpairs of a user
%   - gradMean : gradient of the const mean 
%   - userid: the user id
%   - model: the model
%   - opt : optimization options
% OUTPUT
%   - the updated model
%
% 21/01/14
% Trung V. Nguyen

model.deltaMean(userid) = opt.momentum * model.deltaMean(userid) - opt.learnRate * gradMean;
model.means(userid) = model.means(userid) + model.deltaMean(userid);

nContexts = numel(model.num_context);
if model.useBias
  Grad = unwrap(grad.Xplus,grad.Xplus_bias,model);
else
  Grad = unwrap(grad.Xplus,[],model);
end  
T = model.pairT(model.pairT(:,1) == userid, 2:2+nContexts);
% update item latent features (due to Xplus)
cgV = collapse(Grad.V,T(:,1));
uniqueids = unique(T(:,1));
model.deltaV(uniqueids,:) = opt.momentum * model.deltaV(uniqueids,:) - opt.learnRate * cgV;
model.V(uniqueids,:) = model.V(uniqueids,:) + model.deltaV(uniqueids,:);

% update context latent features (due to Xplus)
for k=1:nContexts
  cgC = collapse(Grad.C{k},T(:,1+k));
  uniqueids = unique(T(:,1+k));
  model.deltaC{k}(uniqueids,:) = opt.momentum * model.deltaC{k}(uniqueids,:) - opt.learnRate * cgC;
  model.C{k}(uniqueids,:) = model.C{k}(uniqueids,:) + model.deltaC{k}(uniqueids,:);
end

T = model.pairT(model.pairT(:,1) == userid, 3+nContexts:end-1);
if model.useBias
  Grad = unwrap(grad.Xminus,grad.Xminus_bias,model);
else
  Grad = unwrap(grad.Xminus,[],model);
end
% update item latent features (due to Xminus)
cgV = collapse(Grad.V,T(:,1));
uniqueids = unique(T(:,1));
model.deltaV(uniqueids,:) = opt.momentum * model.deltaV(uniqueids,:) - opt.learnRate * cgV;
model.V(uniqueids,:) = model.V(uniqueids,:) + model.deltaV(uniqueids,:);

% update context latent features (due to Xminus)
for k=1:nContexts
  cgC = collapse(Grad.C{k},T(:,1+k));
  uniqueids = unique(T(:,1+k));
  model.deltaC{k}(uniqueids,:) = opt.momentum * model.deltaC{k}(uniqueids,:) - opt.learnRate * cgC;
  model.C{k}(uniqueids,:) = model.C{k}(uniqueids,:) + model.deltaC{k}(uniqueids,:);
end

% update covariance hyperparameters
model.deltaHyp{userid} = opt.momentum * model.deltaHyp{userid} - opt.learnRate * grad.hyp;
model.hyp{userid} = model.hyp{userid} + model.deltaHyp{userid};
end

% collapse gX such that all items and contexts appearing in multiple
% observations are collected into one
function R = collapse(gX,indice)
  indiceSet = unique(indice);
  R = zeros(numel(indiceSet), size(gX,2));
  for i = 1:numel(indiceSet)
    R(i,:) = sum(gX(indice == indiceSet(i)));
  end
end

% unwrap X to V,C, and hyp
% X = [V,C_1,...,C_K]
function R = unwrap(X,X_bias,model)
  if model.useBias
    [~,S] = fromLatentAndBias(X,X_bias,[model.dim_item;model.dim_context]);
  else
    S = X;
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

