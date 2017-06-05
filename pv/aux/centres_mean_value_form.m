function [c_down, c_up] = centres_mean_value_form(ip_derivated, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Computes optimal points c_down and c_up in sense of:
% 
%  For all t in ix it holds:
%
%	sup(MVF(p,c_up)) <= sup(MVF(p,t))
%	inf(MVF(p,c_down))  >= inf(MVF(p,t))
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
%  c_down  ... optimal point for lower bound of MVF
%  c_up    ... optimal point for upper bound of MVF
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%--------------------------------------------------------------------------
% .License.
%
%  Copyright (C) 2017  Charles University in Prague, Czech Republic
%
%  LIME 1.0 is free for private use and for purely academic purposes.
%  It would be very kind from the future user of LIME 1.0 to give
%  reference that this software package has been developed
%  by at Charles University, Czech Republic.
%
%  For any other use of LIME 1.0 a license is required.
%
%  THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED
%  WARRANTIES, INCLUDING, WITHOUT LIMITATIONS, THE IMPLIED WARRANTIES
%  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
%
%--------------------------------------------------------------------------
% .History.
%
%  2017-05-05  first version
%
%--------------------------------------------------------------------------
% .Todo.
%
%
%ENDDOC====================================================================

if (inf(ip_derivated) >= 0)
	c_down = inf(ix);
	c_up = sup(ix);
	return
end

if (sup(ip_derivated) <= 0)
	c_down = sup(ix);
	c_up = inf(ix);
	return
end

% else approximate, it is correct thanks to lemma of optimality
width = sup(ip_derivated) - inf(ip_derivated);
c_up = (sup(ip_derivated)*sup(ix) - inf(ip_derivated)*inf(ix))/width;
c_down  = (sup(ip_derivated)*inf(ix) - inf(ip_derivated)*sup(ix))/width;

end
