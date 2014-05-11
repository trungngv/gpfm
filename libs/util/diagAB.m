function C = diagAB(A,B)
%DIAGAB  C = diagAB(A,B)
%   
% Efficient computation of C = A*B where A is a diagonal matrix without
% using matrix multiplication.
%
% Trung Nguyen
% 07/01/2014
if size(A,2) == 1 % diag(A) is given
  C = repmat(A,1,size(A,1)).*B;
else
  C = repmat(diag(A),1,size(A,1)).*B;
end
end

