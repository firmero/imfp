%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% m = mid(HF(p``,X))
% c = mid(X)
%
% IF(X) = HF(parabola,X) + 0.5*(HF(p``,X) - m)*(X-c)^2
%
% parabola(x) = 0.5*m*x^2 + (p`(c) - m*c)*x + (p(c) - p`(c)*c + 0.5*m*c^2)
%
function res = interpolation_form(polynomial_coefficients,X)
	
	p_derivated = derivate_polynomial(polynomial_coefficients);
	p_twice_derivated = derivate_polynomial(p_derivated);

	c = mid(X);

	p_at_c = horner_form(polynomial_coefficients,c);
	p_derivated_at_c = horner_form(p_derivated,c);
	p_twice_derivated_range = horner_form(p_twice_derivated,X);

	m = mid(p_twice_derivated_range);

	% parabola coefficients
	a2 = 0.5*m;
	a1 = p_derivated_at_c - m*c;
	a0 = (a2*c - p_derivated_at_c)*c + p_at_c;

	parabola_range = evaluate_parabola(a2,a1,a0,X);

	getround(1);
	r = mag(X-c);
	res = parabola_range + (p_twice_derivated_range - m)*infsup(0,0.5*r*r);

endfunction


