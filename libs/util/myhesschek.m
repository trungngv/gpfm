function [h hcent delta] = myhesschek(theta, error_func, hess_func, varargin)
% MYHESSCHEK [h hcent delta] = myhesschek(theta, error_func, hess_func, varargin)
% Check the hessian

h = feval(hess_func, theta, varargin{:});
nwts = length(theta);
hcent = zeros(nwts, 1);
h1 =  0.0; h2 =  0.0; h3 =  0.0; h4 = 0.0;
epsilon = 1.0e-4;
theta0 = theta;
fprintf(1, 'Checking Hessian ...\n\n');
for k = 1:nwts;
  theta(k) = theta0(k) + 2.0*epsilon;
  h1 = feval(error_func, theta, varargin{:});
  theta(k) = theta0(k) - 2.0*epsilon;
  h2 = feval(error_func, theta, varargin{:});
  theta(k) = theta0(k);
  h3 = feval(error_func, theta, varargin{:});
  hcent(k) = (h1 + h2 - 2.0*h3)/(4.0*epsilon^2);
end

delta = h(:) - hcent(:);


fprintf(1, '   analytical    numerical       delta\n\n');
temp = [h(:), hcent(:), delta];
fprintf(1, '%12.6f  %12.6f  %12.6f\n', temp');

  