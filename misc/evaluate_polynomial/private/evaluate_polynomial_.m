%
% X interval
% nadhodnocuje !!!!!
%
function y = evaluate_polynomial_(polynomial_coefficients, X)

	t = inf(X);
	y = eval_at_point(polynomial_coefficients,t);

	while (t + 0.0003 < sup(X))

		t = t + 0.0003;
		ny = eval_at_point(polynomial_coefficients,t);

		y = hull(y,ny);

	end

	y = hull(y,eval_at_point(polynomial_coefficients,sup(X)));

end

function y = eval_at_point(polynomial_coefficients, x)

	y = intval(polynomial_coefficients(1));

	for i = 2:length(polynomial_coefficients)
		y = y*x + polynomial_coefficients(i);
	end
end
