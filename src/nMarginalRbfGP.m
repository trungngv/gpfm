function [f, grad, gradbias] = nMarginalRbfGP(x, y, meanConst, dim)
%NMARGINALRBFGP [f, grad, gradbias] = nMarginalRbfGP(x, y, meanConst, dim)
%   
% The negative log likelihood of a standard GP regression with latent
% inputs and its gradients using RBF covariance function.
%
% INPUT
%   - x : vector containing all latent inputs and covariance
%   hyperparameters
%   - y : outputs 
%   - meanConst : a constant mean (if mean is not zero)
%   - dim : [model.dim_item; model.dim_context]
%
% OUTPUT
%
% 06/11/13
% Trung Nguyen

N = size(y, 1);
% X : input matrix
% hyp(1:end-1): [log ell; log s], hyp(end): [log sigma]
[X, hyp] = unwrapVec(x, N);
useBias = false;
Xlatent = X;
y0 = y;
if nargin == 3        % use const mean
  y0 = y - meanConst;
elseif nargin == 4    % use linear mean
  useBias = true;
  [Xlatent, Xbias] = toLatentAndBias(X, dim);
  y0 = y - meanConst - sum(Xbias,2);
end

K = covSEiso(hyp(1:end-1), Xlatent);
sigma2 = exp(2*hyp(end));
ell2 = exp(2*hyp(1));
Ky = sigma2*eye(N) + K;     % Ky = \sigma^2 I + K
Ly = jit_chol(Ky);          % Ky = Ly'Ly
invKy = invChol(Ly);         % (\sigma^2 I + K)^{-1} = Ky^{-1}
%f = 0.5*(logdetChol(Ly) + yinvKyChol(y, Ly));
f = 0.5*(logdetChol(Ly) + y0'*invKy*y0);

% derivatives
if nargout >= 2
  grad = zeros(size(x));
  alpha = invKy * y0;  % \alpha = Ky^{-1} y
  invKyMinusAlpha2 = invKy - alpha*alpha'; % Ky^{-1} - \alpha \alpha'
  
  % gradients of Xlatent
  gradXlatent = zeros(size(Xlatent));
  for d=1:size(Xlatent,2)
    DK = bsxfun(@minus,Xlatent(:,d),Xlatent(:,d)');
    DK = -(K.*DK)./ell2;
    gradXlatent(:,d) = (sum(invKyMinusAlpha2 .* DK, 2) - 0.5*diag(invKyMinusAlpha2) .* diag(DK))';
  end
  if useBias
    % gradients of Xbias (item and context)
    gradBias = repmat(-(invKy*y0),1,size(Xbias,2));
    grad(1:numel(X)) = fromLatentAndBias(gradXlatent,gradBias,dim);
  else
    grad(1:numel(Xlatent)) = gradXlatent(:);
  end
  
  % gradients of covariance hyperparameters
  numCovParams = numel(hyp) - 1;
  offset = numel(grad) - 1 - numCovParams;
  for i=1:numCovParams
    dKdi = covSEiso(hyp, Xlatent, [], i);
    grad(offset + i) = 0.5 * traceAB(invKyMinusAlpha2,dKdi);
  end
  
  % gradients of noise
  % dKy/dsigma = 2*sigma^2 I, thus the 0.5 term cancelled
  grad(end) =  sigma2*trace(invKyMinusAlpha2);
  
  % gradient of bias (function mean)
  % dKy/dm = invKy * (m - y), note that y was set to y-bias 
  gradbias = -sum(invKy*y0);
end
