function itf = pvtaylorenc(p, ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%    The function computes range of Taylor form TF of polynomial p over ix.
%  Taylor form is just Horner form of taylor series a given input
%  polynomial. That series is centered at a middle of input interval ix.
%
%  c = mid(ix)
%  r = rad(ix)
%
%  p_series := sum from i=0..deg(p) of a(p,c,i)*x^i
%  g_series := sum from i=1..deg(p) of a(p,c,i)*x^(i-1)
%    where a(p,c,i) = HF(derivative(p,i),c)/i! and HF is Horner form
%
%  TF	= HF(p_series,ix-c)               ... ix-c is a centered interval
%		= p(c) + HF(g_series,ix-c)*(ix-c) = p(c) + mag(HF(g_series,ix-c))*[-r,r]
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval x
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  itf ... Taylor form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%--------------------------------------------------------------------------
% .License.
%
%  [license goes here]
%
%--------------------------------------------------------------------------
% .History.
%
%  2017-MM-DD   first version
%
%--------------------------------------------------------------------------
% .Todo
%
%  todo: taylor coeff as intval?
%
%ENDDOC====================================================================

% used intval to prevent from the generation of the matrix of inf value,
% if ix is point then Taylor form equals to Horner form
if (inf(intval(ix)) == sup(ix))
	itf = pvhornerenc(p,inf(intval(ix)));
	return
end

c = mid(ix);
r = rad(ix);

n = length(p);
tay_coeff = taylor_coefficients_(p,intval(c));

oldmod = getround();
setround(1);
magnitude = mag(tay_coeff(n)) * r;

% compute mag(HF(g_series,ix-c))*[-r,r]
% ix - c == [-r,r]
% horner scheme
for i = n-1:-1:2
	magnitude = (magnitude + mag(tay_coeff(i)))*r;
end

% tay_coeff(1) == p(c)
itf = tay_coeff(1) + infsup(-magnitude, magnitude);

setround(oldmod);
end
