%%
dist = [0.25 0.4 0.25 0.1];
nz = 5000;
[N K] = size(dist);
Z = zeros(nz,N);
prob = dist ./ repmat(sum(dist,2),1,K);
cumprob = [zeros(N,1), cumsum(prob,2)];
for inz=1:nz
  nsamples = rand(N,1);
  Z(inz,:) = rowfind(cumprob>repmat(nsamples,1,K+1))-1;
end
figure;
hist(Z)
