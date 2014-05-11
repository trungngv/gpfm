function test_yinvKyChol(N)
%TEST_YINVKYCHOL test_yinvKyChol(N)
% See also
%   yinvKyChol
if nargin == 0
  N = 200;
end
A = rand(N, N);
K = A'*A;
y = rand(N, 1);
tic;
expected = y'*(K\y);
fprintf('normal computation:    %f seconds\n', toc);
tic;
result = yinvKyChol(y, jit_chol(K));
fprintf('efficient computation: %f seconds\n', toc);
assert(abs(expected - result) <= 1e-7, ...
    ['test yinvKyChol() failed with diff = ' num2str(abs(expected - result))]);
disp('test yinvKyChol() passed')


