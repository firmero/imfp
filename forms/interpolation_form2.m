
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% IF2(X) = [inf(p_down),sup(p_up)]
%
% IF2(X) is subset of IF(X)
%
% c = mid(X)
%
% p_up(x)   = p(c) + p`(c)(x-c) + 0.5*sup(HF(p``,X))*(x-c)^2 
%  = p(c)	+ 0.5*sup(HF(p``,X))*x^2 
%			+ (p`(c) - sup(HF(p``,X))*c)*x 
%			+ (0.5*sup(HF(p``,X)*c - p`(c))*c
%  = p(c) + p2(X)
%
% p_down(x) = p(c) + p`(c)(x-c) + 0.5*inf(HF(p``,X))*(x-c)^2
%  = p(c)	+ 0.5*inf(HF(p``,X))*x^2 
%			+ (p`(c) - inf(HF(p``,X))*c)*x 
%			+ (0.5*inf(HF(p``,X)*c - p`(c))*c
%  = p(c) + p1(X)
%
function res = interpolation_form2(polynomial_coefficients,X) 

	p_derivated = derivate_polynomial(polynomial_coefficients);
	p_twice_derivated = derivate_polynomial(p_derivated);

	c = mid(X);

	p_at_c = horner_form(polynomial_coefficients,c);
	p_derivated_at_c = horner_form(p_derivated,c);
	p_twice_derivated_range = horner_form(p_twice_derivated,X);

	% parabola coefficients for polynomials par_up
	a2 = 0.5*p_twice_derivated_range;

	a2_up = sup(a2);
	a2_down = inf(a2);

	a1_up = p_derivated_at_c - intval(sup(p_twice_derivated_range))*c;
	a1_down = p_derivated_at_c - intval(inf(p_twice_derivated_range))*c;

	a0_up = (a2_up*c - p_derivated_at_c)*c;
	a0_down = (a2_down*c - p_derivated_at_c)*c;

	p1 = evaluate_parabola(a2_up,a1_up,a0_up,X);
	p2 = evaluate_parabola(a2_down,a1_down,a0_down,X);

	res = hull(p1,p2) + p_at_c;

end

