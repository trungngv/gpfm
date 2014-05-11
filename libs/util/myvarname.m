function out = myvarname(varargin)
%MYVARNAME out = myvarname(varargin)
%   Returns the string representing names of the variables
% 
% Trung Nguyen
if numel(varargin) > 1
  out = cell(numel(varargin),1);
  for i=1:numel(out)
    out{i} = inputname(i);
  end
else
  out = inputname(1);
end

