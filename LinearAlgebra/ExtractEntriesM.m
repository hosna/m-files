function M = ExtractEntriesM(C)
%% Returns a Matrix that extracts the marked entries from a vector.
%
% M = ExtractEntriesM(C)
%
% The output Matrix extracts those entries from a vector that are marked by the
% binary input vector mask.
%
% Input Parameters (required)
%
% C : binary mask.
%
% Example
%
% ExtractEntriesM([1;0;1]) = [ 1 0 0 ; 0 0 1 ];
%
% See also speye, eye.

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

% Last revision on: 24.04.2013 09:45

%% Check input parameters

narginchk(1, 1);
nargoutchk(0, 1);

%% Compute Matrix

n = length(C);
T = speye(n,n);
M = T(C==1,:);
end
