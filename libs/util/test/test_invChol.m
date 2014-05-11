function test_invChol(n)
% test for invChol with n = dimension of the square matrix
if isempty(n)
  n = 2;
end
A = rand(n,n);
K = A'*A;
%K = pascal(n);
L = jit_chol(K);
Kresult = invChol(L);
Kinv = inv(K);
disp('total difference:')
sum(sum(abs(Kinv - Kresult)))
end
