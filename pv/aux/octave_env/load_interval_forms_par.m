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
1;
function res = pvihornerenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvhornerenc);
end

function res = pvihornerbzenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvhornerbzenc);
end

function res = pvimeanvalenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvmeanvalenc);
end

function res = pvislopeenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvslopeenc);
end

function res = pvimeanvalbcenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvmeanvalbcenc);
end

function res = pvitaylorenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvtaylorenc);
end

function res = pvitaylorbmenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvtaylorbmenc);
end

function res = pvibernsteinenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvbernsteinenc);
end

function res = pvibernsteinbzenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvbernsteinbzenc);
end

function res = pviinterpolationenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvinterpolationenc);
end

function res = pviinterpolation2enc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvinterpolation2enc);
end

function res = pviinterpolationslenc(p,ix)
	 res = interval_polynomial_form_par(p,ix,@pvinterpolationslenc);
end
