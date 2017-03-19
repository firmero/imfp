
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function res = mean_value_slope_form(polynomial_coefficients, X)

	n = length(polynomial_coefficients);
	c = mid(X);

	%
	% gc(x) = b_1*x^(n-2) + b_2*x^(n-3) + ... + b_(n-2)*x + b_(n-1)
	%
	% b_1 =  a_1 
	% b_2 =  a_1*c + a_2 
	% b_3 = (a_1*c + a_2)*c + a_3 
	% ...
	%

	% get coefficients of polynom gc()
	g = repmat(intval(0),1,n-1);

	g(1) = polynomial_coefficients(1);
	for i = 2:n-1
		g(i) = g(i-1)*c + polynomial_coefficients(i);
	end

	hf_g = horner_form(g,X);

	% todo if n == 1
	p_at_c = g(n-1)*c + polynomial_coefficients(n);
	res = p_at_c + hf_g*(X-c);

end


