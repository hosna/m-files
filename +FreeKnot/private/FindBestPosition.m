function [ p ] = FindBestPosition(V,x,pos)
% [ p ] = FindBestPosition(V,x,pos)
% Looks for the best approximation of the scalar x inside the vector V and
% returns by default the position of the first occurence. This behaviour can
% be overriden by providing a thrid parameter which may be either 'first' or
% 'last' to return the respective occurence.
%
% Usage: [ p ] = FindBestPosition(V,x,pos)
% V   : the search space.
% x   : the value to be found.
% pos : if 'first' the first occurence is returned. If 'last' it returns the
%       last occurence.
% p   : the position of the best approximation to x.

% Copyright 2011,2012 Laurent Hoeltgen <laurent.hoeltgen@gmail.com>
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

% Last revision: 05.09.2012 16:10

%% Check number of input and output arguments.

narginchk(2,3);
nargoutchk(0,1);

if nargin == 2
    pos = 'first';
end
temp = unique(V);
p = interp1(temp,1:length(temp) , x , 'nearest','extrap');
p = find( V==temp(p) , 1 , pos );
end
