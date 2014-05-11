function ind = rowInd(matrixSize, row)
%ROWIND ind = rowInd(matrixSize, row)
%  Get indice of the given row from the matrix with specified size.
ind = sub2ind(matrixSize, row*ones(1,matrixSize(2)), 1:matrixSize(2));

