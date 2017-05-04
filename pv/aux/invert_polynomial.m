function pi = invert_polynomial(p)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Invert polynomial coefficients.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p ... vector of polynomial coefficients [a_1 ... a_n]
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  pi ... if n is odd then it returns 
%                         [  a_1 -a_2  a_3 .. -a_(n-1) a_n]
%                    else [ -a_1  a_2 -a_3 .. -a_(n-1) a_n]
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

n = length(p);

sgn = -1;
pi(n) = p(n);

for i = n-1:-1:1
	pi(i) = sgn * p(i); 
	sgn = sgn * (-1);
end

end
