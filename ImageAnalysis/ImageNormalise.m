function out = ImageNormalise( in , varargin )
%% Normalises Image data.
%
% out = ImageRescale( in , gamma )
%
% Input parameters (required):
%
% in  : Input signal.
%
% Input parameters (parameters):
%
% Parameters are either struct with the following fields and corresponding
% values or option/value pairs, where the option is specified as a string.
%
% -
%
% Input parameters (optional):
%
% The number of optional parameters is always at most one. If a function takes
% an optional parameter, it does not take any other parameters.
%
% gamma : exponential correction factor. (default = 1).
%
% Output parameters:
%
% out : Image with to normalised range.
%
% Output parameters (optional):
%
% -
%
% Description:
%
% Changes the range of the image data in a linear way with a possible gamma
% correction to [0,1]. Note that passing vectors for the range is allowed. Then,
% a channelwise transform will be attempted.
%
% Example:
%
% -
%
% See also

% Copyright 2012, 2013 Laurent Hoeltgen <laurent.hoeltgen@gmail.com>
%
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
% Street, Fifth Floor, Boston, MA 02110-1301, USA.

% Last revision on: 04.02.2013 21:32

%% Parse input and output.

narginchk(1,2);
nargoutchk(0,1);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('in', @(x) validateattributes( x, {'numeric'}, ...
    {'2d', 'finite', 'nonempty', 'nonnan', 'nonsparse'}, ...
    mfilename, 'in', 1) );

parser.addOptional('gamma', 1.0, @(x) validateattributes( x, {'numeric'}, ...
    {'scalar', 'finite', 'nonempty', 'nonnan'}, ...
    mfilename, 'gamma', 2) );

parser.parse(in, varargin{:});
opts = parser.Results;

%% Run code.

out = ImageRescale(in, 0, 1, opts.gamma);

end
