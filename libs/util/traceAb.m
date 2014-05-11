function tr = traceAb(A,b,j)
%TRACEAB tr = traceAb(A,b,j)
%   
% Efficient computation for trace(A*B) where B is symmetric, the j-th
% column of B is given by b (hence j-th row is b'), and the rest are 0.
%
% Trung Nguyen
% 05/11/13
b = b(:); % make sure b in column
tr = A(j,:)*b + A(:,j)'*b - A(j,j)*b(j);
%tr = 2*A(j,:)*b - A(j,j)*b(j); %if A is symmetric
