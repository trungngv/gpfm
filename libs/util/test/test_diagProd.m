function test_diagProd(n, m)
% test for the function DIAGPROD with dimensions n x m
A = rand(n, m);
B = rand(m, n);
tic;
expected = diag(A*B);
disp(['time by diag(A*B): ', num2str(toc)])
tic;
result = diagProd(A,B);
disp(['time by diagProd: ', num2str(toc)])
disp('total difference') 
sum(abs(expected-result))
end
