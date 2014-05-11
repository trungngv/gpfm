function v = findRows(A,r)
%FINDROWS v = findRows(A,r)
%  Find indice of all rows in A that equals r 
v = sum(A == repmat(r,size(A,1),1),2) == numel(r);
end
