function res = bernstein_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@bernstein_form);
end

