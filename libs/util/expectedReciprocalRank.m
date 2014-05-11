function err = expectedReciprocalRank(y,fpred,k,ymax)
%ERR  err = ERR(y,fpred)
% Computes ERR given the true and predicted ratings for the top-k list.  
if k > numel(y)
  k = numel(y);
end
y(y < 0) = 0; % for implicit feedback case
r = (2.^y - 1) / (2^ymax); % relevance
[~,pos] = sort(fpred, 'descend'); % ranked list
cul = zeros(k,1);
err = 0;
for i=1:k
  if i == 1
    cul(i) = 1;
  else
    cul(i) = cul(i-1)*(1-r(pos(i-1)));
  end
  err = err + (1/i)*cul(i)*r(pos(i));
end
end

