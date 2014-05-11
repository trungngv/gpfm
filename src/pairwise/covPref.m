function K = covPref(hyp, x, z, i)
%COVPREF  K = covPref(hyp, x, z, i)
%   
% The preference kernel.
if nargin<2, K = '2'; return; end                  % report number of parameters
dg = false;
if nargin == 3 && strcmp(z,'diag')
  dg = true;
  z = x;
end
if nargin<3
  z = x;  % self-covariance (make suze z exist)
end
prefKernel = @(X,S) covSEiso(hyp,X,S);
half = size(x,2)/2;
Xi = x(:,1:half);
Xj = x(:,half+1:end);
Xk = z(:,1:half);
Xl = z(:,half+1:end);
Kik = prefKernel(Xi,Xk);
Kjl = prefKernel(Xj,Xl);
Kil = prefKernel(Xi,Xl);
Kjk = prefKernel(Xj,Xk);
K =  Kik + Kjl - Kil - Kjk;
if dg
  K = diag(K);
end
end

