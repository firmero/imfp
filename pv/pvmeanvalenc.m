function imvf = pvmeanvalenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Mean value form of polynomial p over interval ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  itf ... Mean value form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  From the mean value theorem: for all x and c in ix exists q in ix 
%  such that p(x) = p(c) + p`(q)*(x-c), therefore p(x) is in 
%  p(c) + p`(ix)*(x-c). Then p(ix) is subset of p(c) + p`(ix)*(ix-c).
%  Mean value form is a special case when c = mid(iX);
%
%	MVF(p,mid(ix)) = p(mid(ix)) + HF(p',ix)*(ix-mid(ix))
%
%  The midpoint of ix is optimal. For all t in ix it holds that
%  width(MVF(p,mid(ix))) <= width(MVF(p,t))
%
%  If 0 is not in HF(p',ix) then range is without overestimation.
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

c = mid(ix);
ihf_at_center = pvhornerenc(p,c);

% the interval coefficients of derivative of p
p_iderivated = derivate_polynomial(p);

ihf_derivated = pvhornerenc(p_iderivated,ix);

imvf = ihf_at_center + ihf_derivated*(ix-c);

end
