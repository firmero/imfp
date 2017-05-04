function ihflz = pvhornerlzenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Horner form
%  for interval ix = [0,r], r >= 0.
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
%  ihflz ... interval computed by Horner form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  The implementation computes left and right bound of intermediate result
%  simultaneously. For this special form of interval the interval arithemic
%  can be omitted. So, it is faster.
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

if (inf(ix) ~= 0)
	warning('Interval is not of form [0,r].');
	ihflz = pvhornerenc(p,ix);
	return
end

% intermediate result
itmp = intval(p(1));

% xx is not negative number
xx = sup(ix);

oldmod = getround();

for i = 2:length(p)

	% we want left to minimalise
	if (inf(itmp) < 0)
		setround(-1);
		% from interval ix chooose sup(ix) (=xx)
		left = inf(itmp)*xx + p(i);
	else 
		% save multiply by zero
		% from interval ix chooose 0
		left = p(i);
	end

	% we want right to maximise
	if (sup(itmp) > 0)
		setround(1);
		% from interval ix chooose sup(ix) (=xx)
		right = sup(itmp)*xx + p(i);
	else
		right = p(i);
	end

	itmp = infsup(left, right);

end

setround(oldmod);

ihflz = itmp;

end
