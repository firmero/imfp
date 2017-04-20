function iderivative = derivate_polynomial(ip)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Derivative of ip.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ip  ... vector of polynomial coefficients [ia_1 ... ia_n]
%
%	ip(x) = ia_1*x^(n-1) + ia_2*x^(n-2) + .. + ia_(n-1)*x^1 + ia_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iderivative ... vector of coefficients of derivative of ip
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
% .Todo.
%
%
%ENDDOC====================================================================

% the length of derivative
nn = length(ip) - 1;

iderivative = repmat(intval(0),1,nn);

% coeffcient produced by derivation
c = nn;
for i = 1:nn
	iderivative(i) = c * ip(i);
	c = c - 1;
end

if (nn == 0)
	iderivative(1) = intval(0);
end

end
