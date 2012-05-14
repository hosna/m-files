function mask = FindLargest(M,k)
%% Finds the k largest elements in the given matrix.
%
% mask = FindLargest(M,k)
%
% Input Parameters:
%
% 
% 
%
% Output Parameters
%
% 
% 
%
% Example
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

% Last revision:

%% Comments and Remarks.

%% Check input parameters

%% Perform computation

sortedValues = unique(M(:));
maxValues = sortedValues(end-(k-1):end);
mask = ismember(M,maxValues);

end
