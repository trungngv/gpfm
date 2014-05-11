function test_traceABsym(N)
%TEST_TRACEABSYM test_traceABsym(N)
if nargin == 0
  N = 200;
end
A = rand(N); A = A + A.'; % make A symmetric
B = rand(N);
tic;
expected = trace(A*B);
fprintf('time using trace(A*B):   %f\n', toc);
tic;
result = traceAB(A,B);
fprintf('time using traceABsym(): %f\n', toc);
assert(abs(expected - result) < 1e-7, ...
  ['test traceABsym() failed with diff = ' num2str(abs(expected-result))]);
disp('test traceABsym() passed')


