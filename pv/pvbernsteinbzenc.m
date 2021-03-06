function [ibfbz ver] = pvbernsteinbzenc(p,ix,k)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Bernstein form 
%  of polynomial with the bisection of the input interval at the zero.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%  k  ... optional, should be at least deg(p) (it is the default value),
%         greater value leads to tighter enclosure
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  ibfbz ... interval computed by Bernstein form with bisection at the zero.
%  ver   ... 1 iff Bernstein form is exact, otherwise 0
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  For ix containing the zero evaluate Bernstein form of p over [0,sup(ix)]
%  and Bernstein form of p(-x) over [0,-inf(ix)]. Otherwise Bernstein form
%  of p over ix.
%
%--------------------------------------------------------------------------
% .License.
%
%  Copyright (C) 2017  Charles University in Prague, Czech Republic
%
%  LIME 1.0 is free for private use and for purely academic purposes.
%  It would be very kind from the future user of LIME 1.0 to give
%  reference that this software package has been developed
%  by at Charles University, Czech Republic.
%
%  For any other use of LIME 1.0 a license is required.
%
%  THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED
%  WARRANTIES, INCLUDING, WITHOUT LIMITATIONS, THE IMPLIED WARRANTIES
%  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
%
%--------------------------------------------------------------------------
% .History.
%
%  2017-05-05  first version
%
%--------------------------------------------------------------------------
% .Todo.
%
%
%ENDDOC====================================================================

n = length(p);

% k should be at least n-1 (deg of polynomial)
if (nargin() == 2)
	k = n-1;
% not hadled bad calling
elseif (k < n-1)
	warning('Parameter k should be at least the degree of polynomial');
	k = n-1;
end

ix = intval(ix);
if (~in(0,ix))
	warning('Interval ix doesn''t contain 0');
	ibfbz = pvbernsteinenc(p,ix,k);
	return
end

[iright verright] = pvbernsteinenc(p,infsup(0,sup(ix)), k);

% coefficients for p(-x), then call with x
% p(-x) = a_1*(-x)^(n-1) + a_2*(-x)^(n-2) + .. + a_(n-1)*(-x)^1 + a_n
start = 1;
if (odd(n))
	start = start + 1;
end

for i = start:2:n
	p(i) = p(i) * (-1);
end

[ileft verleft] = pvbernsteinenc(p,infsup(0,-inf(ix)), k);

ibfbz = hull(ileft, iright);

% overestimation test
if (verleft + verright == 2)
	ver = 1;
else 
	ver = 0;
end

end
