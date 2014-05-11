function irrelevant = sampleIrrelevantGivenContext(data)
%SAMPLEIRRELEVANTGIVENCONTEXT irrelevant = sampleIrrelevantGivenContext(data)
%   
nUsers = max(data(:,1));
maxId = max(data(:,2));
irrelevant = zeros(size(data));
for u=1:nUsers
  % [userid=u,itemid,contextIds,rating]
  indice = find(data(:,1)==u);
  R = data(indice,:);
  uniqueContext = unique(R(:,3:end-1),'rows');
  for i=1:size(uniqueContext,1)
    % relevant items given this context
    context = uniqueContext(i,:);
    rows = findRows(R(:,3:end-1),context);
    relevant_u = R(rows,:);
    M = size(relevant_u,1);
    irrelevant_ids = setdiff(1:maxId, relevant_u(:,2));
    irrelevant_ids = irrelevant_ids(randperm(numel(irrelevant_ids),M));
    irrelevant(indice(rows),:) = [repmat(u,M,1),irrelevant_ids(:),repmat(context,M,1),-ones(M,1)];
  end
end
end

