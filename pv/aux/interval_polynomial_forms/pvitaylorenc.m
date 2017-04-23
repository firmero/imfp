function iy = pvitaylorenc(ip,ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluate Taylor form of interval polynomial ip over ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ip ... vector of polynomial interval coefficients [ia_1 ... ia_n]
%  ix ... interval x
%
%	ip(x) = ia_1*x^(n-1) + ia_2*x^(n-2) + .. + ia_(n-1)*x^1 + ia_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iy ... range of Taylor form of interval polynomial ip over ix
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Wrapper function. It calls interval_polynomial_form with proper form
%  handler.
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

iy = interval_polynomial_form(ip,ix,@pvtaylorenc);

end
