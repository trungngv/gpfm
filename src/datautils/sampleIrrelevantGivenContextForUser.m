function A = sampleIrrelevantGivenContextForUser(T,u,s)
%SAMPLEIRRELEVANTGIVENCONTEXT A = sampleIrrelevantGivenContextForUser(T,u,s)
%   
% For each user u, sample s*N irrelevant items for each observed context where 
% N is the number of relevant items given the context.
% The irrelevant observations are given a rating of -1 and 
% are of course distinctive from the observed/rated set.
% 
% We are talking about observations because an observation is composed of
% an item and the context.
%
% INPUT
%   - T : the observations matrix
%   - u : the user to sample for 
%   - s : the number of irrelevant samples per relevant item
% OUTPUT
%   - A : the sampled irrelevant matrix
%
R = T(T(:,1)==u,:);
A = [];
maxItemId = max(T(:,2));
uniqueContext = unique(R(:,3:end-1),'rows');
for i=1:size(uniqueContext,1)
  % relevant items given this context
  context = uniqueContext(i,:);
  relevant_ids = R(findRows(R(:,3:end-1),context),2);
  irrelevant_ids = setdiff(1:maxItemId, relevant_ids);
  sample_ids = irrelevant_ids(randperm(numel(irrelevant_ids),s*numel(relevant_ids)));
  ns = numel(sample_ids); % num samples
  A = [A; [repmat(u,ns,1), sample_ids(:), repmat(context,ns,1), repmat(-1,ns,1)]];
end
end

