function res = horner_form_bisect_zero_int(p,X)
	 res = interval_polynomial_form(p,X,@horner_form_bisect_zero);
end
