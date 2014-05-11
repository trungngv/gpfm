function log_to_file(fid, varargin)
%LOG_TO_FILE log_to_file(fid, varargin)
%
%  Logs all pairs of names and values in varargin to a given file. If a
%  variable with name 'runtime' is passed in, it will be printed to the
%  file using date time format.
%
% Trung V. Nguyen
% 19/11/12
for i=1:numel(varargin)
  if islogical(varargin{i}) || isinteger(varargin{i})
    fprintf(fid, '\n%s:\t %d', inputname(1+i), varargin{i});
  elseif isa(varargin{i}, 'function_handle')
    fprintf(fid, '\n%s:\t %s', inputname(1+i), func2str(varargin{i}));
  elseif strcmp(inputname(1+i), 'runtime')
    fprintf(fid, '\n%s:\t %s', inputname(1+i), datestr(varargin{i}));
  elseif isnumeric(varargin{i})
    fprintf(fid, '\n%s:\t %.5f', inputname(1+i), varargin{i});
  else
    fprintf(fid, '\n%s:\t %s', inputname(1+i), varargin{i});
  end  
end
end

