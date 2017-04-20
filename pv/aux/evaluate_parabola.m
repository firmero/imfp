function iy = evaluate_parabola(ia,ib,ic,ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  The range of parabola p(x)= ia*x^2 + ib*x + ic over interval ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ia ...
%  ib ...
%  ic ...
%        coefficients of parabola p(x) = ia*x^2 + ib*x + ic.
%
%  ix ... interval x
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iy ... the range of the input parabola over ix.
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
ia = intval(ia);

% if 0 is in ia then we cannot divide something by ia
if (in(0,ia))
	iy = (ia*ix + ib)*ix + ic;
	return
end

% will be used for x coordinates of local extrem
imx = ib/2;

% eval ia*x^2 + ib*x at endpoints of ix:
imy = hull((ia*inf(ix) + ib)*inf(ix), (ia*sup(ix) + ib)*sup(ix));

% parabola has local extrem point in -b/2a
% contain ix local extrem points?
ixextr = intersect(-imx/ia,ix);
if (~isnan(ixextr))
	% non empty intersect
	% ixextr has values as -b/2a
	% so imx*ixextr has values as -b^2/4a
	imy = hull(imy,imx*ixextr);
end

% if ix doesn't contain extrem point from ixextr, iy is value at endpoints,
% where imy = ia*x^2 + ib*x, then it is needed to add ic.
% Else imy contains values from endpoints and also values as -b^2/4a
% at local extrem points, also it is needed to add ic.
% Vertex of parabola has coordinates [-b/2a, c-b^2/4a]
iy = imy + ic;

end
