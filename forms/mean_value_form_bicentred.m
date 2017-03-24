%
% MVFB(p,X) = infsup(inf(HF(p,c_left)), sup(HF(p,c_right)))
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function res = mean_value_form_bicentred(polynomial_coefficients,X)

	p_derivated = derivate_polynomial(polynomial_coefficients);

	hf_derivated = horner_form(p_derivated,X);

	[c_left, c_right] = centres_mean_value_form_(hf_derivated,X);

	setround(1);
	right = sup(horner_form(polynomial_coefficients,intval(c_right))) ...
			+ sup(hf_derivated*(X-c_right));

	setround(-1);
	left = inf(horner_form(polynomial_coefficients,intval(c_left))) ...
			+ inf(hf_derivated*(X-c_left));

	res = infsup(left,right);

end

