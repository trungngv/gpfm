function e = edwinsmse(ytrue, ypred)
%EDWINSMSE e = edwinsmse(ytrue, ypred)
% computes the SMSE: The mean square error normalised by the variance
% of the test targets (actually the implementation uses variance of the
% training targets!)
%
% INPUT:
%   - ytrue: real
%   - ypred: prediction from my model
%
% Edwin V. Bonilla

res = ytrue - ypred; % residuals
e   = mean(res.^2,1);
vari = var(ytrue, 1, 1); % Normalizes over N
e = e./vari;

return;

 