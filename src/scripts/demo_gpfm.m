% DEMO with gpfm 
% 04/11/13
% Trung Nguyen

clear;
conf.kernel = 'rbf';
conf.useBias = false;
conf.sigmaNoise = 1;
conf.latentStd = 1e-1; % standard deviation of latent variables
conf.dimItem = 1;
conf.dimContext = ones(2,1);

opt.monitorConvergence = 200;
opt.displayObjectives = true;
opt.epochs = 20;
opt.momentum = 0.9;
opt.learnRate = 5e-4;
opt.decay = 1;
opt.decayInterval = 5;

train = load('demo_train.csv');
test = load('demo_test.csv');
% init model
model = initModel(train, test, conf);
% training
model = sgdLearn(model, opt);
% making prediction
[evaluation,fpred] = rPredictAll(model,test);
evaluation = evaluation(1:2);
fprintf('mae \t rmse \n');
fprintf('%.4f\t%.4f\n', evaluation);
