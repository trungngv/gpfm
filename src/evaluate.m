function [mae,rmse,nDCG,err] = evaluate(T, fpred, k)
%EVALUATE [mae,rmse,ndcg,err] = evaluate(T, fpred, k)
%   
% Computes different error measurement metrics for the test observations
% and corresponding predicted values.
% 
% INPUT
%   - T : first column = userid, second column = itemid, last column =
%   observed ratings
%   - fpred : predicted ratings correspondng to the observations in T
%
% Trung Nguyen
% 10/12/13
mae = mean(abs(T(:,end) - fpred));
rmse = sqrt(mean((T(:,end) - fpred).^2));
nDCG = [];
nUsers = max(T(:,1));
err = [];
for userId=1:nUsers
  if ~any(T(:,1) == userId)
    continue;
  end
  index = T(:,1) == userId;
  nDCG = [nDCG; normalizedDCG(T(index, end), fpred(index), k)];
  err = [err; expectedReciprocalRank(T(index, end), fpred(index), k, max(T(:,end)))];
end
nDCG = mean(nDCG);
err = mean(err);
