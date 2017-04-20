function ihfbz = pvhornerbzenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Horner form for ix containing 0
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
% .Todo.
%
%
%ENDDOC====================================================================

ix = intval(ix);
if (~in(0,ix))
	warning('Interval doesn''t contain 0');
	ihfbz = pvhornerenc(p,ix);
	return
end

ileft  = infsup(inf(ix),0);
iright = infsup(0,sup(ix));


% todo rucne?
ihfbz = hull(pvhornerlzenc(invert_polynomial(p),-ileft),...
		     pvhornerlzenc(p,iright));
end
