function [hb,he]=mybarweb(barvalues, errors, bw_legend, groupnames,...
    width, bw_colormap,basevalue )

%
% [hb,he]=mybarweb(barvalues, errors, bw_legend, groupnames, width,bw_colormap,basevalue )
%
% barweb is the m-by-n matrix of barvalues to be plotted.  barweb calls the
% MATLAB bar function and plots m groups of n bars using the width and
% bw_colormap parameters.  If you want all the bars to be the same color,
% then set bw_colormap equal to the RBG matrix value ie. (bw_colormap = [1
% 0 0] for all red bars) barweb then calls the MATLAB errorbar function to
% draw barvalues with error bars of length error.  The errors matrix is of
% the same form of the barvalues matrix, namely m group of n errors.  No
% legend will be shown if the legend paramter is not provided
%
% See the MATLAB functions bar and errorbar for more information
%
% [hb,he]=barweb(...) will give handle HB to the bars and HE to the errorbars. 
%
% Author: Bolu Ajiboye
% Created: October 18, 2005 (ver 1.0)
% Updated: April 22, 2006 (ver 2.0)
%
% Modified by Quentin Huys November 2006

% Get function arguments
if nargin < 2
	error('Must have at least the first two arguments:  barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend)');
elseif nargin == 2
  groupnames = [];
	width = .8;
	bw_legend=[];
	bw_colormap = [];
elseif nargin == 3
	width = 1;
	bw_colormap = [];
  groupnames = [];
elseif nargin == 4
	bw_colormap = [];
  groupnames = [];
end

change_axis = 0;

if size(barvalues,1) ~= size(errors,1) || size(barvalues,2) ~= size(errors,2)
	error('barvalues and errors matrix must be of same dimension');
else
	if size(barvalues,2) == 1
		barvalues = barvalues';
		errors = errors';
	end
	if size(barvalues,1) == 1
		barvalues = [barvalues; zeros(1,length(barvalues))];
		errors = [errors; zeros(1,length(barvalues))];
		change_axis = 1;
	end
	numgroups = size(barvalues, 1); % number of groups
	numbars = size(barvalues, 2); % number of bars in a group
	if isempty(width)
		width = 1;
	end

	% Plot bars and errors
    if ~isempty(basevalue)
      hb=bar(barvalues, width,'BaseValue',basevalue);   
    else
      hb=bar(barvalues, width);   
    end
	
	hold on;

	if length(bw_colormap)
		colormap(bw_colormap);
	else
	%	colormap(jet);
	end
	groupwidth = min(0.8, numbars/(numbars+1.5));
	he=[];
	for i = 1:numbars
		x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
		th=errorbar(x, barvalues(:,i), errors(:,i), 'k', 'linestyle', 'none');
		he=[he;th];
  end
	xlim([0.5 numgroups-change_axis+0.5]);
  set(gca, 'xticklabel', groupnames, 'ticklength', [0 0], 'xtick',1:numgroups, 'linewidth', 1,'xgrid','off','ygrid','on');

	if ~isempty(bw_legend)
		legend(hb, bw_legend, 'location', 'best', 'fontsize',12);
		legend boxoff;
	end

	hold off;
end

return
