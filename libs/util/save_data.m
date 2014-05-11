function save_data(X, y, Xtest, ytest, basedir, basefile)
% function save_data(X, y, Xtest, ytest, basedir, basefile)
%
% Save the training data (X, y) and testing data (Xtest, yTest) in a
% directory specified by basedir/basefileX.
%
% The variables are saved into four seperate files whose names are
% basefile_train_data.mat, basefile_train_labels_data.mat,
% basefile_test_data.mat, basefile_test_labels.mat for X, y, XTest, yTest
% respectively.
%
% See also: loadData(basedir, basefile)
%
% Trung Nguyen
% May 2012
%
  if ~exist(basedir,'dir')
    mkdir(basedir);
  end  
  basepath = [basedir filesep basefile];
  save([basepath '_train_data.asc'], 'X', '-ascii');
  save([basepath '_train_labels.asc'], 'y', '-ascii');
  save([basepath '_test_data.asc'], 'Xtest', '-ascii');
  save([basepath '_test_labels.asc'], 'ytest', '-ascii');
  disp(['Data saved to directory ' basedir]);
end