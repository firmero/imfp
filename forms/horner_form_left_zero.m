function res = horner_form_left_zero(polynomial_coefficients, X)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Horner form for X = [0,R]
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

n = length(polynomial_coefficients);
% allocate vector
p = repmat(intval(0),1,n);

p(1) = intval(polynomial_coefficients(1));

% setround(1);
xx = sup(X);

for i = 2:n

	if (inf(p(i-1)) < 0)
		setround(-1);
		left = p(i-1)*xx + polynomial_coefficients(i);
	else % save multiply by zero
		left = polynomial_coefficients(i);
	end

	if (sup(p(i-1)) > 0)
		setround(1);
		right = p(i-1)*xx + polynomial_coefficients(i);
	else
		right = polynomial_coefficients(i);
	end

	p(i) = infsup(inf(intval(left)), sup(intval(right)));

end

res = p(n);

end
