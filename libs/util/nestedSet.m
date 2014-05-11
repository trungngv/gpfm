function levels = nestedSet(indice)
%NESTEDSET levels = nestedSetDepth(indice)
% Find the depth/levels of nodes in the nested set given in indice(id,left,right)
%
% Trung Nguyen
ids = indice(:,1); left = indice(:,2); right = indice(:,3);
notMarked = ones(size(ids));
cnt = 0; depth = 1; leftMost = 1;
levels = zeros(size(ids));
while cnt < numel(ids)
  while cnt < numel(ids)
    idxMin = find(notMarked & left >= leftMost,1);
    if isempty(idxMin),
      leftMost = 1;
      break;
    end
    levels(idxMin) = depth;
    cnt = cnt + 1;
    notMarked(idxMin) = 0;
    leftMost = right(idxMin);
  end  
  depth = depth + 1;
end

