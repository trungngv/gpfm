function [f, grad, gradmean] = gppwInf(model, userid)
%GPPWINF [f, grad, gradmean] = gppwInf(model, userId)
%   
% The negative log marginal of a pairwise preference model for the given
% user and its derivatives.
%
% INPUT
%   - model : the model
%   - userid : id of the user
%
% OUTPUT
%
% 30/01/14
% Trung V. Nguyen
y = model.pairT(model.pairT(:,1)==userid,end);
N = size(y, 1);
hyp = model.hyp{userid};
nContexts = numel(model.num_context);
T = model.pairT(model.pairT(:,1) == userid, 2:2+nContexts);
Xleft = getX(T,model);
T = model.pairT(model.pairT(:,1) == userid, 3+nContexts:end-1);
Xright = getX(T,model);
% hyp(1:end-1): [log ell; log s], hyp(end): [log sigma]
% X : input matrix
y0 = y - model.means(userid);
if model.useBias
  [Xleft, Xleft_bias] = toLatentAndBias(Xleft, [model.dim_item; model.dim_context]);
  [Xright, Xright_bias] = toLatentAndBias(Xright, [model.dim_item; model.dim_context]);
  y0 = y - sum(Xleft_bias,2) + sum(Xright_bias,2);
end
% Given X pairs X = [Xleft,Xright], the preference kernel yields this cov matrix:
% K_pref(X,S) = K(Xleft,Sleft) + K(Xright,Sright) - K(Xleft,Sright) - K(Xright,Sleft)
% here S = X 
prefKernel = @(X,S) covSEiso(hyp(1:end-1),X,S); 
Kpp = prefKernel(Xleft,Xleft);
Kmm = prefKernel(Xright,Xright);
Kpm = prefKernel(Xleft,Xright);
K =  Kpp + Kmm - Kpm - Kpm';
sigma2 = exp(2*hyp(end));
ell2 = exp(2*hyp(1));
Ky = sigma2*eye(N) + K;     % Ky = \sigma^2 I + K
Ly = jit_chol(Ky);          % Ky = Ly'Ly
invKy = invChol(Ly);         % (\sigma^2 I + K)^{-1} = Ky^{-1}
%f = 0.5*(logdetChol(Ly) + yinvKyChol(y, Ly));
f = 0.5*(logdetChol(Ly) + y0'*invKy*y0);

% derivatives
if nargout >= 2
  alpha = invKy * y0;  % \alpha = Ky^{-1} y
  invKyMinusAlpha2 = invKy - alpha*alpha'; % Ky^{-1} - \alpha \alpha'
  
  % gradients of X = [X+,X-]
  grad.Xplus = zeros(size(Xleft));
  grad.Xminus = zeros(size(Xright));
  for d=1:size(Xleft,2)
    DKpp = bsxfun(@minus,Xleft(:,d),Xleft(:,d)');
    DKpp = -Kpp.*DKpp;
    DKpm = bsxfun(@minus,Xleft(:,d),Xright(:,d)');
    DKpm = -Kpm.*DKpm;
    DKmm = bsxfun(@minus,Xright(:,d),Xright(:,d)');
    DKmm = -Kmm.*DKmm;
    DK = DKpp - DKpm - DKpm';
    grad.Xplus(:,d) = (sum(invKyMinusAlpha2 .* DK, 2) - 0.5*diag(invKyMinusAlpha2) .* diag(DK))';
    DK = DKmm - DKpm - DKpm';
    grad.Xminus(:,d) = (sum(invKyMinusAlpha2 .* DK, 2) - 0.5*diag(invKyMinusAlpha2) .* diag(DK))';
  end
  clear Kpp;  clear Kpm;  clear Kmm;
  clear DK; clear DKpp; clear DKpm; clear DKmm;
  grad.Xplus = grad.Xplus / ell2;
  grad.Xminus = grad.Xminus / ell2;
  
  if model.useBias
    % gradients of Xbias (item and context)
    grad.Xplus_bias = repmat(-(invKy*y0),1,size(Xleft_bias,2));
    grad.Xminus_bias = -grad.Xplus_bias;
  end
  
  % gradients of covariance hyperparameters
  grad.hyp = zeros(size(hyp));
  dprefKernel = @(X,S,i) covSEiso(hyp, X, S, i);
  for i=1:numel(hyp) - 1
    dKdi = dprefKernel(Xleft,Xleft,i) + dprefKernel(Xright,Xright,i);
    dKpmi = dprefKernel(Xleft,Xright,i);
    dKdi = dKdi - dKpmi - dKpmi';
    grad.hyp(i) = 0.5 * traceAB(invKyMinusAlpha2,dKdi);
  end
  
  % gradients of noise
  % dKy/dsigma = 2*sigma^2 I, thus the 0.5 term cancelled
  grad.hyp(end) =  sigma2*trace(invKyMinusAlpha2);
  
  % gradient of bias (function mean)
  % dKy/dm = invKy * (m - y), note that y was set to y-bias 
  gradmean = -sum(invKy*y0);
end
end

% T contains [itemid,context1id,...,contextnid]
function X = getX(T,model)
X = model.V(T(:,1),:); % item
% features of observed contexts
nContexts = numel(model.num_context);
for k=1:nContexts
  X = [X, model.C{k}(T(:,1+k),:)];
end
end

