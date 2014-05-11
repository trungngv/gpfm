function pairs = samplePairsGivenContext(relevant,irrelevant,alpha,version)
%SAMPLEPAIRSGIVENCONTEXT pairs = samplePairsGivenContext(relevant,irrelevant,alpha,version)
%   
if nargin == 3
  version = 1;
end
pairs = [];
nUsers = max(relevant(:,1));
for u=1:nUsers
  % [userid=u,itemid,contextIds,rating]
  A = relevant(relevant(:,1)==u,:);
  B = irrelevant(irrelevant(:,1)==u,:);
  uniqueContext = unique(A(:,3:end-1),'rows');
  for i=1:size(uniqueContext,1)
    % relevant items given this context
    context = uniqueContext(i,:);
    relevant_ids = A(findRows(A(:,3:end-1),context),2);
    irrelevant_ids = B(findRows(B(:,3:end-1),context),2);
    M = numel(relevant_ids);
    % for each relevant item in this user | context, sample \alpha*M pairs
    if version == 1
      npairs = ceil(alpha*M);
    else
      npairs = min(alpha,M); % sample alpha pairs per observation or M pairs if M < alpha
    end
    for j=1:M
      if numel(irrelevant_ids) == 0
        irrelevant_ids = setdiff(1:max(relevant(:,2)),relevant_ids);
      end
      right_ids = irrelevant_ids(randperm(numel(irrelevant_ids),npairs));
      left = repmat([relevant_ids(j),context],npairs,1);
      right = [right_ids(:),repmat(context,npairs,1)];
      pairs = [pairs;[repmat(u,npairs,1),left,right,ones(npairs,1)]];
    end
  end
end
end

