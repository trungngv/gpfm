function d = diagProd(A, B)
%D = DIAGPROD(A,B)
% Efficient computation of d = diag(A*B) where A is n x m and B is m x n.
[n, m] = size(A);
At = A';
d = At(:) .* B(:);
D = reshape(d, m, n);
d = sum(D,1)'; 
end
