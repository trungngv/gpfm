function testGetUserData()
%TESTGETUSERDATA testGetUserData()
%  Test for getUserData(). 
%
% See also
%   getUserData, getTestData
model = getTestData();
% test user id = 1
testUserId = 1;
X= [model.V(1,:), model.C{1}(1,:), model.C{2}(1,:);
    model.V(2,:), model.C{1}(2,:), model.C{2}(2,:)];
y = [5; 2];
[Xres, yres] = getUserData(testUserId, model);
assert(all(all(X == Xres)));
assert(all(y == yres));
disp('test getUserData() passed')
