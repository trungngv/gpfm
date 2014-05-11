function model = rSgdLearn(model, opt)
%RSGDLEARN model = rSgdLearn(model, opt)
%   
% Stochastic gradient descent (SGD) training for a regression model. The
% standard SGP is applied where we use the update that has the momentum term:
% u_{t+1} = u_t + delta_{t}
%    where delta_{t} = p delta_{t-1} - \alpha grad(u_t).
% p is the momentum parameter, often set to 0.9 and \alpha is the learning
% rate. Using the momentum term appears to allow a larger set of learning
% rate values and gives faster convergence rate.
% 
% The model returned by this method can be used to continue learning.
%
% 13/01/14
% Trung V. Nguyen

P = model.num_users;
if ~isfield(model, 'objectives')
  model.deltaV = zeros(size(model.V));
  ncontexts = numel(model.num_context);
  model.deltaC = cell(ncontexts,1);
  for i=1:ncontexts
    model.deltaC{i} = zeros(size(model.C{i}));
  end
  model.deltaHyp = cell(size(model.hyp));
  model.deltaMean = zeros(P,1);
  model.objectives = [];
end  
iter = 1;
for n=1:opt.epochs
  sampleIds = randperm(P);
  %disp(['epoch ' num2str(n)])
  for i=1:P
    userid = sampleIds(i);
    % ignore user with no training data
    if ~any(model.T(:,1) == userid),    continue,   end;
    if isempty(model.deltaHyp{userid})
      model.deltaHyp{userid} = zeros(size(model.hyp{1}));
    end
    X = getX(model, userid);
    [~, g, gMean] = rMarginal(X, userid, model);
    model = sgdUpdateUser(g, gMean, userid, model, opt);
    % show sum of log likelihood to check for convergence
    if ~isempty(opt.monitorConvergence) && mod(iter, opt.monitorConvergence) == 0 
      model.objectives = [model.objectives; rComputeObjective(model)];
      if opt.displayObjectives
        disp([num2str(iter) ' ' num2str(model.objectives(end))])
      end  
    end
    iter = iter + 1;
  end
end
end

