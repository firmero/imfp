function res = horner_form_bisect_zero(polynomial_coefficients, X)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Horner form for X containing 0
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%--------------------------------------------------------------------------
% .License.
%
%  [license goes here]
%
%--------------------------------------------------------------------------
% .History.
%
%  2017-MM-DD   first version
%
%--------------------------------------------------------------------------
% .Todo
%
%
%ENDDOC====================================================================

if (~in(0,X))
	warning('Interval doesn''t contain 0');
	res = horner_form(polynomial_coefficients,X);
	return
end

left_interval  = infsup(inf(X),0);
right_interval = infsup(0,sup(X));

res = hull(horner_form_left_zero(invert_polynomial(polynomial_coefficients),...
							-left_interval), ...
		  horner_form_left_zero(polynomial_coefficients,right_interval));
end
