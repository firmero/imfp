function tc = taylor_coefficients_(polynomial_coefficients, c)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  tc(1) = HF(p,c) ; tc(2) = HF(p`,c)/1! ; tc(3) = HF(p``,c)/2! ...
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
% assert n < 166 ... factorial

% allocate vector
tc = repmat(intval(0),1,n);
tc(1) = horner_form(polynomial_coefficients,intval(c));

% factorial
fact = 1;

for j = 2:n
	k = 2;
	polynomial_coefficients(n) = polynomial_coefficients(n-1);
	for i = n-1:-1:j
		polynomial_coefficients(i) = polynomial_coefficients(i-1)*k;
		k = k+1;
	end
	
	p = polynomial_coefficients(j:n);

	tc(j) = horner_form(p,intval(c)) / fact;
	fact = fact * j;

end

end
