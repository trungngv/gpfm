function [X, hyp] = unwrapUserParams(u, userId, model)
%UNWRAPUSERPARAM [X, hyp] = unwrapUserParams(u, userId, model)
%   
% Unwrap the parameter vector (of user userId) to the input matrix (X) and
% the hyperparameters of the covariance matrix (hyp).
% Currently using RBF kernel so hyp contains 3 elements.
% 
% See also
%   userParamsToMatrix
%
% 09/10/13

%X = userParamsToMatrix(u, userId, model);
N = sum(model.T(:,1) == userId);
X = reshape(u(model.map{userId}), N, []);
hyp = u(end-2:end);

