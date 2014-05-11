function testWrapToVec()
%TESTWRAPTOVEC testWrapTovec()
% Test for wrapping params vector.
%
% See also wrapToVec, unwrapVec
X = rand(4,2);
hyp = rand(3,1);
ures = wrapToVec(X, hyp);
u = [X(:); hyp(:)];
assert(all(u == ures));
disp('test wrapToVec() passed')

