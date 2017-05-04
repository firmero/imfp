%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  This script makes functions for evaluating range of interval polynomials
%  to use parallelism during execution (available in Octave, using pkg 
%  parallel).
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  The interval version of the certain form f
%  is call of interval_polynomial_form_par with f as handler.
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
1;
function res = pvihornerenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvhornerenc);
end

function res = pvihornerbzenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvhornerbzenc);
end

function res = pvimeanvalenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvmeanvalenc);
end

function res = pvislopeenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvslopeenc);
end

function res = pvimeanvalbcenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvmeanvalbcenc);
end

function res = pvitaylorenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvtaylorenc);
end

function res = pvitaylorbmenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvtaylorbmenc);
end

function res = pvibernsteinenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvbernsteinenc);
end

function res = pvibernsteinbzenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvbernsteinbzenc);
end

function res = pviinterpolationenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvinterpolationenc);
end

function res = pviinterpolation2enc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvinterpolation2enc);
end

function res = pviinterpolationslenc(ip,ix)
	 res = interval_polynomial_form_par(ip,ix,@pvinterpolationslenc);
end
