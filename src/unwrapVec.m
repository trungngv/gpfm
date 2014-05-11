function [X, hyp] = unwrapVec(x, N)
%UNWRAPVEC [X, hyp] = unwrapVec(x, N)
%   
% Convert the vector x back to a matrix of latent features and a vector of
% hyperparameters. Depending on the covariance function and the likelihood
% model in use, the actual number of hyperparameters may vary. For
% consistency (and compatability) we assume it always has 3 elements with
% the last one being likelihood parameter (if it exists).
% 
% See also
% wrapToVec.m
%
% 08/10/13
hyp = x(end-2:end);
X = reshape(x(1:end-3), N, []);

