%
% Compute derivative of p(x)
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function p_derivated = derivate_polynomial(polynomial_coefficients)

	n = length(polynomial_coefficients);
	p_derivated = repmat(intval(0),1,n-1);

	for i = 1:n-1
		p_derivated(i) = (n-i) * polynomial_coefficients(i);
	end

end


