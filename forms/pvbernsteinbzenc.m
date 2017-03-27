function res = pvbernsteinbzenc(polynomial_coefficients,X,k)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Bernstein form for X containing 0.
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
%todo
k = -321;

if (~in(0,X))
	warning('Interval X doesn''t contain 0');
	res = pvbernsteinenc(polynomial_coefficients,X,k);
	return
end

if (k == -321)
	k = n-1;
elseif (k< n-1)
	warning('Parameter k should be at least the degree of polynomial');
	k = n-1;
end

right = pvbernsteinenc(polynomial_coefficients,infsup(0,sup(X)), k);

% coefficients for p(-x)
start = 1;
if (odd(n))
	start = start + 1;
end

for i = start:2:n
	polynomial_coefficients(i) = polynomial_coefficients(i) * (-1);
end

left = pvbernsteinenc(polynomial_coefficients,infsup(0,-inf(X)), k);

res = hull(left, right);

end
