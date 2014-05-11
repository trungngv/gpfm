function A = setDiag(A,v)
%SETDIAG A = setDiag(A,v)
%   
% Set the diagonal of the matrix A to the vector v.
[m,n] = size(A);
A(1:(m+1):m*n) = v;
end

