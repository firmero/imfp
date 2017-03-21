function res = taylor_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@taylor_form);
end

