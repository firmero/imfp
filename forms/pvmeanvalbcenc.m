function res = pvmeanvalbcenc(polynomial_coefficients,X)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
% MVFB(p,X) = infsup(inf(HF(p,c_left)), sup(HF(p,c_right)))
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
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

p_derivated = derivate_polynomial(polynomial_coefficients);

hf_derivated = pvhornerenc(p_derivated,X);

[c_left, c_right] = centres_mean_value_form_(hf_derivated,X);

setround(1);
right = sup(pvhornerenc(polynomial_coefficients,intval(c_right))) ...
		+ sup(hf_derivated*(X-c_right));

setround(-1);
left = inf(pvhornerenc(polynomial_coefficients,intval(c_left))) ...
		+ inf(hf_derivated*(X-c_left));

res = infsup(left,right);

end
