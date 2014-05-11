% LOAD_DATA [X, y, Xtest, ytest] = load_data(basedir, basefile)
%
% Load the training data and test data from the specified file and
% directory. This loads the data that was saved using save_data(...).
%
% INPUT
%   - basedir : path to the directory containing the input files
%   - basefile : dataset name, which is concatenated with
%   '_train_data.asc', 'train_labels.asc', '_test_data.asc',
%   '_test_labels.asc' to get the training inputs, outputs, test inputs,
%   and test outputs, respectively.
%
% OUTPUT
%    - X, y : training inputs and outputs (size N x d) and (N x p) where N
%    is the number of points, d = input dimension, p = output dimension
%    - Xtest, ytest : similar to X, y but for test points
%
% Trung V. Nguyen
% May 2012
%
function [X, y, Xtest, ytest] = load_data(basedir, basefile)
  basepath = [basedir filesep basefile];
  X = load([basepath '_train_data.asc']);
  y = load([basepath '_train_labels.asc']);
  Xtest = load([basepath '_test_data.asc']);
  ytest = load([basepath '_test_labels.asc']);
end