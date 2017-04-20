function imvfbc = pvmeanvalbcenc(p,ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Bicentred mean value form of polynomial p over interval ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval x
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n.
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  imvfbc ... Bicentred mean value form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Bicentred mean value form evaluates mean value form twice and constructs
%  final range.
%  MVF = p(c) + HF(p',ix)*(ix-c), where c = mid(ix)
%  MVFB uses as c optimal points c_left and c_right, than for all t in ix
%  it holds:
%
%	sup(MVF(p,c_right)) <= sup(MVF(p,t))
%	inf(MVF(p,c_left))  >= inf(MVF(p,t))
%
%  MVFB(p,ix) = [inf(MVFC(ix,c_left)), sup(MVFC(ix,c_right))]
%		where MVFC(ix,t) = HF(p,t) + HF(p`,ix)*(ix-t)
%
%  If 0 is not in interior of HF(p',ix) then range is without
%  overestimation.
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

% the interval coefficients of derivative of p
p_iderivated = derivate_polynomial(p);

ihf_derivated = pvhornerenc(p_iderivated,ix);

% find optimal points
[c_left, c_right] = centres_mean_value_form_(ihf_derivated,ix);

oldmod = getround();
setround(1);
right = sup(pvhornerenc(p,c_right)) ...
		+ sup(ihf_derivated*(ix-c_right));

setround(-1);
left = inf(pvhornerenc(p,c_left)) ...
		+ inf(ihf_derivated*(ix-c_left));

imvfbc = infsup(left,right);

setround(oldmod);
end
