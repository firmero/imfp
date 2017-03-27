function imvfbc = pvmeanvalbcenc(p,ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Bicentred mean value form evaluates mean value form twice and intersect
%  results.
%
%   MVFB(p,ix) = [inf(MVFC(ix,c_left)), sup(MVFC(ix,c_right))]
%		where MVFC(ix,c) = HF(p,c) + HF(p`,ix)*(ix-c)
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
%  imvfbc ... Bicentred mean value form
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

p_derivated = derivate_polynomial(p);

hf_derivated = pvhornerenc(p_derivated,ix);

[c_left, c_right] = centres_mean_value_form_(hf_derivated,ix);

oldmod = getround();
setround(1);
right = sup(pvhornerenc(p,intval(c_right))) ...
		+ sup(hf_derivated*(ix-c_right));

setround(-1);
left = inf(pvhornerenc(p,intval(c_left))) ...
		+ inf(hf_derivated*(ix-c_left));

imvfbc = infsup(left,right);

setround(oldmod);
end
