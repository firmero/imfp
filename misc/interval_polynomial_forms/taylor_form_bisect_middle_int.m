function res = taylor_form_bisect_middle_int(p,X)
	 res = interval_polynomial_form(p,X,@taylor_form_bisect_middle);
end
