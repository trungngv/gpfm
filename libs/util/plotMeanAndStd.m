function plotMeanAndStd(x, fmean, fstd, color)
%plotMeanAndStd plotMeanAndStd(x, fmean, fstd, color)
%   Plots a curve for the function f(x) given by fmean together with the
%   standard deviation around the mean given by fstd.
%
%   This will plot on the currently selected figure.
%
% INPUT
%   - x : input values (typically some range)
%   - fmean : the value of functions at x
%   - fstd : one standard deviation
%   - color
%
% Trung V. Nguyen
% 18/01/13
x = x(:); fmean = fmean(:); fstd = fstd(:);
fbelow = fmean - fstd;
fabove = flipdim(fmean, 1) + flipdim(fstd, 1);
fill([x; flipdim(x, 1)], [fbelow; fabove], color);
hold on;
plot(x, fmean);
end

