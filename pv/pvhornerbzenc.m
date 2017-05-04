function ihfbz = pvhornerbzenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Horner form for
%  input interval containing 0.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  ihfbz ... interval computed by Horner form with bisection at the zero
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Bisection at the zero reduces problem to evaluation of two Horner form
%  over intervals [0,t] (t = sup(ix), t = -inf(ix)). That does not need
%  interval arithmetic. Overall it's slower than Horner form without
%  bisection, but can give tighter interval.
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

ix = intval(ix);
if (~in(0,ix))
	warning('Interval doesn''t contain 0');
	ihfbz = pvhornerenc(p,ix);
	return
end

ileft  = infsup(0,-inf(ix));
iright = infsup(0,sup(ix));

ihfbz = hull(pvhornerlzenc(invert_polynomial(p),ileft),...
		     pvhornerlzenc(p,iright));

end
