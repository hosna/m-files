function fighandle = A4Figure(varargin)
%% Creates a figure handle to plot on DIN A4 landscape paper.
%
% fighandle = A4Figure(...)
%
% Input parameters (required):
%
% Input parameters (optional):
%
% Optional parameters are either struct with the following fields and
% corresponding values or option/value pairs, where the option is specified as a
% string.
%
% Border      : Distance of the axes from the paper edge in centimeters. (array
%               of length 2) (default = [1.25 1.25])
% Orientation : Paper orientation. Either 'landscape' (default) or 'portrait'.
%
% Output parameters:
%
% fighandle : handle to the figure.
%
% Description:
%
% Sets up a figure such that it can nicely be plotted onto a DIN A4 sheet in
% landscape format. Loosely based on
%
% http://itb.biologie.hu-berlin.de/~schaette/HomeFiles/MatlabPlots.pdf
%
% Example:
% x = linspace(-pi,pi,2048);
% y = sin(x);
% fig = A4Figure();
% plot(x,y);
% xlabel('x');
% ylabel('sin(x)');
% title('A function plot');
% print(fig,'out2.pdf','-dpdf');
%
% See also figure, axes, plot, print

% Copyright 2012 Laurent Hoeltgen <laurent.hoeltgen@gmail.com>
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

% Last revision on: 09.10.2012 11:25

%%
narginchk(0, 4);
nargoutchk(0, 1);

narginchk(0,4);
nargoutchk(0,1);

parser = inputParser;
parser.FunctionName  = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand  = true;

parser.addParamValue( ...
    'Border', [1.25 1.25], ...
    @(x) isvector(x)&&isequal(length(x),2) ...
    );

parser.addParamValue( ...
    'Orientation', 'landscape', ...
    @(x) any(strcmpi(x,{'landscape','portrait'})) ...
    );

parser.parse(varargin{:})
opts = parser.Results;
if strcmpi(opts.Orientation,'landscape')
    opts.Size = [29.7 21.0];
else
    opts.Size = [21.0 29.7];
end
fighandle = Figure4File(opts);

end
