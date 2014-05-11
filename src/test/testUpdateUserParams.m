function testUpdateUserParams()
%TESTUPDATEUSERPARAMS Test for updateUserParams()
%
% See also
%   updateUserParams

model = getTestData();
userId = 2;
u = getUserParams(userId, model);
newu = rand(size(u));
model = updateUserParams(userId, newu, model);
newuRes = getUserParams(userId, model);
assert(all(newu == newuRes), 'test updateUserParams() failed');
disp('test updateUserParams() passed')


