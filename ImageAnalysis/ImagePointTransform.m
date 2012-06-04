function out = ImagePointTransform( in , fun )
%% Applies the function f pointwise onto an image.
%
% out = ImagePointTransform( in , f )
%
% Input parameters (required):
%
% in  : input image ( array, the last dimension is assumed to contain the pixel
%       values ).
% fun : a function handle to apply on each pixel.
%
% Output parameters:
%
% out : image where fun has been applied onto each pixel.
%
% Description:
%
%
%
% Example:
%
%
%
% See also

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

% Last revision on: 04.06.2012 15:10

%% Check Input and Output Arguments

error(nargchk(2, 2, nargin));
error(nargoutchk(0, 1, nargout));

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('in', @(x) validateattributes( x, {'numeric'}, ...
    {'finite', 'nonempty', 'nonnan'}, ...
    mfilename, 'in', 1) );

parser.addRequired('fun', @(x) validateattributes( x, ...
    {'function_handle'}, {}, ...
    mfilename, 'fun') );

parser.parse(in,fun);
opts = parser.Results;

%% Algorithm

data = num2cell(opts.in,length(size(opts.in)));
[dummy n] = shiftdim(data{1});
data = cellfun(@shiftdim,data,'UniformOutput',false);
fundata = cellfun(@(x) shiftdim(fun(x),-n), data, 'UniformOutput', false);
out = cell2mat(fundata);

end