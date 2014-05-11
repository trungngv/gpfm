function dumpVariables(f, names, varargin)
%DUMPVARIABLES(f, names, varargin)
% Dump variables with give names to the given file f. 
%
% INPUT:
%   - f : file to dump content to
%   - names : cell containing names of variables corresponding to varargin
%
% Trung Nguyen
fprintf(f, 'Dumping variables...\n');
fprintf(f, 'Execution time: %s\n', datestr(now));
for i=1:numel(varargin)
  var = varargin{i};
  if isstruct(var)
    fields = fieldnames(var);
    for j=1:numel(fields)
      dumpVariable(f, fields{j}, var.(fields{j}));
    end
  else
    dumpVariable(f, names{i}, var);
  end  
end
fprintf(f, '-----------------------------------------\n');

function dumpVariable(f, name, value)
  if isnumeric(value) || islogical(value)
    fprintf(f, '%s: %s\n', name, num2str(value));
  else
    fprintf(f, '%s: %s\n', name, value);
  end 

