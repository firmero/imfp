function imvfbc = pvmeanvalbcenc(p,ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Bicentred mean value
%  form of polynomial over interval.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n.
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  imvfbc ... interval computed by Bicentred mean value form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Bicentred mean value form evaluates mean value form twice and constructs
%  final range.
%  MVF = p(c) + HF(p',ix)*(ix-c), where c = mid(ix)
%  MVFB uses as c optimal points c_left and c_right, than for all t in ix
%  it holds:
%
%	sup(MVF(p,c_right)) <= sup(MVF(p,t))
%	inf(MVF(p,c_left))  >= inf(MVF(p,t))
%
%  MVFB(p,ix) = [inf(MVFC(ix,c_left)), sup(MVFC(ix,c_right))]
%		where MVFC(ix,t) = HF(p,t) + HF(p`,ix)*(ix-t)
%
%  If 0 is not in interior of HF(p',ix) then range is without
%  overestimation.
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

% the interval coefficients of derivative of p
p_iderivated = derivate_polynomial(p);

ihf_derivated = pvhornerenc(p_iderivated,ix);

% find optimal points
[c_left, c_right] = centres_mean_value_form(ihf_derivated,ix);

oldmod = getround();
setround(1);
right = sup(pvhornerenc(p,c_right)) ...
		+ sup(ihf_derivated*(ix-c_right));

setround(-1);
left = inf(pvhornerenc(p,c_left)) ...
		+ inf(ihf_derivated*(ix-c_left));

imvfbc = infsup(left,right);

setround(oldmod);
end
