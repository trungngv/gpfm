function ls = logsum(loga)
%LOGSUM ls = logsum(loga)
% Computes log(a_1 + ... + a_n) using log(a_1), ..., log(a_n).
% This is done using
% log(a_1 + ... + a_n) = log(a_max(a_1/a_max + ... + a_n/a_max))
%   = log(a_max) + log(1 + \sum_{i # max} exp(log(a_i)-log(a_max)
%   = log(a_max) + log(\sum_{i} exp(log(a_i)-log(a_max)))
% INPUT
%   - loga = [log(a_1) ... log(a_n)]
%
% OUTPUT
%   - log(a_1 + ... + a_n)
max_val = max(loga);
ls = max_val + log(sum(exp(loga-max_val)));
end

