function res = mean_value_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@mean_value_form);
end

