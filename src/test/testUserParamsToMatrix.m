function model = testUserParamsToMatrix()
%TESTUSERPARAMSTOMATRIX Test for userParamsToMatrix
%
%See also userParamsToMatrix
rng(100, 'twister')
model = getTestData(true);
userId = 1;
u = getUserParams(userId, model);
[Xres, index] = userParamsToMatrix(u, userId, model);
X = getUserData(userId, model);
assert(all(all(X == Xres)), 'test userParamsToMatrix() failed');
Xres = reshape(u(index),[],1);
assert(all(all(X(:) == Xres)), 'test userParamsToMatrix() failed');
disp('test userParamsToMatrix() passed')
