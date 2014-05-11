function A = sampleIrrelevantForUser(T,u,n)
%SAMPLEIRRELEVANT A = sampleIrrelevantForUser(T,u,n)
%   
% Given the observations, sample n irrelevant observations for user u. The
% irrelevant observations have rating 0 and are of course distinctive
% from the observed/rated set.
% 
% We are talking about observations because an observation is composed of
% an item and the context.
%
% INPUT
%   - T : the observations matrix
%   - u : the user to sample for 
%   - n : the number of samples
% OUTPUT
%   - the sample matrix
%
D = size(T,2)-2; % ignore first column (user id) and last colum (rating)
A = zeros(n,D);
maxVals = max(T(:,2:end-1));
for i=1:n
  while true
    A(i,:) = ceil(maxVals(1:D).*rand(1,D));
    if ~isRow(T(T(:,1)==u,2:end-1),A(1:i-1,:),A(i,:))
      break
    end
  end  
end
% augment user id
A = [repmat(u,n,1), A, zeros(n,1)];
end

% true if r is a row in A or B
function v = isRow(A,B,r)
C = [A;B];
v = any(sum(C == repmat(r,size(C,1),1),2) == numel(r));
end
