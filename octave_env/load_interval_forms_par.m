%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
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
% .Todo
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

function res = pvimeanvalslenc(p,X)
	 res = interval_polynomial_form_par(p,X,@pvmeanvalslenc);
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
