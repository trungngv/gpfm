function [A,B] = getFold(X, N, k)
%GETFOLD [A,B] = getFold(X, N, k)
%
%  Get the k-th fold in a N-fold dataset X, which can be used for
%  cross-validation.
%  
%  INPUT:
%    - X : data matrix to split
%    - N : number of folds
%    - k : the k-th fold to split
%
%  OUTPUT:
%    - A : all data excluding the k-th fold B
%    - B : the k-th fold
%
% 26/10/13
% Trung Nguyen
foldSize = ceil(size(X,1)/N);
offsets = [foldSize*(0:N-1), size(X,1)];
foldIndice = offsets(k)+1:offsets(k+1);
B = X(foldIndice,:);
A = X;
A(foldIndice,:) = [];
end

