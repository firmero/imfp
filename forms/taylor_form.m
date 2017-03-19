%
%	c = mid(X)
%	r = rad(X)
%
%	p_series = sum i=0..deg(p) a(p,c,i)*x^i
%	g_series = sum i=1..deg(p) a(p,c,i)*x^(i-1)
%			where a(p,c,i) = HF(derivative(p,i),c)/i!
%
%	TF	= HF(p_series,X-c)
%		= p(c) + HF(g_series,X-c)*(X-c) = p(c) + mag(HF(g_series,X-c))*[-r,r]
%
function res = taylor_form(polynomial_coefficients, X)

	if (inf(X) == sup(X))
		res = horner_form(polynomial_coefficients,X);
		return
	endif

	c = mid(X);
	r = rad(X);

	n = length(polynomial_coefficients);
	tay_coeff = taylor_coefficients(polynomial_coefficients,c);

	getround(1);
	magnitude = mag(tay_coeff(n)) * r;

	% compute mag(HF(g_series,X-c))*[-r,r]
	% X - c == [-r,r]
	for i = n-1:-1:2
		magnitude = (magnitude + mag(tay_coeff(i)))*r;
	endfor

	% tay_coeff(1) == p(c)
	res = tay_coeff(1) + infsup(-magnitude, magnitude);

endfunction

