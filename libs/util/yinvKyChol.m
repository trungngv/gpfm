function val = yinvKyChol(y, L)
%YINVKYCHOL val = yinvKyChol(y, L)
%   
% Computes y'K^{-1}y using Choleskey decomposition of K, i.e, L = chol(K).

% y K^{-1} y = y' Linv Linv' y
x = L'\y;   % (L')^{-1} y 
val = x'*x;
%val = y'*solve_chol(L,y);
end

