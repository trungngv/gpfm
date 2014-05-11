function checkGradMarginalLinearGP()
%CHECKGRADMARGINALLINEARGP checkGradMarginalLinearGP()
%  Check gradients for nMarginalLinearGP().
%
% See also
%   nMarginalLinearGP

%rng(100, 'twister');
N = 100;
dimItem = 5;
dimContext = [2;2;3];
dimBias = [dimItem; dimContext];
D = dimItem + sum(dimContext);
theta = rand(N*D+3, 1);
constMean = rand;
y = rand(N, 1);
[~, delta] = gradchek(theta', @f, @grad, y);
maxDiff = max(abs(delta));
assert(maxDiff < 1e-7,...
    ['test nMarginalLinearGP() failed with max diff ' num2str(maxDiff)]);
disp('test nMarginalLinearGP() passed');

[~, delta] = gradchek(constMean, @fMean, @gradMean, theta', y);
maxDiff = max(abs(delta));
assert(maxDiff < 1e-7,...
    ['test nMarginalLinearGP() for const mean failed with max diff ' num2str(maxDiff)]);
disp('test nMarginalLinearGP() for const mean passed');

[~, delta] = gradchek(theta', @fbias, @gradbias, y, dimBias);
maxDiff = max(abs(delta));
assert(maxDiff < 1e-7,...
    ['test nMarginalLinearGP() for bias term failed with max diff ' num2str(maxDiff)]);
disp('test nMarginalLinearGP() for bias term passed');

end

function obj = f(theta, y)
  obj = nMarginalLinearGP(theta, y);
end

function g = grad(theta, y)
  [~, g] = nMarginalLinearGP(theta, y);
end

% f with the const mean as variable
function obj = fMean(constMean, theta, y)
  obj = nMarginalLinearGP(theta, y, constMean);
end

% gradient with const mean as variable
function g = gradMean(constMean, theta, y)
  [~, ~, g] = nMarginalLinearGP(theta, y, constMean);
end

% f with bias
function obj = fbias(theta, y, dimBias)
  obj = nMarginalLinearGP(theta, y, 0, dimBias);
end

% gradient with bias
function g = gradbias(theta, y, dimBias)
  [~, g] = nMarginalLinearGP(theta, y, 0, dimBias);
end

