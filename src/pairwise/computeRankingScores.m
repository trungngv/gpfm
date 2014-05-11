function [MAP,MP,NDCG,ERR] = computeRankingScores(trainT, testT, fpred, k)
%COMPUTERANKINGSCORES  [MAP,MP,NDCG,ERR] = computeRankingScores(trainT, testT, fpred, k)
%   
% Compute the ranking scores MAP@k, P@k, NDCG@k, and ERR@k.
% 
% Note that this function is implemented specifically for context-aware
% evaluation: the scores are average across user | context, not average
% across users.
%
% Trung Nguyen
% 25/01/14

testUserIds = unique(testT(:,1));
MAP = []; MP = []; NDCG = []; ERR = [];
maxRating = max(testT(:,end));
for i=1:numel(testUserIds)
  userId = testUserIds(i);
  if ~any(trainT(:,1) == userId),       continue;    end
% This for MAP of user | context but too few items to use this measure  
  indice = find(testT(:,1)==i);
  R = testT(indice,:);
  uniqueContexts = unique(R(:,3:end-1),'rows');
  for j=1:size(uniqueContexts,1)
    % careful: the indince of items here are in R, not in the testT
    itemsInR = find(findRows(R(:,3:end-1),uniqueContexts(j,:)));
    ratings = R(itemsInR,end);
    actual = find(ratings == 1); % order of relevant items does not matter
    if (numel(actual) == 0) % no relevant item so no ranking to do
      continue;
    end
    fmean = fpred(indice(itemsInR));
    NDCG = [NDCG; normalizedDCG(testT(indice(itemsInR),end), fmean, k)];
    ERR = [ERR; expectedReciprocalRank(testT(indice(itemsInR),end), fmean, k, maxRating)];
    [~, prediction] = sort(fmean, 'descend');
    MAP = [MAP; averagePrecisionAtK(actual, prediction(1:length(actual)), k)];
    MP = [MP; precisionAtK(actual,prediction,k)];
  end
%   ratings = testT(testT(:,1)==userId,end);
%   fmean = fpred(testT(:,1)==userId);
%   actual = find(ratings == 1); % order of relevant items does not matter
%   if numel(actual) == 0
%     cnt = cnt + 1;
%     continue;
%   end
%   [~, prediction] = sort(fmean, 'descend');
%   map = [map; averagePrecisionAtK(actual, prediction(1:length(actual)), k)];
%   mp = [mp; precisionAtK(actual,prediction,k)];
  %map = [map; averagePrecisionAtK(actual, prediction, length(actual))];
end
MAP = mean(MAP);
MP = mean(MP);
NDCG = mean(NDCG);
ERR = mean(ERR);
end

function pk = precisionAtK(actual,prediction,k)
  if length(prediction) < k
    k = length(prediction);
  end
  pk = numel(intersect(actual,prediction(1:k)))/k;
end

