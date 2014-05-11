function testUnwrapVec()
%TESTUNWRAPVEC testUnwrapVec()
%  Test for unwrapping vector to params.
% 10/10/13
X = rand(4,2);
hyp = rand(3,1);
u = wrapToVec(X, hyp);
[Xres, hypRes] = unwrapVec(u, 4);
assert(all(all(Xres == X)));
assert(all(hypRes == hyp));
disp('test unwrapVec() passed');

