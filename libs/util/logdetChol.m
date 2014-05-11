function logdet = logdetChol(L)
%LOGDET = logdetChol(L)
% Computes log(det(K)) given its cholesky decompostion L = chol(K),
% log(det(K)) = log(det(L)*det(L)) = 2log(det(L)) = 2*sum(log(diag(L)))
logdet = 2*sum(log(diag(L)));
end
