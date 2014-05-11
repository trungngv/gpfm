function nDCG = normalizedDCG(y,fpred,k)
%NORMALIZEDDCG normalizedDCG = normalizedDCG(y,fpred,k)
%   
% Computes the normalized discounted cumulative gain (NDCG):
%   ndcg(y) = dcg@k(y,fpred)/dcg@k(y,y)
% where
%   dcg@k(y,fpred) = \sum_i=1^k 2^y'_i - 1 / log(2+i)
% with y' being the permutation of y corresponding to sorted fpred.
%
% Trung Nguyen
% 10/12/13
if numel(y) < k
  k = numel(y);
end
y(y < 0) = 0;
[~,pi] = sort(fpred, 'descend');
dcg_f = sum((2.^y(pi(1:k)) - 1)./ log(2+(1:k)'));
[~,pi] = sort(y, 'descend');
dcg_y = sum((2.^y(pi(1:k)) - 1)./ log(2+(1:k))');
nDCG = dcg_f / dcg_y;
% rare case when numel(y) == 1 and y = 0
if dcg_y == 0
  nDCG = 1;
end
end

