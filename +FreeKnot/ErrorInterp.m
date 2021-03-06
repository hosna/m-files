function [eG eL] = ErrorInterp( f, x, varargin )
%% Computes error commited by piecewise linear interpolation.
%
% [eG eL] = ErrorInterp( f, x, ... )
%
% Input parameters (required):
%
% f : The function to be interpolated. Must be able to take an array as
%     argument. If the passed argument is an array, the method operates in the
%     discrete setting. (function handle or array)
% x : a vector of knot positions at which the interpolation should be carried
%     out. (array)
%
% Input parameters (parameters):
%
% Parameters are either struct with the following fields and corresponding
% values or option/value pairs, where the option is specified as a string.
%
% min : Lower bound of the interval to be considered. (scalar, default = x(1))
% max : Upper bound of the interval to be considered. (scalar, default = x(end))
%
% Input parameters (optional):
%
% The number of optional parameters is always at most one. If a function takes
% an optional parameter, it does not take any other parameters.
%
% -
%
% Output parameters:
%
% eG : Global error committed over the whole interpolation domain (scalar)
% eL : Local error committed between two knots specified by the input x. The sum
%      of the local errors corresponds to the global error eG. (array)
%
% Output parameters (optional):
%
% -
%
% Description:
%
% Computes the L1 error between a strictly convex function and piecewise linear
% splines.
%
% Example:
%
% x = [-1 0 1];
% f = @(x) x.^2;
% [eG eL] = FreeKnot.ErrorInterp(f, x)
%
% See also quad

% Copyright 2011, 2012 Laurent Hoeltgen <laurent.hoeltgen@gmail.com>
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

% Last revision: 30.12.2012 11:00

%% Notes

%% Parse input and output.

narginchk(2, 8);
nargoutchk(0, 2);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('f', @(x) validateattributes(x, ...
    {'function_handle', 'numeric'}, {'vector'}, mfilename, 'f'));

parser.addRequired('x', @(x) validateattributes(x, {'numeric'} , {'vector'}, ...
    mfilename, 'x'));

parser.addParamValue('min', x(1), @(x) validateattributes(x, {'numeric'}, ...
    {'scalar', 'real', 'finite'}, mfilename, 'min'));

parser.addParamValue('max', x(end), @(x) validateattributes(x, {'numeric'}, ...
    {'scalar', 'real', 'finite'}, mfilename, 'max'));

parser.parse( f, x, varargin{:});
opts = parser.Results;

diffx = diff(x);
if any(diffx <= 0)
    MExc = ExceptionMessage('Input', 'message', ...
        ['Knot sequence must be strictly monotonically increasing.' ...
        'Performing a sorting on x.']);
    warning(MExc.id, MExc.message);
    x = sort(x);
end

if ~isequal(x, unique(x))
    MExc = ExceptionMessage('Input', 'message', ...
        ['Knot sequence contains multiple identical knots.' ...
        'Removing multiplicities of the knots x.']);
    warning(MExc.id, MExc.message);
    x = unique(x);
end

%% Run code.

if isa(f, 'function_handle')
    g = f;
else
    MExc = ExceptionMessage('Generic', 'message', ...
        'Discrete framework might be cause loss of accuracy.');
    warning(MExc.id, MExc.message);
    g = @(xi) interp1(linspace(opts.min, opts.max, numel(f)), f, xi, 'cubic');
end

eL = zeros(1,length(x)-1);
for i = 1:(length(x)-1)
    eL(i) = 0.5*( x(i+1)-x(i) )*( f(x(i+1)) + f(x(i)) ) ...
        - quad(g, x(i), x(i+1));
end
eG = sum(eL(:));

end
