function imvf = pvmeanvalenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Mean value form over
%  interval.
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
%  itf ... interval computed by Mean value form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  From the mean value theorem: for all x and c in ix exists q in ix 
%  such that p(x) = p(c) + p`(q)*(x-c), therefore p(x) is in 
%  p(c) + p`(ix)*(x-c). Then p(ix) is subset of p(c) + p`(ix)*(ix-c).
%  Mean value form is a special case when c = mid(iX);
%
%	MVF(p,mid(ix)) = p(mid(ix)) + HF(p',ix)*(ix-mid(ix))
%
%  The midpoint of ix is optimal. For all t in ix it holds that
%  width(MVF(p,mid(ix))) <= width(MVF(p,t))
%
%  If 0 is not in HF(p',ix) then range is without overestimation.
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

c = mid(ix);
ihf_at_center = pvhornerenc(p,c);

% the interval coefficients of derivative of p
p_iderivated = derivate_polynomial(p);

ihf_derivated = pvhornerenc(p_iderivated,ix);

imvf = ihf_at_center + ihf_derivated*(ix-c);

end
