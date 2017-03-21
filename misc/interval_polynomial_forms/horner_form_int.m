function res = horner_form_int(p,X)
	 res = interval_polynomial_form(p,X,@horner_form);
end
