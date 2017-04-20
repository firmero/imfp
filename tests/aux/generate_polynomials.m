function res = generate_polynomials(deg, n)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Returns n polynomials of degree deg with coefficients in (-1,1).
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  deg ... degree of a generated polynomial
%  n   ... count of polynomials
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  res ... n*(deg+1) matrix with elements in (-1,1)
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
%
%
if nargin < 2
	n=1;
end

res = 2*rand(n,deg+1) - 1;

end
