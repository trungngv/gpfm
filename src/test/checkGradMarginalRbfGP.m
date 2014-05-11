function checkGradMarginalRbfGP()
%CHECKGRADMARGINALRBFGP checkGradMarginalRbfGP()
%  Check gradients for nMarginalRbfGP().
%
% See also
%   nMarginalRbfGP

%rng(100, 'twister');
N = 100;
D = 10;
theta = rand(N*D+3, 1);
y = rand(N, 1);
[~, delta] = gradchek(theta', @f, @grad, y);
maxDiff = max(abs(delta));
assert(maxDiff < 1e-7,...
    ['test nMarginalRbfGP() failed with max diff ' num2str(maxDiff)]);
disp('test nMarginalRbfGP() passed');

bias = rand;
[~, delta] = gradchek(bias, @fbias, @gradbias, theta', y);
assert(maxDiff < 1e-7,...
    ['test nMarginalRbfGP() for bias failed with max diff ' num2str(maxDiff)]);
disp('test nMarginalRbfGP() for bias passed');

function obj = f(theta, y)
  obj = nMarginalRbfGP(theta, y);
end

function obj = fbias(bias, theta, y)
  obj = nMarginalRbfGP(theta, y, bias);
end

function g = grad(theta, y)
  [~, g] = nMarginalRbfGP(theta, y);
end

function g = gradbias(bias, theta, y)
  [~, ~, g] = nMarginalRbfGP(theta, y, bias);
end
end
