function itfh = taylor_form_eval_half(itay_coeff,r)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  This function is used by pvtaylorbm(), which converts his input interval
%  to centered interval [-r,r]. Then it calls that function
%  twice and returns hull of results returned by that function.
%
%  val(x) = sum i=1 .. length(itay_coeff) itay_coeff(i)*x^(i-1),
%       where itay_coeff(i) = (i-1 derivative of p)(c) / (i-1)!
%
%  Returns [inf(val(ir)), sup(val(ir))], where ir = [0..r]
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  itay_coeff ... interval taylor coefficients 
%                 itay_coeff(i) = (i-1 derivative of p)(c) / (i-1)!
%  r          ... radius
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  itfh ... itfh = [inf(val(ir)), sup(val(ir))], where ir = [0..r] 
%
%--------------------------------------------------------------------------
% .Implementation details.
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

n = length(itay_coeff);

oldmod = getround();

left = inf(itay_coeff(n));
right = sup(itay_coeff(n));

% [inf(val(ir)), sup(val(ir))]
for i = n-1:-1:1

	% right should be max
	if (right > 0)
		setround(1);
		% r >= 0, sup(itay_coeff(i)) >= inf(itay_coeff(i))
		right = right*r + sup(itay_coeff(i));
	else 
		% choose 0 form [0,r] to maximize sup(right)
		right = sup(itay_coeff(i));
	end

	% left should be min
	if (left < 0)
		setround(-1);
		% r >= 0, sup(itay_coeff(i)) >= inf(itay_coeff(i))
		left = left*r + inf(itay_coeff(i));
	else
		% choose 0 to minimize
		left = inf(itay_coeff(i));
	end

	% [left, right]
	% = range of itay_coeff(i) + sum j=1..n-i x^j*itay_coeff(i+j)
	% x is from [0..r] 
end

itfh = infsup(left,right);

setround(oldmod);
end
