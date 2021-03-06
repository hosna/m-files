function out = MorphologicalClosing(in, mask1, varargin)
%% Apply a Morphological closing.
%
% out = MorphologicalClosing(in, mask1, mask2)
%
% Input parameters (required):
%
% in    : input image. (array)
% mask1 : 2D array with odd number of rows and columns. Center will be the mid
%         pixel along every direction. Entries serve as weights. NaNs mark
%         pixels to be ignored. This is the mask for the dilation.
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
% mask2 : 2D array with odd number of rows and columns. Center will be the mid
%         pixel along every direction. Entries serve as weights. NaNs mark
%         pixels to be ignored. This is the mask for the erosion. (default =
%         mask1)
%
% Output parameters:
%
% out : Resulting image.
%
% Output parameters (optional):
%
% -
%
% Description:
%
% Applies a Morphological closing on a given image. The mask is cropped at
% the image boundaries. No padding at all is being performed. The closing
% operation corresponds to a morphological dilation followed by an erosion. If
% only one mask is specified, erosion and dilation will use the same mask. The
% first mask will be used for the dilation and the second mask for the erosion.
%
% Example:
%
% mask = [nan 1 1 ; 1 4 nan ; 0 0 2 ];
% I = double(rand(16,16) > 0.2);
% MorphologicalClosing(I,mask,mask);
%
% See also MorphologicalOpening, MorphologicalDilation, MorphologicalgErosion

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

% Last revision on: 01.03.2013 07:30

%% Notes

%% Parse input and output.

narginchk(2,3);
nargoutchk(0,1);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('in', @(x) validateattributes( x, {'numeric'}, ...
    {'2d', 'nonsparse', 'nonempty'}, mfilename, 'in', 1) );

parser.addRequired('mask1', @(x) validateattributes( x, {'numeric'}, ...
    {'2d', 'nonsparse', 'nonempty'}, mfilename, 'mask1', 2) );

parser.addOptional('mask2', mask1, @(x) validateattributes( x, {'numeric'}, ...
    {'2d', 'nonsparse', 'nonempty'}, mfilename, 'mask2', 3) );

parser.parse(in, mask1, varargin{:});
opts = parser.Results;

%% Run code.

out = MorphologicalErosion(MorphologicalDilation(in, mask1), opts.mask2);

end
