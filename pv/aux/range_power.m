function iy = range_power(ix,n)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  The range of natural power over interval ix (as a function).
%
%  To achieve:
%
%	[-8,1] = range_power([-2,1],3)  !=  [-2,1]*[-2,1]*[-2,1]=[-8,4]
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval
%  n  ... natural number
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iy ... the range of n-th power function over ix
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

if (even(n))
	iy = ix^n;
	return
end

iy = infsup(inf(ix)^n, sup(ix)^n);

end
