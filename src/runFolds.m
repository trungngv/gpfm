function runFolds(datasetName, data, conf, opt, folds)
%RUNFOLDS runFolds(datasetName, data, conf, opt, folds)
% 
% INPUT:
%   - datasetName : one of 'comoda', 'food', 'sushi', or 'adom'
%   - data : full data (should be the return value of one of
%       'loadXXX' function where XXX is the name of a dataset
%   - conf : general configuration (see for an example) of the model
%   - opt : optimization options
%   - folds : number of folds to run (default = 5)
%
% 10/12/13
% Trung Nguyen
if nargin == 4
  folds = 5;
end
% also make prediction whenever we decay the learning rate 
predictInterval = opt.decayInterval;
f = fopen(['tmp/' datasetName '/' datasetName '-' datestr(now, 30), '.txt'],'w');
dumpVariables(f, {'folds', 'conf', 'opt'}, folds, conf, opt);
nIntervals = ceil(opt.epochs/predictInterval);
% errors{i} = error after (50*i) iterations
errors = cell(nIntervals,1);
for interval=1:nIntervals
  errors{interval} = zeros(folds, 6);
end  
opt.epochs = predictInterval;
initialLearnRate = opt.learnRate;
for fold=1:folds
  % restore learnRate for every new dataset
  opt.learnRate = initialLearnRate;
  tic;
  %[train, test] = getFold(data, folds, fold);
  [train, test] = loadFold(datasetName, fold);
  model = initModel(train, test, conf);
  % training
  disp(['running fold ', num2str(fold)])
  fprintf(f, 'fold %d\n', fold);
  for interval=1:nIntervals
    model = sgdLearn(model, opt);
    intervalError = predictAtInterval(model,conf);
    errors{interval}(fold,:) = intervalError;
    fprintf('iter %d: \n', predictInterval*interval);
    fprintf('mae \t const mae \t rmse \t const rmse \t NDCG \t ERR\n')
    disp(intervalError);
    fprintf(f, 'iter %d: \n', predictInterval*interval);
    fprintf(f, 'mae \t\tconst mae \t\trmse \t\tconst rmse \t\t ndcg \t\t err \n');
    fprintf(f, '%f\t%f\t%f\t%f\t%f\t%f\n', intervalError);
    opt.learnRate = opt.learnRate / opt.decay;
  end  
  fprintf(f, 'objectives: \n');
  fprintf(f, '%f\n', model.objectives);
  fprintf(f, 'running time: %f seconds\n', toc);
  fprintf(f, '------------------------------------\n');
end
fprintf(f, 'summary: \n');
for interval=1:nIntervals
  fprintf(f, 'iter %d: \n', predictInterval*interval);
  fprintf(f, 'mae \tconst mae \trmse \tconst rmse \t\t ndcg \t\t err\n');
  fprintf(f, '%f\t%f\t%f\t%f\t%f\t%f\n', errors{interval}');
  fprintf(f, 'mean \n');
  fprintf(f, '%f\t%f\t%f\t%f\t%f\t%f\n', mean(errors{interval}));
end
fclose(f);

% make prediction and compute errors
function errors = predictAtInterval(model,conf)
  notrainCount = 0;
  testUserIds = unique(model.testT(:,1));
  fmeans = [];
  ytrue = [];
  nDCG = [];
  ERR = [];
  constErrors = [];
  for i=1:numel(testUserIds)
    userId = testUserIds(i);
    if ~any(model.T(:,1) == userId)
      notrainCount = notrainCount + sum(model.testT(:,1) == userId);
      continue;
    end
    trainObservations = model.T(:,1) == userId;
    testObservations = model.testT(:,1) == userId;
    fmean = predict(userId, model, model.testT);
    fmeans = [fmeans; fmean];
    ytrue_i = model.testT(testObservations,end);
    nDCG = [nDCG; normalizedDCG(ytrue_i,fmean,conf.topk)];
    ERR = [ERR; expectedReciprocalRank(ytrue_i, fmean,conf.topk,max(model.testT(:,end)))];
    ytrue = [ytrue; ytrue_i];
    ymean = mean(model.T(trainObservations, end));
    constErrors = [constErrors; abs(ymean - ytrue_i)];
  end
  errors = [mean(abs(fmeans - ytrue)), mean(constErrors), ...
    sqrt(mean((fmeans-ytrue).^2)), sqrt(mean(constErrors.^2)), mean(nDCG), mean(ERR)];
  fprintf('no training count : %d\n', notrainCount);
  fprintf('total test count: %d\n', size(model.testT,1));
  
