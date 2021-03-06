function out = SolvePde(f, c, varargin)
%% Solves the Laplace equation with mixed boundary conditions.
%
% out = SolvePde(f, c, ...)
%
% Input parameters (required):
%
% f : image data for the data sites. (double array)
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
% lsqrTol    : tolerance limit for the least squares solver. (scalar,
%              default = 1e-8)
% lsqrMaxit  : maximal number of iterations the least squares solver should do.
%              (scalar, default = 20000)
%
% Output parameters:
%
% out : Solution of the considered PDE.
%
% Description:
%
% Solves the following PDE:
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
% f = rand(100,100);
% SolvePde(f, c);
%
% See also EvalPde, PdeM

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

% Last revision on: 05.10.2012 10:15

narginchk(2, 18);
nargoutchk(0, 1);

parser = inputParser;
parser.FunctionName = mfilename;
parser.CaseSensitive = false;
parser.KeepUnmatched = true;
parser.StructExpand = true;

parser.addRequired('f', @(x) ismatrix(x)&&IsDouble(x));
parser.addRequired('c', @(x) ismatrix(x)&&IsDouble(x));

parser.addParamValue('threshData', nan, @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDataMin',  0,  @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDataMax',  1,  @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('threshDiff', nan, @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDiffMin',  0,  @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('thrDiffMax',  1,  @(x) isscalar(x)&&IsDouble(x));

parser.addParamValue('lsqrTol',        1e-8, @(x) isscalar(x)&&IsDouble(x));
parser.addParamValue('lsqrMaxit',  20000,    @(x) isscalar(x)&&IsDouble(x));

parser.parse(f, c, varargin{:})
opts = parser.Results;

% Set these values so that they are defined even when the lsqr solver is not
% being used.
flag = 0;
relres = -1;
iter = -1;

if norm(opts.c,2) <= 10*eps
    % if the mask is empty, the constant signal 0 is the correct solution. No
    % need to compute anything then.
    out = zeros(size(opts.f));
    return;
end
% Set up the system matrix and the righthand side.
LHS = PdeM(opts.c, opts);
RHS = subsref(Rhs(opts.c, f, opts), substruct('()',{':'}));

% This is an undocumented feature in MATLAB to turn non catchable warnings into
% errors. Use with care!
s = warning('error','MATLAB:singularMatrix');
try
    % Make an estimate on the condition of the system matrix. If it is
    % reasonably small, we use the backslash operator. Otherwise we perform a
    % least squares approach. It looks a bit overkill to make the estimate and
    % to use try/catch, but some experiments have been causing trouble using
    % only the try/catch block.
    if condest(LHS) < 1e10
        out = mldivide(LHS, RHS);
    else
        [out flag relres iter] = lsqr( ...
            LHS, RHS, ...
            opts.lsqrTol, opts.lsqrMaxit, ...
            speye(numel(opts.f), numel(opts.f)), ...
            speye(numel(opts.f), numel(f)), ...
            opts.f(:) ...
            );
    end
catch err
    % If the backslash operator was unable to solve the problem, use the least
    % square solver. Note that the lsqr solver returns wrong results for
    % c = [0 0 0 1 1 0 0 1 1 0 0 0] and
    % f = [0 0 0 0 1 1 1 1 0 0 0 0] namely
    % u = [0 0 0 0 0 0 0 0 0 0 0 0].
    if strcmp(err.identifier,'MATLAB:singularMatrix')
        [out flag relres iter] = lsqr( ...
            LHS, RHS, ...
            opts.lsqrTol, opts.lsqrMaxit, ...
            speye(numel(opts.f), numel(opts.f)), ...
            speye(numel(opts.f), numel(f)), ...
            opts.f(:) ...
            );
    else
        % Whatever we caught was unrelated to the singularity of the matrix.
        % Just rethrow that error.
        rethrow(err)
    end
end
warning(s);

out = reshape(out,size(opts.f));

if flag ~= 0
    warning('OPTCONT:Err', ...
        'SolvePde failed with flag: %g, relative residual %g at iteration %d\n', flag, relres, iter);
end

end
