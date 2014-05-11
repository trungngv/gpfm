function irrelevant = sampleIrrelevantGivenItem(data)
%SAMPLEIRRELEVANTGIVENITEM irrelevant = sampleIrrelevantGivenItem(data)

% all contexts seen in the data set
allContexts = unique(data(:,3:end-1),'rows');
irrelevant = zeros(size(data));
nUsers = max(data(:,1));
for u=1:nUsers
  % [userid=u,itemid,contextIds,rating]
  indice = find(data(:,1)==u);
  R = data(indice,:);
  uniqueItems = unique(R(:,2),'rows');
  for i=1:size(uniqueItems,1)
    % relevant contexts observed with this items
    item = uniqueItems(i);
    rows = find(R(:,2)==item);
    relevant_u = R(rows,:);
    M = size(relevant_u,1);
    relevant_ids = zeros(M,1);
    for j=1:M
      relevant_ids(j) = find(findRows(allContexts,relevant_u(j,3:end-1)));
    end
    irrelevant_ids = setdiff(1:size(allContexts,1), relevant_ids);
    irrelevant_ids = irrelevant_ids(randperm(numel(irrelevant_ids),M));
    irrelevant(indice(rows),:) = [repmat(u,M,1),repmat(item,M,1),allContexts(irrelevant_ids,:),-ones(M,1)];
  end
end


