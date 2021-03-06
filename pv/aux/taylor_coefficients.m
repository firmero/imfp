function itc = taylor_coefficients(p, x)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Computes taylor coefficients of polynomial p at point x.
%
%  itc(i) = HF(i-1 derivative of p, x) / (i-1)!  for i =1..length(p)
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  x  ... evaluation point
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  itc ... vector of taylor coefficients
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

n = length(p);

% allocate output vector
itc = repmat(intval(0),1,n);
itc(1) = pvhornerenc(p,x);

% factorial
fact = intval(1);

% r will be the length of i-1 derivative
r = n-1;

for i = 2:n

	% multiplication constant produced by derivation
	c = r;

	% derivate
	for j = 1:r
		p(j) = c*p(j);
		c = c-1;
	end
	% p_1 ... p_r are coefficients of (i-1) derivative of p
	ptmp = p(1:r);

	itc(i) = pvhornerenc(ptmp,x) / fact;
	fact = fact * i;
	r = r - 1;

end

end
