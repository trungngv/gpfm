function testNestedSet()
%TESTNESTEDSET testNestedSet()
testData = [1     1    22
     2     2     9
     3    10    21
     4     3     8
     5     4     5
     6     6     7
     7    11    16
     8    17    18
     9    19    20
    10    12    13
    11    14    15];
expected = [1 2 2 3 4 4 3 3 3 4 4];
results = nestedSet(testData);
assert(all(expected(:) == results(:)));
disp('test nestedSet passed');
end

