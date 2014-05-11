function model = sgdLearn(model, opt)
%SGDLEARN model = sgdLearn(model, opt)
%   
% Stochastic gradient descent (SGD) training for the given model (not using
% linesearch). The standard SGP is applied where we use the update that has
% the momentum term:
% u_{t+1} = u_t + delta_{t}
%    where delta_{t} = p * delta_{t-1} - \alpha * grad(u_t).
% p is the momentum parameter, often set to 0.9 and \alpha is the learning
% rate. Using the momentum term appears to allow a larger set of learning
% rate values and gives faster convergence rate.
% 
% The model returned by this method can be used to continue learning.
%
% 31/10/13
% Trung Nguyen

P = model.num_users;
if ~isfield(model, 'objectives')
  model.delta = cell(P,1);
  model.biasDelta = zeros(P,1);
  model.objectives = [];
  model.normDiffs = [];
end  
iter = 1;
for n=1:opt.epochs
  sampleIds = randperm(P);
  %disp(['epoch ' num2str(n)])
  for i=1:P
    userId = sampleIds(i);
    % ignore user with no training data
    if ~any(model.T(:,1) == userId),    continue,   end;
    u = getUserParams(userId, model);
    [~, g, biasGrad] = nLogLikelihood(u, userId, model);
    if isempty(model.delta{userId})
      model.delta{userId} = zeros(size(u));
      model.biasDelta(userId) = 0;
    end
    model.delta{userId} = opt.momentum * model.delta{userId} - opt.learnRate * g;
    model.biasDelta(userId) = opt.momentum * model.biasDelta(userId) - opt.learnRate * biasGrad;
    newU = u + model.delta{userId};
    model.means(userId) = model.means(userId) + model.biasDelta(userId);
    model = updateUserParams(userId, newU, model);
    % show sum of log likelihood to check for convergence
    if ~isempty(opt.monitorConvergence) && mod(iter, opt.monitorConvergence) == 0 
      model.normDiffs(iter) = norm(u - newU, 2);
      model.objectives = [model.objectives; computeObjective(model)];
      if opt.displayObjectives
        disp([num2str(iter) ' ' num2str(model.objectives(end))])
      end  
    end
    iter = iter + 1;
  end
end

%figure;
%plot(1:numel(model.normDiffs), model.normDiffs, '-');
%xlabel('iteration')
%ylabel('parameter change');

% if ~isempty(opt.monitorConvergence)
%   figure;
%   plot(1:numel(model.objectives), model.objectives, '-');
%   xlabel('iteration')
%   ylabel('objective')
%   title('objective vs. iteration using regular sgd')
% end
end

