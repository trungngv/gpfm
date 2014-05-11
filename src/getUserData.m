function [X, y] = getUserData(userId, model, T)
%GETUSERDATA [X, y] = getUserData(userId, model)
% Get the data (input and output) of userId corresponding to the
% observations in T. If T is not given or empty, model.T will be used.
%
% This can be used, for example, to get the inputs of the test cases after
% the model is learned.
%
% INPUT:
%   - userId : id of the user
%   - model : the model storing current parameters
%   - T : matrix describe the observations
%   
% OUTPUT
%   - X : matrix of latent features for user (inputs)
%   - y : ratings (outputs)
%
% 08/10/13
% Trung Nguyen
if (nargin == 2 || isempty(T))
  T = model.T;
end
% T(i,:) = [userId, itemId, context1Id, ..., contextMId, rating]
rows = find(T(:,1) == userId);   % all observations for userId
M = numel(model.num_context);   % number of contexts
y = T(rows,end);
X = model.V(T(rows,2),:);
for k=1:M
  X = [X, model.C{k}(T(rows,2+k),:)];
end


