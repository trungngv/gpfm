function regressionModelDesc()
%REGRESSIONMODELDESC regressionModelDesc()
%
disp('model.num_user = P: scalar, num users')
disp('model.num_item = N : scalar, num items')
disp('model.num_context = array(M)')
disp(' where model.num_context(k) = number of values for the k-th context')
disp('model.dim_item = D : scalar, latent dimension of items')
disp('model.dim_context = : array(M), latent dimensions of contexts')
disp(' where model.dim_context(k) = latent dimension of context k')

disp('model.T : N x D_all, where ')
disp('    N = total number of observation and each row is an observation, i.e. ')
disp('    model.T(t, :) = [user_id, item_id, context1_id, ..., contextK_id, rating]')
disp('    E.g.')
disp('    [  1,    2,        1,        4,   5,           3.5]')
disp('       ^     ^         ^         ^    ^             ^')
disp('    userid itemid  context1_id     context3_id    rating')

disp('model.V = array(P, D) : matrix of item latent features')
disp('model.C = cell(M) where ')
disp('   model.C{k} = array(num_context(k), dim_context(k)) is the')
disp('   matrix of latent features of context k')
disp('model.hyp = cell(P) where ')
disp('   model.hyp{i} = cov hyperparameters of user i')
disp('model.map = cell(P) where ')
disp('   model.map{i} = the index mapping from the user`s input matrix')
disp('   to the parameter vector u such that u(model.index{i}) = X(:)')
disp('model.testT : Ntest x D_all, same as model.T but for testing')
%** Need a script to convert other data into this format (user_id, item_id,
%contextk_id) must all start from 1 and be continuous.

end

