function x = wrapToVec(X, hyp)
%WRAPTOVEC x = wrapToVec(X, hyp)
%   
% Wrap all (optimization) parameters to a vector.
% 
% See also unwrapVec
% 08/10/13

x = [X(:); hyp(:)];
