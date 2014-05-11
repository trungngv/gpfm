function hyp = gpml_init_hyp(x,y,zero_mean)
%GPML_INIT_HYP hyp = gpml_init_hyp(x,y,zero_mean)
%
% Sensible initialisation of hyperparameters for given dataset.
%
% The returned hyp has structure that can directly be used with the GPML
% framework.
% 
% INPUT
%   - x, y
%   - zero_mean : initialisation with zero-mean outputs
% 
% Trung V. Nguyen
epsilon = 1e-10; % avoid INF
if zero_mean
  y = y - mean(y);
end
lengthscales = log((max(x) - min(x) + epsilon)'/2);
lengthscales(lengthscales < -1e2) = -1e2;
hyp.cov = [lengthscales; 0.5*log(var(y,1) + epsilon)];
hyp.lik = 0.5*log(var(y,1)/4 + epsilon);

