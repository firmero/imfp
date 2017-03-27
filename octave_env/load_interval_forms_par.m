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
function res = horner_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@horner_form);
end

function res = horner_form_bisect_zero_int(p,X)
	 res = interval_polynomial_form_par(p,X,@horner_form_bisect_zero);
end

function res = mean_value_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@mean_value_form);
end

function res = mean_value_slope_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@mean_value_slope_form);
end

function res = mean_value_form_bicentred_int(p,X)
	 res = interval_polynomial_form_par(p,X,@mean_value_form_bicentred);
end

function res = taylor_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@taylor_form);
end

function res = taylor_form_bisect_middle_int(p,X)
	 res = interval_polynomial_form_par(p,X,@taylor_form_bisect_middle);
end

function res = bernstein_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@bernstein_form);
end

function res = bernstein_form_bisect_zero_int(p,X)
	 res = interval_polynomial_form_par(p,X,@bernstein_form_bisect_zero);
end

function res = interpolation_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@interpolation_form);
end

function res = interpolation_form2_int(p,X)
	 res = interval_polynomial_form_par(p,X,@interpolation_form2);
end

function res = interpolation_slope_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@interpolation_slope_form);
end
