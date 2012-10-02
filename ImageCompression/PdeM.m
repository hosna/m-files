function out = PdeM(c,varargin)
%% Matrix for the Laplace equation with mixed boundary conditions.
%
% out = PdeM(c, ...)
%
% Input parameters (required):
%
% c : mask indicating the positions where the dirichlet data should be applied.
%     (double array)
%
% Input parameters (optional):
%
% Optional parameters are either struct with the following fields and
% corresponding values or option/value pairs, where the option is specified as a
% string.
%
% threshData : threshold that should be applied to the mask in front of the data
%              term (u-f). (scalar, default = nan, e.g. no thresholding).
% thrDataMin : value at which the mask for the data term should be set for
%              values below the threshold. (scalar, default = 0).
% thrDataMax : value at which the mask for the data term should be set for
%              values above the threshold. (scalar, default = 1).
% threshDiff : threshold that should be applied to the mask in front of the diff
%              term Laplace u. (scalar, default = nan, e.g. no thresholding).
% thrDiffMin : value at which the mask for the diff term should be set for
%              values below the threshold. (scalar, default = 0).
% thrDiffMax : value at which the mask for the diff term should be set for
%              values above the threshold. (scalar, default = 1).
%
% Output parameters:
%
% out : Matrix correspinding to the left hand side of the discretised PDE
%
% Description:
%
% Constructs the Matrix that corresponds to the finite difference discretisation
% of the following linear PDE
%
% c.*(u-f) - (1-c).*(u_xx + u_yy) = 0
%
% which corresponds to the Laplace equation with mixed (Robin-) boundary
% conditions in case of a binary valued c if it is solved with a righthand side
% of 0. Positions where c == 1, will represent Dirichlet boundary conditions and
% positions where c == 0, will be the domain where the PDE should be solved.
% Note that the outer boundaries (unless specified through c) will be modelled
% with Neumann Boundary conditions. If c contains arbitrary values between 0 and
% 1, the above model can be considered to be a fuzzy mixed boundary value
% problem where c acts as the fuzzy indicator. Values for c outside of the
% interval [0,1] are allowed. Their interpretation is left to the user. The mask
% for the interpolation sites can be binarized independently for the data term
% and for the differential term. The binarization is being done with the
% Binarize function.
%
% Example:
% c = double(rand(100,100) > 0.6);
% PdeM(c);
%
% See also EvalPde, SolvePde

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

% Last revision on: 24.09.2012 12:28

narginchk(1, 13);
nargoutchk(0, 1);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('c', @(x) ismatrix(x)&&IsDouble(x));

parser.addParamValue('threshData', nan, @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDataMin',  0,  @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDataMax',  1,  @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('threshDiff', nan, @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDiffMin',  0,  @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDiffMax',  1,  @(x) isscalar(x)&&IsDouble(x));

parser.parse(c, varargin{:})
opts = parser.Results;

% TODO: make passing of options more flexible.
% NOTE: the correct call would be LaplaceM(row, col, ...), however this assumes
% that the data is labeled row-wise. The standard MATLAB numbering is
% column-wise, therefore, we switch the order of the dimensions to get the
% (hopefully) correct behavior.

[row col] = size(opts.c);
D = LaplaceM(col, row, ...
    'KnotsR',[-1 0 1],'KnotsC',[-1 0 1], ...
    'Boundary', 'Neumann');

cData = Binarize(opts.c, opts.threshData, ...
    'min', opts.thrDataMin, 'max', opts.thrDataMax);
cDiff = Binarize(opts.c, opts.threshDiff, ...
    'min', opts.thrDiffMin, 'max', opts.thrDiffMax);

out = Mask(cData) - (speye(numel(opts.c)) - Mask(cDiff))*D;

end
