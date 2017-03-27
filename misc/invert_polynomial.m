function op_polynomial = invert_polynomial(polynomial_coefficients)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Invert polynomial coefficients
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

sgn = -1;
op_polynomial(n) = polynomial_coefficients(n);

for i = n-1:-1:1
	op_polynomial(i) = sgn * polynomial_coefficients(i); 
	sgn = sgn * (-1);
end

end
