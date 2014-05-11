function c = toCategories(x, nCategories, ranges)
%TOCATEGORIES c = toCategories(x, nCategories, ranges)
%   
% Convert a vector of continous value x into categories.
% 
% Example: c = toCategories([0.1 0.9 0.2 0.8 0.3 0.5], 2, [0,0.5,1]);
% c = [1 2 1 2 1 2]
%
% Trung Nguyen
c = zeros(size(x));
for category=1:nCategories
  c(x >= ranges(category) & x < ranges(category + 1)) = category;
end

