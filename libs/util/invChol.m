function Kinv = invChol(L)
%KINV = INVCHOL(Linv)
% Computes K^{-1} from L where L is the cholesky decompotion of K,
% L = chol(K) or K = L'L
Linv = inv(L);
Kinv = Linv*Linv';
end
