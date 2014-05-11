function model = gppwInitModel(pairT, T, testT, conf)
%GPPWINITMODEL model = gppwInitModel(pairT, T, testT, conf)
%
% Init a ggpw pairwise preference model for training. 
%
% INPUT
%   - pairT : training paired comparison matrix
%   - T : item-based training matrix (required for prediction)
%   - testT : testing matrix
%   - conf : configuration for models (kernel, dimItem, dimContext,
%   latentStd, sigmaNoise)
%
% OUTPUT
%   - the init model
%
% Trung Nguyen
% 21/01/2014
model.T = T;
model.pairT = pairT;
model.testT = testT;
model.kernel = conf.kernel;
model.latentStd = conf.latentStd;
model.sigmaNoise = conf.sigmaNoise;
model.useBias = conf.useBias;
if model.useBias
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
% mean
model.means = zeros(model.num_users,1);
for i=1:model.num_users
  model.hyp{i} = log([0.1+rand; 0.5; model.sigmaNoise + 0.1*rand]);
  %model.means(i) = mean(model.T(model.T(:,1)==i,end));
end

