function isf = pvslopeenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Slope form over
%  interval.
%
%  For polynomial p there exists uniquely defined polynomial q such that
%  p(x) = p(c) + q(x)*(x-c), where c = mid(ix). Polynomial q has smaller
%  degree by one.
%  
%  Slope form is defined as SF = p(c) + HF(q,ix)*(ix-c)
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
%  isf ... interval computed by Slope form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Coefficients of polynomial q such that p(x) = p(c) + q(x)*(x-c)
%  n = length(p)
%
%  q(x) = q_1*x^(n-2) + q_2*x^(n-3) + .. + q_(n-2)*x + q_(n-1)
%
%  q_i = sum j=1..i a_j*c^(i-j) 
%
%  That can be computed using horner scheme:
%  q_1 = a_1
%  q_i = q_(i-1)*c + a_i,  i = 2..n-1
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
if (n == 1)
	isf = p(1);
	return;
end

c = mid(ix);

% coefficients of polynomial q
iq = repmat(intval(0),1,n-1);
iq(1) = p(1);
for i = 2:n-1
	iq(i) = iq(i-1)*c + p(i);
end

iyhorner_q = pvihornerenc(iq,ix);

% iq_(n-1) = sum j=1..(n-1) a_j*c^(n-1-j) 
% p(n) = a_n
ip_at_c = iq(n-1)*c + p(n);

% SF = p(c) + HF(q,ix)*(ix-c)
isf = ip_at_c + iyhorner_q*(ix-c);

end
