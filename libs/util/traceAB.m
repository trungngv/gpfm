function x = traceAB(A,B)
%TRACEAB x = traceAB(A,B)
%   
% Efficient computation for the trace of product of two matrices.
%
% Trung Nguyen
x = sum(sum(A.*B',2)); % sum(diagProd(A,B))
end
