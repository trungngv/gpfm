function grad = numeric_grad3(fun, x0, varargin)
% NUMERIC_GRAD3 g = numeric_grad3(fun, x0, varargin)
%
% Computes the gradients of a multivariate scalar function f using 3-point
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
% 27/06/2012
%

delta = 1e-03 * x0; % recommended sqrt(eps) if not relative to x0
grad = zeros(size(x0));
for i = 1 : length(x0)
  if x0(i) == 0
    delta(i) = 1e-10;
  end
  % use 3-point estimation (more computationally expensive)
  x = x0;
  x(i) = x0(i)+delta(i);
  fplus = feval(fun, x, varargin{:});
  x(i) = x0(i)-delta(i);
  fminus = feval(fun, x, varargin{:});
  grad(i) = 0.5*(fplus - fminus)/delta(i);
end

return;