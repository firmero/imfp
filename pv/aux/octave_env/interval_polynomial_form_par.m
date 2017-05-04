function res = interval_polynomial_form_par(ip,ix,form)
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
%  coefficients over ix. Parallel version.
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
%  polynomial with point coefficients. If polynomial has interval
%  coefficients then these evaluations run concurrently.
%
%  If ix doesn't contain negative number, then the range of ip is:
%
%	iyr = [inf(range(down,ix)), sup(range(up,ix))], where
%			down:  [... inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]
%			up:    [... sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
%
%  If ix doesn't contain positive number, then the range of ip is:
%
%	iyl = [inf(range(down,ix)), sup(range(up,ix))], where
%			down:  [... inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]
%			up:    [... sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
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
ncpus = nproc();

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

	% plan computations of polynomial up and down over L
	bound = min(sup(ix),0);
	iL = infsup(inf(ix), bound);

	intervals{1} = iL;
	intervals{2} = iL;

	coefficients{1} = down;
	coefficients{2} = up;

else
	% interval ix doesn't contain negative numbers
	% evaluate over ix and return

	for i = 1:n
		up(i) = sup(ip(i));
		down(i) = inf(ip(i));
	end
	% up:    [... sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
	% down:  [... inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]

	% plan computations of polynomial up and down over ix
	intervals{1} = ix;
	intervals{2} = ix;

	coefficients{1} = down;
	coefficients{2} = up;

	% compute over ix
	pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
					'VerboseLevel', 0);

	res = infsup(inf(pack{1}),sup(pack{2}));
	return
end

if (sup(ix) <= 0)
	% return range over L = ix, ix don't contain positive numbers
	pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
					'VerboseLevel', 0);

	res = infsup(inf(pack{1}),sup(pack{2}));
	return 
end

% plan computations of polynomial up and down over [0, sup(ix)]

% reuse previous state of up and down vector
for i = n-1:-2:1
	up(i) = sup(ip(i));
	down(i) = inf(ip(i));
end
% up:    [... sup(ia_(n-2)) sup(ia_(n-1)) sup(ia_n)]
% down:  [... inf(ia_(n-2)) inf(ia_(n-1)) inf(ia_n)]

iR = infsup(0,sup(ix));
intervals{3} = iR;
intervals{4} = iR;

coefficients{3} = down;
coefficients{4} = up;

% left and right interval
pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
				'VerboseLevel', 0);

left_res = infsup(inf(pack{1}),sup(pack{2}));
right_res = infsup(inf(pack{3}),sup(pack{4}));

% L U R
res = hull(left_res,right_res);

end
