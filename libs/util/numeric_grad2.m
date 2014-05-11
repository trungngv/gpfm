% function g = numeric_grad(fun, x0)
%
% Computes the gradients of a multivariate scalar function f using 2-point
% numerical differentiation.
%
% INPUT
%     fun : a function handle of the function that evaluates f
%     x0 : a vector of input points where the gradients are evaluated
%
% RETURN
%     g : a vector of gradients evaluated at corresponding values in x0
%
% author : trung nguyen (trung.ngvan@gmail.com)
% last updated: 27 june 2012
%
function grad = numeric_grad2(fun, x0, varargin)
delta = 1e-4 * x0; % recommended sqrt(eps)
grad = zeros(size(x0));
f0 = feval(fun, x0, varargin{:});
for i = 1 : length(x0)
  if x0(i) == 0
    delta(i) = 1e-10;
  end
  x = x0;
  x(i) = x0(i) + delta(i);
  f1 = feval(fun, x, varargin{:});
  grad(i) = (f1 - f0) / delta(i);
end

return;