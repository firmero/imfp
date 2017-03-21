function res = mean_value_form_bicentred_int(p,X)
	 res = interval_polynomial_form(p,X,@mean_value_form_bicentred);
end

