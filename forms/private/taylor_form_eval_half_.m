function res = taylor_form_eval_half_(tay_coeff,r)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%
% This function is used by pvtaylorbm(), which converts
% his input interval to centered interval [-r,r], then it calls this function
% twice and returns hull of results returned by that function.
%
% r >= 0
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

n = length(tay_coeff);

oldmod = getround();

%todo inf as built-in function!!
left = inf(tay_coeff(n));
right = sup(tay_coeff(n));

for i = n-1:-1:1

	setround(1);
	if (right > 0)
		right = right*r + sup(tay_coeff(i));
	else 
		% choose 0 to maximize
		right = sup(tay_coeff(i));
	end

	setround(-1);
	if (left < 0)
		left = left*r + inf(tay_coeff(i));
	else
		% choose 0 to minimize
		left = inf(tay_coeff(i));
	end

end

res = infsup(left,right);

setround(oldmod);
end
