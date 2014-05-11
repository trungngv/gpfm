function I = rowfind(X)
%ROWFIND I = rowfind(X)
%  Find indices of the first true element on each row of the logical matrix X.  
%  This functions is optimized for a tall matrix, i.e. the number of row is
%  much larger than the number of columns.
%
%  Example:
%    X = [1 0 0; 0 0 1];
%    I = rowfind(X)
%    I = 
%         1
%         3
%  INPUT
%    - X : logical matrix
%
%  OUTPUT
%    - I : I(n) = indice of the first one column in the n-th row
%
% Trung Nguyen
% 08/04/13

% first algorithm
X = logical(X);
dim = size(X,2);
I = zeros(size(X,1),1);
for i=1:dim
  I(X(:,i) & (I == 0)) = i;
end

% second algorithm
% tstart = tic;
% [R,C] = find(X);
% I = zeros(size(X,1),1);
% for i=1:numel(R)
%   if I(R(i)) == 0
%     I(R(i)) = C(i);
%   end
% end
% toc(tstart)
