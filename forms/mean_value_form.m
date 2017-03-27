function mvf = mean_value_form(polynomial_coefficients, X)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
% Compute MVF(p,mid(X))
%
%	mvf = p(mid(X)) + HF(p',X)*(X-mid(X))
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% If 0 is not in HF(p',X) then range is without overestimation
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

c = mid(X);
hf_at_center = horner_form(polynomial_coefficients,c);

p_derivated = derivate_polynomial(polynomial_coefficients);

hf_derivated = horner_form(p_derivated,X);

mvf = hf_at_center + hf_derivated*(X-c);

end
