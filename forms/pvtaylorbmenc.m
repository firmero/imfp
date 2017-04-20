function itfbm = pvtaylorbmenc(p, ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%    The function computes range of Taylor form of polynomial p over
%  interval ix using bisection at the zero of translated ix. Interval
%  ix-c is centered interval [-r,r].
%
%  By bisection the overestimation error is reduced at least by half,
%  because of evaluation Horner form over centered interval bisected
%  at zero.
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
%  itfbm ... Taylor form with bisection
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  c = mid(ix)
%  r = rad(ix)
%
%  p_series(x) = sum i=0..deg(p) a(p,c,i)*x^i
%		where a(p,c,i) = HF(derivative(p,i),c)/i!
%
%  TF	= HF(p_series,ix-c)
%		ix-c is centered interval
%
%  TFBM = hull(HF(p_series(-x),r), HF(p_series,r))
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
%
%ENDDOC====================================================================

% used intval to prevent from the generation of the matrix of inf value,
% if ix is point then Taylor form equals to Horner form
if (inf(intval(ix)) == sup(ix))
	itfbm = pvhornerenc(p,inf(intval(ix)));
	return
end

c = mid(ix);
r = rad(ix);

n = length(p);
itay_coeff = taylor_coefficients(p,c);
% itay_coeff(i) = a(p,c,i-1)

% we want to evaluate horner range of polynomial p
% p <- itay_coeff over [-r,r]
% p(x) = itay_coeff(n)*x^(n-1)+ itay_coeff(n-1)*x^(n-2) +...+ itay_coeff(1)

% right half [0,r]
iright = taylor_form_eval_half(itay_coeff,r);

% left half [-r,0] transform to [0,r] and p_series to p_series(-x)
% coefficients for p_series(-x)
for i = 2:2:n
	itay_coeff(i) = itay_coeff(i) * -1;
end

ileft = taylor_form_eval_half(itay_coeff,r);

itfbm = hull(ileft,iright);

end
