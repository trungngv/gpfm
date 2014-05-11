function testUnwrapUserParams()
%TESTUNBOXPARAMVEC testUnwrapUserParams()
%  Test for unwrapping the user parameters.
%
% See also unwrapUserParams
model = getTestData();
userId = 3;
u = getUserParams(userId, model);
[Xres, hypRes] = unwrapUserParams(u, userId, model);
X = userParamsToMatrix(u, userId, model);
hyp = model.hyp{3};
assert(all(all(Xres == X)));
assert(all(hypRes == hyp));
disp('test unwrapUserParams() passed');

