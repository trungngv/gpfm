fEvalTimeSingle = 1.5; % default: 0.5
% keep the inter-communication overhead low.
% use K / numcores
settings.nrOfEvalsAtOnce = 3; % default: 4
% times the expected maximum execution time.
% use fvalTimeSingle*(nrOfEvalsAtOnce-1)?
settings.maxEvalTimeSingle = min(fEvalTimeSingle * 2, 3);

K = 10;
N = 350;
pars = cell(K,1);
for k=1:K
  pars{k} = rand(N,N);
end
tstart = tic;
resultCell = startmulticoremaster(@dummy,pars,settings);
toc(tstart)
disp('parallize')

resultCell = cell(size(pars));
tstart = tic;
for k=1:numel(pars)
  resultCell{k} = dummy(pars{k});
end
toc(tstart)
disp('batch')
