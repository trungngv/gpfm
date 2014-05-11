function testGetUserParams()
%TESTGETUSERPARAMS Test for getUserParams()
%
% See also
%   getUserParams

model = getTestData();
userId = 1;
V = model.V;
C1 = model.C{1};
C2 = model.C{2};
% user 1 observes item (1 and 2)
itemIds = [1,2];
u = V(itemIds,:);
u = u(:);
context1Ids = [1, 2];
context2Ids = [1, 2];
observedC1 = C1(context1Ids,:);
observedC2 = C2(context2Ids,:);
u = [u; observedC1(:); observedC2(:); model.hyp{userId}(:)];
uRes = getUserParams(userId, model);
assert(all(u == uRes), 'test getUserParams() failed');
disp('test getUserParams() passed');

