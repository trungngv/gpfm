function val = mynlpd(ytrue, ymu, yvar)
%MYNLPD val = mynlpd(ytrue, ymu, yvar)
%   Computes the negative log predictive (for a Gaussian predictive
%   distribution) of the test points.
% 
% INPUT
%   - ytrue : true output values
%   - ymu : predictive means
%   - yvar : predictive variances
%
% OUTPUT
%   - the negative log predictive density NLPD = 1/T \sum_{t=1}^T -log
%   p(ytrue_t; ymu_t, yvar_t)
%
% Trung V. Nguyen
% 18/01/13
val = 0.5*mean((ytrue-ymu).^2./yvar+log(2*pi*yvar));
end

