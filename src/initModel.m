function model = initModel(T, testT, conf)
%model = initModel(T, testT, conf)
%
% Init a regression model for training. 
%
% INPUT
%   - T : training matrix
%   - testT : testing matrix
%   - conf.kernel : 'rbf', linear' or 'linearOne'
%   - conf.dimItem : latent dimension of items
%   - conf.dimContxt : lantent dimensions of contexts
%   - conf.latentStd : std to generate initial latent values
%   - conf.sigmaNoise : noise
%   - conf.useBias : use context and item bias
%
% OUTPUT
%   - model
%
% Trung Nguyen
% 06/11/2013

model.T = T;
model.testT = testT;
model.kernel = conf.kernel;
switch model.kernel
  case 'linear'
    model.gpObjective = 'nMarginalLinearGP';
  case 'linearOne'
    model.gpObjective = 'nMarginalLinearOneGP';
  case 'rbf'
    model.gpObjective = 'nMarginalRbfGP';
end
if conf.useBias
  % if use bias, the first element of each latent vector is the bias
  model.dim_item = conf.dimItem + 1;
  model.dim_context = conf.dimContext + 1;
else
  model.dim_item = conf.dimItem;
  model.dim_context = conf.dimContext;
end

allT = [T; testT];
model.num_users = max(allT(:,1));
model.num_items = max(allT(:,2));
model.num_context = max(allT(:,3:end-1));
model.latentStd = conf.latentStd;
model.sigmaNoise = conf.sigmaNoise;
model.useBias = conf.useBias;

% item features
model.V = model.latentStd * rand(model.num_items, model.dim_item);
% context features
nContexts = numel(model.num_context);
model.C = cell(nContexts,1);
for k=1:nContexts
  model.C{k} = model.latentStd * rand(model.num_context(k), model.dim_context(k));  
end
% hyper-parameters
model.hyp = cell(model.num_users,1);
model.map = cell(model.num_users,1);
% bias 
model.means = zeros(model.num_users,1);
for i=1:model.num_users
  model.hyp{i} = log([rand; 1.1; model.sigmaNoise + 0.1*rand]);
  u = getUserParams(i, model);
  [~, model.map{i}] = userParamsToMatrix(u, i, model);
  model.means(i) = mean(model.T(model.T(:,1)==i,end));
end

