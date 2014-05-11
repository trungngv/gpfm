function x = traceABsym(A,B)
%TRACEABSYM x = traceABsym(A,B)
%   
% Efficient computation for the trace of product of two matrices when at
% least one of them is symmetric.
%
% Trung Nguyen
x = A(:).'*B(:);
end

