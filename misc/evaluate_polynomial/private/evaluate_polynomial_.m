%
% X interval
% nadhodnocuje !!!!!
%
function y = evaluate_polynomial_(polynomial_coefficients, X)

	t = inf(X);
	y = intval(polyval(polynomial_coefficients,t));

	while (t + 0.0003 < sup(X))

		t = t + 0.0003;
		ny = polyval(polynomial_coefficients,t);

		y = hull(y,ny);

	end

	y = hull(y,polyval(polynomial_coefficients,sup(X)));

end
