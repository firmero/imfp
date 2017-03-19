%
% This function is used by taylor_form_bisect_middle(), which converts
% his input interval to centered interval [-r,r], then it calls this function
% twice and returns hull of results returned by that function.
%
% r >= 0
%
function res = _taylor_form_eval_half(tay_coeff,r)

	n = length(tay_coeff);

	left = inf(tay_coeff(n));
	right = sup(tay_coeff(n));

	for i = n-1:-1:1

		getround(1);
		if (right > 0)
			right = right*r + sup(tay_coeff(i));
		else 
			% choose 0 to maximize
			right = sup(tay_coeff(i));
		endif

		getround(-1);
		if (left < 0)
			left = left*r + inf(tay_coeff(i));
		else
			% choose 0 to minimize
			left = inf(tay_coeff(i));
		endif

	endfor

	res = infsup(left,right);

endfunction

