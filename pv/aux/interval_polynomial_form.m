function iy = interval_polynomial_form(ip,ix,form)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluate the range of interval polynomial ip over ix using a function
%  handler form which can compute range of polynomial with point 
%  coefficients over ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ip   ... vector of polynomial interval coefficients [ia_1 ... ia_n]
%  ix   ... interval x
%  form ... function handler accepting point polynomial and ix
%
%	ip(x) = ia_1*x^(n-1) + ia_2*x^(n-2) + .. + ia_(n-1)*x^1 + ia_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iy ... range of form of interval polynomial ip over ix
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Reduce computation of interval polynomial to 2 or 4 evaluation of
%  polynomial with point coefficients.
%
%  If ix doesn't contain negative number, then the range of ip is:
%
%	iyr = [inf(range(down,ix)), sup(range(up,ix))], where
%			down:  [.. inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]
%			up:    [.. sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
%
%  If ix doesn't contain positive number, then the range of ip is:
%
%	iyl = [inf(range(down,ix)), sup(range(up,ix))], where
%			down:  [.. inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]
%			up:    [.. sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
%
%  In the other situation, the range of ip is the hull of iyl and iyr.
%
%  In the implementation the range of up and down polynomial is computed
%  by function handler form.
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

if (~isintval(ip(1)))
	iy = form(ip,ix);
	return
end

n = length(ip);
up = repmat(0,1,n);
down = repmat(0,1,n);
ix = intval(ix);

if (inf(ix) < 0)
	% interval L = [inf(ix), min(0,sup(ix))]

	for i = n:-2:1
		up(i) = sup(ip(i));
		down(i) = inf(ip(i));
	end

	for i = n-1:-2:1
		up(i) = inf(ip(i));
		down(i) = sup(ip(i));
	end

	% up:    [... sup(ia_(n-2)) inf(ia_(n-1)) sup(ia_n)]
	% down:  [... inf(ia_(n-2)) sup(ia_(n-1)) inf(ia_n)]

	% compute over L
	bound = min(sup(ix),0);
	iL = infsup(inf(ix), bound);

	ileft_max = form(up,iL);
	ileft_min = form(down,iL);
	ileft_res = infsup(inf(ileft_min),sup(ileft_max));
else
	% interval ix doesn't contain negative numbers
	% evaluate over ix and return

	for i = 1:n
		up(i) = sup(ip(i));
		down(i) = inf(ip(i));
	end
	% up:    [... sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
	% down:  [... inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]

	% compute over ix
	iright_max = form(up,ix);
	iright_min = form(down,ix);

	iy = infsup(inf(iright_min),sup(iright_max));
	return
end

if (sup(ix) <= 0)
	% return range over L = ix, ix don't contain positive numbers
	iy = ileft_res;
	return 
end

% compute over R = [0, sup(ix)]

% reuse previous state of up and down vector
for i = n-1:-2:1
	up(i) = sup(ip(i));
	down(i) = inf(ip(i));
end
% up:    [... sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
% down:  [... inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]

iR = infsup(0,sup(ix));
iright_max = form(up,iR);
iright_min = form(down,iR);

iright_res = infsup(inf(iright_min),sup(iright_max));

% L U R
iy = hull(ileft_res,iright_res);

end
