function imwrite(obj,varargin)
%Image/imwrite writes an image file.
%   This is wrapper function for the builtin imwrite function. It uses the same
%   calling structure.
%
%   Input parameters (required):
%
% TODO
%
%   Input parameters (optional):
%
% TODO
%
%   Output parameters:
%
% TODO
%
%   Description:
%
% TODO
%
%   Example:
%
% TODO
%
%   See also imread, imwrite

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

% Last revision on: 18.07.2012 07:20

imwrite(double(obj),varargin{:});

end