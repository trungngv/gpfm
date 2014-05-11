function newpairs = gppwSamplePairs(model,nsamples,type,varargin)
%GPPWSAMPLEPAIRS newpairs = gppwSamplePairs(model,nsamples,type)
%   Sample new pairs for the current pairwise preference model.
% 
% INPUT
%   - model: current pairwise model
%   - nsamples: how many pairs to add
%   - type: 'itemError', 'itemUncertainty', 'pairUncertainty'
%   - varargin : predictive variance of all training pairs if type is 'pairUncertainty'
% 
% Trung Nguyen 
% 22/01/14

switch type
  % active sampling using item
case {'itemError','itemUncertainty'}
  relevantInd = model.T(:,end)==1;
  relevantT = model.T(relevantInd,:);
  [~,fpred,fvar] = rPredictAll(model,relevantT);
  if strcmp(type,'itemError')
    % this corresponds to max error because all relevant has f = 1
    [~,sortedInd] = sort(fpred,'ascend');
    fprintf('min relevant: %f\n', fpred(sortedInd(1)));
  else
    [~,sortedInd] = sort(fvar,'descend');
    fprintf('max variance: %f\n', fvar(sortedInd(1)));
  end
  newpairs = sampleForItems(model,relevantT(sortedInd(1:nsamples),:));
case {'pairError','pairUncertainty'}
  pmean = varargin{1};
  pvar = varargin{2};
  if strcmp(type, 'pairError')
    [dummy,sortedInd] = sort(abs(model.pairT(:,end)-pmean), 'descend');
    fprintf('max error : %f\n', dummy(1));
  else
    [~,sortedInd] = sort(pvar,'descend');
    fprintf('max variance: %f\n', pvar(sortedInd(1)));
  end
  newpairs = zeros(2*nsamples,size(model.pairT,2));
  nContexts = numel(model.num_context);
  maxIds = max(model.T(:,2));
  for i=1:nsamples
    thepair = model.pairT(sortedInd(i),:);
    % relevant = [itemid,context]
    if thepair(end) == 2
      relevant = thepair(2:2+nContexts);
    else
      relevant = thepair(3+nContexts:end-1);
    end
    context = relevant(2:end);
    % sampled irrelevant for this user | context
    irrelevant_ids = setdiff(1:maxIds,relevant(1));
%       irrelevant = model.T(model.T(:,1)==thepair(1) & model.T(:,end)==-1,:);
%       irrelevant = irrelevant(findRows(irrelevant(:,3:end-1),uniqueContext),:);
%       irrelevant_ids = irrelevant(:,2); % irrelevant items
    irrelevant_id = irrelevant_ids(ceil(rand*numel(irrelevant_ids)));
    newpairs(i,:) = [thepair(1),relevant,irrelevant_id,context,2];
    newpairs(nsamples+i,:) = [thepair(1),irrelevant_id,context,relevant,-2];
  end
end

end

% Sample a pair for each of the relevant observation in relevantT
function newpairs = sampleForItems(model,relevantT)
nsamples = size(relevantT,1);
newpairs = zeros(2*nsamples,size(model.pairT,2));
maxIds = max(model.T(:,2));
for i=1:nsamples
  % relevant = [userid,itemid,context]
  relevant = relevantT(i,1:end-1);
  context = relevant(3:end);
  % sampled irrelevant of this user | context
  if maxIds < 100
    % relevant for this user
    urelevant = model.T(model.T(:,1)==relevant(1) & model.T(:,end)==1,:);
    relevant_ids = urelevant(findRows(urelevant(:,3:end-1),context),2);
    irrelevant_ids = setdiff(1:maxIds,relevant_ids);
  else
    % this saves computation although there is very small chance of
    % pairing this with another relevant item
    irrelevant_ids = setdiff(1:maxIds,relevant(2));
  end
  %irrelevant = model.T(model.T(:,1)==relevant(1) & model.T(:,end)==-1,:);
  %irrelevant = irrelevant(findRows(irrelevant(:,3:end-1),context),:);
  %irrelevant_ids = irrelevant(:,2); % irrelevant items
  
  % randomly sample 100 irrelevant items and select the one with highest rating
%   ns = min(100,numel(irrelevant_ids));
%   randItems = irrelevant_ids(randperm(numel(irrelevant_ids),ns));
%   randIrrelevant = [repmat(relevant(1),ns,1),randItems(:),repmat(context,ns,1),repmat(-1,ns,1)];
%   [~, predict] = rPredictAll(model,randIrrelevant);
%   [~,max_id] = max(predict);
%   irrelevant_id = randItems(max_id);

  irrelevant_id = irrelevant_ids(ceil(rand*numel(irrelevant_ids)));
  newpairs(i,:) = [relevant,irrelevant_id,context,2];
  newpairs(nsamples+i,:) = [relevant(1),irrelevant_id,context,relevant(2:end),-2];
end
end

