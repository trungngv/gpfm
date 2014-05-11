function [f, grad, gradmean] = rInferenceLinearOne(x, y, meanConst, dimBias)
%RINFERENCELINEARONE [f, grad, gradbias] = rInferenceLinearOne(x, y, meanConst, dimBias)
%   
% The negative log likelihood of a standard GP regression using linear
% kernel with a scale parameter and optional linear mean function.
%
% INPUT
%   - x : vector containing all latent inputs and covariance
%   hyperparameters
%   - y : outputs 
%   - meanConst : optional const mean if not zero
%   - dimBias : contains [dim_item,dim_context] of the gpfm model
%
% OUTPUT
%
% 14/11/13
% Trung Nguyen
N = size(y, 1);
% X : input matrix
% hyp(1:end-1): [log ell; log s], hyp(end): [log sigma]
X = x.latent;
hyp = x.hyp;
useBias = false;
Xlatent = X;
y0 = y;
if nargin == 3        % use const mean
  y0 = y - meanConst;
elseif nargin == 4    % use linear mean
  useBias = true;
  [Xlatent, Xbias] = toLatentAndBias(X, dimBias);
  y0 = y - meanConst - sum(Xbias,2);
end

K = covLINone(hyp(1), Xlatent);
sigma2 = exp(2*hyp(end));
Ky = sigma2*eye(N) + K;     % Ky = \sigma^2 I + K
Ly = jit_chol(Ky);          % Ky = Ly'Ly
invKy = invChol(Ly);         % (\sigma^2 I + K)^{-1} = Ky^{-1}
f = 0.5*(logdetChol(Ly) + y0'*invKy*y0);

% derivatives
if nargout >= 2
  alpha = invKy * y0;  % \alpha = Ky^{-1} y
  invKyMinusAlpha2 = invKy - alpha*alpha'; % Ky^{-1} - \alpha \alpha'
  
  % gradients of Xlatent
  grad.latent = zeros(size(Xlatent));
  for d=1:size(Xlatent,2)
    DK = repmat(Xlatent(:,d)',N,1)/exp(2*hyp(1));
    DK = setDiag(DK,2*diag(DK));
    grad.latent(:,d) = (sum(invKyMinusAlpha2.*DK, 2) - 0.5*diag(invKyMinusAlpha2).*diag(DK))';
  end

  if useBias
    % gradients of Xbias (item and context)
    grad.bias = repmat(-(invKy*y0),1,size(Xbias,2));
  end
    
  % gradients of covariance hyperparameters
  grad.hyp = zeros(size(hyp));
  dKdi = covLINone(hyp(1), Xlatent, [], 1);
  grad.hyp(end-1) = 0.5 * traceAB(invKyMinusAlpha2,dKdi);
  
  % gradients of noise
  % dKy/dsigma = 2*sigma^2 I, thus the 0.5 term cancelled
  grad.hyp(end) =  sigma2*trace(invKyMinusAlpha2);
  
  % gradient of user bias 
  % dKy/dm = invKy * (m - y), note that y was set to y-bias 
  gradmean = -sum(invKy*y0);
end
end

