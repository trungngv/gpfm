% Demo for pairwise regression 
% 14/01/14
% Trung Nguyen

clear;
conf.sigmaNoise = 0.1;
conf.kernel = 'rbf';          % the kernel to use ('rbf','linear',or'linearOne') 
                              % but 'rbf' seems superior to the other two
conf.useBias = false;         % do we want to use bias?
conf.latentStd = 1e-4;        % standard deviation to initiliaze values of latent variables
conf.dimItem = 1;             % latent dimension of item
conf.dimContext = ones(2,1);  % latent dimensions of contexts (one dimension for each context)

% optimisation and other options
opt.displayObjectives = true; % display the objective value?
opt.monitorConvergence = 100; % how often to display?
opt.epochs = 5;              % maximum number of epochs to run
opt.momentum = 0.9;           % momentum for Stochastic gradient descent
opt.learnRate = 5e-4;         % learning rate

% item-based observation matrix (like in gpfm)
% it is not used for training but for making prediction 
train = load('data/demo_pw_item.csv');
% item-based observation matrix for testing (also like in gpfm)
test = load('data/demo_pw_test.csv');
% pairwise-based observation matrix
pairTrain = load('data/demo_pw_train.csv');
pairTrain(:,end) = pairTrain(:,end)*2;

% init a gppw model
model = gppwInitModel(pairTrain, train, test, conf);
% training
model = gppwSgdLearn(model, opt);
% making prediction
topk = 10;
[evaluation,fpred] = rPredictAll(model,test);
% some ranking scores
[map,mp,ndcg,err] = computeRankingScores(model.T, model.testT, fpred, topk);
evaluation = [evaluation(1:2), ndcg, err, map, mp];
fprintf('mae \t rmse \t ndcg \t err \t map \t mp\n');
fprintf('%.4f\t%.4f\t%.4f\t%.4f\t%.4f\t%.4f\n', evaluation);


 