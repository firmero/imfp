function res = horner_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@horner_form);
end
