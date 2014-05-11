function shapes = markers(n)
%MARKERS shapes = markers(n)
%   MARKERS(n) returns a set of markers that can be used in plotting.
%   Maximum number of distinct shapes is 14. If n > 14 the shapes will be
%   recycled.
%
% INPUT
%   - n : the number of markers
%
% OUTPUT
%   - set of markers as a cell
%
% Trung V. Nguyen
% 25/01/13
builtinShapes = {'s','d','x','v','o','*','+','^','.','<','>','p','h'};
nShapes = numel(builtinShapes);
shapes = cell(n,1);
for i=1:n
  if mod(i,nShapes) == 0
    shapes{i} = builtinShapes{nShapes};
  else
    shapes{i} = builtinShapes{mod(i,nShapes)};
  end  
end
end

