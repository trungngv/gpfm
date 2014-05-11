function test_traceAb(N)
%TEST_TRACEAB test_traceAb(N)
%   
if nargin == 0
  N = 200;
end
A = rand(N,N);
j = ceil(N*rand);
b = rand(N,1);
B = zeros(N,N);
B(:,j) = b;
B(j,:) = b';
tic;
expected = trace(A*B);
fprintf('normal execution time:    %f secs\n', toc);
tic
result = traceAb(A,b,j);
fprintf('traceAb() execution time: %f secs\n', toc);
assert(abs(expected-result) < 1e-10, 'test traceAb() failed');
disp('test traceAb() passed');

