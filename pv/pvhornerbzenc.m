function ihfbz = pvhornerbzenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Horner form for ix containing 0.
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
%  ihfbz ... Horner form with bisection at the zero
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Bisection at the zero reduces problem to evaluation of two Horner form
%  over intervals [0,t] (t = sup(ix), t = -inf(ix)). That does not need
%  interval arithmetic. Overall it's slower than Horner form without
%  bisection, but can give tighter interval.
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

ix = intval(ix);
if (~in(0,ix))
	warning('notzero','Interval doesn''t contain 0');
	ihfbz = pvhornerenc(p,ix);
	return
end

ileft  = infsup(0,-inf(ix));
iright = infsup(0,sup(ix));

ihfbz = hull(pvhornerlzenc(invert_polynomial(p),ileft),...
		     pvhornerlzenc(p,iright));

end
