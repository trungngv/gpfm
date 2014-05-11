function testFromLatentAndBias()
%TESTFROMLATENTANDBIAS testFromLatentAndBias()
N = 5;
dimItem = 3; % 2 for latent + 1 for bias
dimContext = [4,5]; % 1 for bias + rest for latents
Xbias = rand(N,3);
Xlatent = rand(N,dimItem + sum(dimContext) - 3);
expected = [Xbias(:,1),Xlatent(:,1:2),Xbias(:,2),Xlatent(:,3:5),Xbias(:,3),Xlatent(:,6:end)];
expected = expected(:);
result = fromLatentAndBias(Xlatent,Xbias,[dimItem,dimContext]);
assert(all(expected == result), 'test FromLatentAndBias() failed');
disp('test fromLatentAndBias() passed');
end

