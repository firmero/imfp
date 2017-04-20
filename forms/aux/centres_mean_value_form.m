function [c_left, c_right] = centres_mean_value_form(ip_derivated, ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Computes optimal points c_left and c_right in sense of:
% 
%  For all t in ix it holds:
%
%	sup(MVF(p,c_right)) <= sup(MVF(p,t))
%	inf(MVF(p,c_left))  >= inf(MVF(p,t))
%
%	width(MVF(p,mid(ix))) <= width(MVF(p,t))
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ip_derivated ... the range of derivative polynomial p over ix
%  ix           ... interval x
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  c_left  ... the left optimal point for MVF
%  c_right ... the right optimal point for MVF
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

if (inf(ip_derivated) >= 0)
	c_left = inf(ix);
	c_right = sup(ix);
	return
end

if (sup(ip_derivated) <= 0)
	c_left = sup(ix);
	c_right = inf(ix);
	return
end

% else approximate, it is correct thanks to lemma of optimality
width = sup(ix) - inf(ix);
c_right = (sup(ip_derivated)*sup(ix) - inf(ip_derivated)*inf(ix))/width;
c_left  = (sup(ip_derivated)*inf(ix) - inf(ip_derivated)*sup(ix))/width;

end
