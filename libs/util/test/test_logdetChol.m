function test_logdetChol()
%TEST_LOGDETCHOL test_logdetChol()
%  Test for logdetChol.
%
% See also
%   logdetChol
A = rand(100, 100);
K = A'*A;
expected = log(det(K));
result = logdetChol(jit_chol(K));
assert(abs(expected - result) <= 1e-10, ...
    ['test failed with diff = ' num2str(abs(expected - result))]);
disp('test logdetChol() passed')