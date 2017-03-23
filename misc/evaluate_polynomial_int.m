%
% X interval
% nadhodnocuje !!!!!
%
function y = evaluate_polynomial_int(polynomial_coefficients, X)
tic
	y = interval_polynomial_form(polynomial_coefficients,X,@evaluate_polynomial);
toc
end
