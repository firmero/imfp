%
%	TF	= HF(p_series,X-c)
%			X - c is centered interval
%
%	p_series(x) = sum i=0..deg(p) a(p,c,i)*x^i
%		where a(p,c,i) = HF(derivative(p,i),c)/i!
%
function res = taylor_form_bisect_middle(polynomial_coefficients, X)

	c = mid(X);

	n = length(polynomial_coefficients);
	tay_coeff = taylor_coefficients(polynomial_coefficients,c);

	% right half [0,|c|]
	setround(1);
	x =	sup(X) - c;
	R = taylor_form_eval_half(tay_coeff,x);

	% left half [-|c|,0] -> [0,|c|] && p_series(-x)
	setround(-1);
	x = c - inf(X);

	% coefficients for p_series(-x)
	for i = 2:2:n
		tay_coeff(i) = tay_coeff(i) * -1;
	end

	L = taylor_form_eval_half(tay_coeff,x);

	res = hull(L,R);

end
