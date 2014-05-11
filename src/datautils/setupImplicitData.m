function setupImplicitData(data,pw_train,item_train,item_validation,item_test,s)
%SETUPIMPLICITDATA setupImplicitData(data,pw_train,item_train,item_validate,item_test,s)
%   Setup data for the pairwise and item models from an implicit feedback
%   dataset.
%
% INPUT
%   - data : an implicit feedback dataset (i.e. containingp
%   relevant/positive observations only)
%   - pw_train,item_train,item_validate,item_test : files
%   - s: how many irrelevant items to sample for each relevant
%   item (for testing)

% create the dataset by sample for each relevant one irrelevant
irrelevant = sampleIrrelevantGivenContext(data);

% split for training / validation / testing
randInd = randperm(size(data,1));
relevant = data(randInd,:);
irrelevant = irrelevant(randInd,:);
tsize = ceil(0.7*size(relevant,1)); % 1:tsize = train
vsize = ceil(0.8*size(relevant,1)); % tsize+1:vsize = val
relTrain = relevant(1:tsize,:);
relVal = relevant(tsize+1:vsize,:);
relTest = relevant(vsize+1:end,:);
irrelTrain = irrelevant(1:tsize,:);
irrelVal = irrelevant(tsize+1:vsize,:);
csvwrite(item_train, [relTrain; irrelTrain]);
csvwrite(item_validation, [relVal; irrelVal]);

% create pairs from relevant & irrelevant set
% one pair for each relevant item
nContexts = size(data,2)-3;
% each pair is [userid,left_item,left_contexts,right_item,right_contexts,preference]
ptrain = samplePairsGivenContext(relTrain,irrelTrain,1,2);
fprintf('total number of pairs: %d\n', size(ptrain,1));
ntrain = [ptrain(:,1),ptrain(:,nContexts+3:end-1),ptrain(:,2:nContexts+2),-ptrain(:,end)];
csvwrite(pw_train, [ptrain; ntrain]);

% sample 20 irrelevant for users in test
testPool = [];
for i=1:s
  testPool = [testPool; sampleIrrelevantGivenContext(data)];
end
irrelTest = [];
nUsers = max(data(:,1));
for i=1:nUsers
  user = relTest(relTest(:,1)==i,:);
  uniqueContexts = unique(user(:,3:end-1),'rows');
  for j=1:size(uniqueContexts,1)
    irrelTest = [irrelTest; testPool(findRows(testPool(:,[1,3:end-1]),[i, uniqueContexts(j,:)]),:)];
  end
end
itest = [relTest; unique(irrelTest,'rows')];
csvwrite(item_test, itest);
end

