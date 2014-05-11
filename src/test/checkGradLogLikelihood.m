function checkGradLogLikelihood()
%CHECKGRADLOGLIKELIHOOD checkGradLogLikelihood()
%  Check gradients for nLogLikelihood().
%
% See also
%   nLogLikelihood

%rng(100, 'twister');
model = getTestData(true,'linear',true);
runTest(model);
model = getTestData(true,'linear',false);
runTest(model);
model = getTestData(true,'rbf',true);
runTest(model);
model = getTestData(true,'rbf',false);
runTest(model);
end

function runTest(model)
userId = 1;
u = getUserParams(1, model);
theta = rand(size(u));
[~, delta] = gradchek(theta', @f, @grad, userId, model);
maxDiff = max(abs(delta));
assert(maxDiff < 1e-7,...
    ['test nLogLikelihood() failed with max diff ' num2str(maxDiff)]);
disp('test nLogLikelihood() passed for latent features and hyperparameters');
bias = rand;
[~, delta] = gradchek(bias, @f_bias, @g_bias, theta, userId, model);
maxDiff = max(abs(delta));
assert(maxDiff < 1e-7,...
    ['test nLogLikelihood() for bias failed with max diff ' num2str(maxDiff)]);
disp('test nLogLikelihood() passed for bias (mean)');
end

function obj = f(theta, userId, model)
  obj = nLogLikelihood(theta, userId, model);
end

function g = grad(theta, userId, model)
  [~, g] = nLogLikelihood(theta, userId, model);
end

function obj = f_bias(bias, theta, userId, model)
  model.means(userId) = bias;
  obj = nLogLikelihood(theta, userId, model);
end

function g = g_bias(bias, theta, userId, model)
  model.means(userId) = bias;
  [~, ~, g] = nLogLikelihood(theta, userId, model);
end

