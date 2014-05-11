function model = getTestData(big,kernel,useBias)
%GETTESTDATA Generate some test data
%
% Set big to true to generate large tests.

% T(i,:) = [userId, itemId, context1Id, ..., contextMId, rating]

if nargin <= 1
  kernel = 'rbf'; useBias = 'false';
  if nargin == 0
    big = false;
  end
end
if big
  model.num_users = 100;% + floor(1000*rand);
  model.num_items = 100 + floor(1000*rand);
  % 5 - 10 contexts
  nContexts = 5 + floor(5*rand);
  % each context has 2 - 5 possible values
  model.num_context = 2 + floor(3*rand(nContexts,1));
  % 10 - 40 latent dimension for item
  model.dim_item = 10 + floor(40*rand);
  % 2 - 5 latent dimenions for each context
  model.dim_context = 2 + floor(3*rand(nContexts,1));
  N = 1000; % 1000 observations
  model.T = zeros(N, 3 + nContexts);
  % user ids
  model.T(:,1) = ceil(model.num_users*rand(N,1));
  % item ids
  model.T(:,2) = ceil(model.num_items*rand(N,1));
  for k=1:nContexts
    model.T(:,2+k) = ceil(model.num_context(k)*rand(N,1));
  end
  % rating
  model.T(:,end) = 5*rand(N,1);
else
  model.T = [1, 1, 1, 1, 5;
             1, 2, 2, 2, 2;
             2, 1, 1, 2, 1;
             3, 2, 2, 1, 4];
  model.num_users = 3;
  model.num_items = 2;
  model.num_context = [2; 2];
  model.dim_item = 1;
  model.dim_context = [1; 1];    
end
conf.kernel = kernel;
conf.dimItem = model.dim_item;
conf.dimContext = model.dim_context;
conf.latentStd = 0.5;
conf.sigmaNoise = 0.5;
conf.useBias = useBias;
model = initModel(model.T,[],conf);
