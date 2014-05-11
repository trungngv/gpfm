function testToLatentAndBias()
%TESTTOLATENTANDBIAS testToLatentAndBias()
N = 5;
dimItem = 3; % 2 for latent + 1 for bias
dimContext = [4,5]; % 1 for bias + rest for latents
m.num_context = [2,2];
Xbias = rand(N,3);
Xlatent = rand(N,dimItem + sum(dimContext) - 3);
X = [Xbias(:,1),Xlatent(:,1:2),Xbias(:,2),Xlatent(:,3:5),Xbias(:,3),Xlatent(:,6:end)];
[expectedXlatent, expectedXbias] = toLatentAndBias(X,[dimItem,dimContext]);
assert(all(expectedXlatent(:) == Xlatent(:)), 'test toLatentAndBias() failed');
assert(all(expectedXbias(:) == Xbias(:)), 'test toLatentAndBias() failed');
disp('test toLatentAndBias() passed');
end

