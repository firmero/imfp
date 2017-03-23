%
% X interval
% nadhodnocuje !!!!!
%
function y = evaluate_polynomial_(polynomial_coefficients, X)

	delta = 0.0003;

	t = inf(X);
	y = eval_at_point_(polynomial_coefficients,t);

	t = t + delta;
	while (t < sup(X))

		ny = eval_at_point_(polynomial_coefficients,t);

		y = hull(y,ny);

		t = t + delta;
	end

	y = hull(y,eval_at_point_(polynomial_coefficients,sup(X)));

end


function y = eval_at_point_(polynomial_coefficients, x)

	y = (polynomial_coefficients(1));

	for i = 2:length(polynomial_coefficients)
		y = y*x + polynomial_coefficients(i);
	end

end
