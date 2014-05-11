function [evaluation,fpred,model] = runGPFM(model,outputDirectory, prefix, train, test, conf, opt)
%RUNGPFM runGPFM(outputDirectory,prefix train, test, conf, opt)
% 
% INPUT:
%   - outputDirectory : directory to store the log and results
%   - prefix : prefix to use in the auto-generated result file name
%   (usually name of the dataset) (can be [])
%   - train, test : training and testing data 
%   - conf : general configuration (see demoAdom for an example) of the model
%   - opt : optimization options
%
% OUTPUT:
%   - model : [] or a previously saved model
%   - mae : mean absolute error
%   - rmse : root mean square error
%   - fpred : prediction (same order as test)
%
% 15/01/14
% Trung Nguyen
predictInterval = opt.decayInterval;
f = fopen([outputDirectory '/' prefix '-' datestr(now, 30), '.txt'],'w');
dumpVariables(f, {'conf', 'opt'}, conf, opt);
nIntervals = ceil(opt.epochs/predictInterval);
% errors{i} = error after (50*i) iterations
errors = zeros(nIntervals,6);
opt.epochs = predictInterval;
if isempty(model)
  disp('initing model')
  model = initModel(train, test, conf);
end  
tic;
% training
disp('begin training')
for interval=1:nIntervals
  model = sgdLearn(model, opt);
  [intervalError,fpred] = rPredictAll(model,[]);
  [map,mp, ndcg, err] = computeRankingScores(model.T, model.testT, fpred, 10);
  errors(interval,:) = intervalError;
  fprintf('iter %d: \n', predictInterval*interval);
  fprintf('mae \t rmse \t ndcg\t err@k \t ndcg \t err \t map@k \t mp@k \tconst mae \tconst rmse\n');
  fprintf('%.4f\t %.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f\n', ...
    [intervalError(1:end-2), ndcg, err, map, mp, intervalError(end-1:end)]);
  
  fprintf(f, 'iter %d: \n', predictInterval*interval);
  fprintf(f, 'mae \t rmse \t ndcg@k \t err@k \t ndcg \t err \t map@k \t mp@k \tconst mae \tconst rmse\n');
  fprintf(f, '%.4f\t %.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f \t%.4f\n', ...
    [intervalError(1:end-2), ndcg, err, map, mp, intervalError(end-1:end)]);
end  
fprintf(f, 'objectives: \n');
fprintf(f, '%f\n', model.objectives);
fprintf(f, 'running time: %f seconds\n', toc);
fprintf(f, '------------------------------------\n');
fclose(f);
evaluation = errors(nIntervals,:);
