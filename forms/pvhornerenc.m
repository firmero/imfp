function [res, certainly_ok] = pvhornerenc(polynomial_coefficients, ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%
%  Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
%  Return:
%
%	res				- Horner form
%	certainly_ok	- if true then Horner form gives no overestimation 
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval x
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
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

ix = intval(ix);

n = length(polynomial_coefficients);
if (n < 1)
	res = intval(0);
	certainly_ok = true;
	return
end
% allocate vector
p = repmat(intval(0),1,n);

p(1) = intval(polynomial_coefficients(1));

for i = 2:n
	p(i) = p(i-1) * ix + polynomial_coefficients(i);
end

res = p(n);

% tests for covering overestimation interval
if (inf(ix) == sup(ix))
	certainly_ok = true; % what if coefficients are intervals
	return
end

if (in(0,intval(ix)))
	certainly_ok = false; % what if coefficients are intervals
	return
end


if (isa(polynomial_coefficients(1),'intval'))
	certainly_ok = false;
	return
end

% !! not working on interval coefficients !!
sgn = sign(polynomial_coefficients(1));

if (inf(ix) >= 0 )		% on right
	for i = 2:n-1
		if (inf(sgn*p(i)) < 0)
			certainly_ok = false;
			return
		end
	end
else	% on left
	for i = 2:n-1
		sgn = sgn * (-1);
		if (inf(sgn*p(i)) < 0)
			certainly_ok = false;
			return
		end
	end
end

certainly_ok = true;
end
