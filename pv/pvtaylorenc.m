function itf = pvtaylorenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%    The function computes range of Taylor form TF of polynomial p over ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval x
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  itf ... Taylor form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
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
%  ix-c is a centered interval
%  TF	= HF(p_series,ix-c)
%		= p(c) + HF(g_series,ix-c)*(ix-c) = p(c) + mag(HF(g_series,ix-c))*[-r,r]
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
% .Todo.
%
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
itay_coeff = taylor_coefficients(p,intval(c));

oldmod = getround();
setround(1);
magnitude = mag(itay_coeff(n)) * r;

% compute mag(HF(g_series,ix-c))*[-r,r]
% itay_coeff(i) = a(p,c,i-1)
% ix - c == [-r,r]
% horner scheme
for i = n-1:-1:2
	magnitude = (magnitude + mag(itay_coeff(i)))*r;
end

% itay_coeff(1) == p(c)
itf = itay_coeff(1) + infsup(-magnitude, magnitude);

setround(oldmod);
end
