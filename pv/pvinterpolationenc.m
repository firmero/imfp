function iif = pvinterpolationenc(p,ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Interpolation form
%  of polynomial over interval.
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
%  iif ... interval computed by Interpolation form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Interpolation form uses Taylor expansion of p at the middle c of ix:
%  p(x) = p(c) + p`(c)*(x-c) + 1/2*p``(y)*(x-c)^2 for some y between
%  x and c.
%  For any m it holds:
%  p(x) = p(c) + p`(c)*(x-c) + 1/2*m*(x-c)^2 + 1/2*(p``(y)-m)*(x-c)^2
%
%  Interpolation form uses mid(HF(p``,ix)) as m.
%  IF(ix) = HF(parabola,ix) + 1/2*(HF(p``,ix) - m)*(ix-c)^2
%
%  parabola(x) = 1/2*m*x^2 + (p`(c) - m*c)*x + (p(c) - p`(c)*c + 1/2*m*c^2)
%
%  Where HF is Horner form.
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

% interval coefficients of derivative of p
ip_der = derivate_polynomial(p);

% interval coefficients of second derivative of p
ip_der2 = derivate_polynomial(ip_der);

c = mid(ix);

% to find out parabola coeffcients the following values are needed
% p(c), p`(c) and p``(ix)
ip_at_c = pvhornerenc(p,c);
ip_der_at_c = pvhornerenc(ip_der,c);
ip_der2_val = pvhornerenc(ip_der2,ix);
%  Interpolation form uses mid(HF(p``,ix)) as m.
im = intval(mid(ip_der2_val));

% parabola coefficients
% parabola(x) = 1/2*m*x^2 + (p`(c) - m*c)*x + (p(c) - p`(c)*c + 1/2*m*c^2)
ia2 = 1/2*im;
ia1 = ip_der_at_c - im*c;
ia0 = (ia2*c - ip_der_at_c)*c + ip_at_c;

iparabola_val = evaluate_parabola(ia2,ia1,ia0,ix);

oldmod = getround();

setround(1);
r = mag(ix-c);

% IF(ix) = HF(parabola,ix) + 1/2*(HF(p``,ix) - m)*(ix-c)^2
iif = iparabola_val + (ip_der2_val - im)*infsup(0,1/2*r*r);

setround(oldmod);
end
