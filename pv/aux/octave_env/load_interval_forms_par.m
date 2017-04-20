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
function res = pvihornerenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvhornerenc);
end

function res = pvihornerbzenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvhornerbzenc);
end

function res = pvimeanvalenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvmeanvalenc);
end

function res = pvislopeenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvslopeenc);
end

function res = pvimeanvalbcenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvmeanvalbcenc);
end

function res = pvitaylorenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvtaylorenc);
end

function res = pvitaylorbmenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvtaylorbmenc);
end

function res = pvibernsteinenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvbernsteinenc);
end

function res = pvibernsteinbzenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvbernsteinbzenc);
end

function res = pviinterpolationenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvinterpolationenc);
end

function res = pviinterpolation2enc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvinterpolation2enc);
end

function res = pviinterpolationslenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvinterpolationslenc);
end
