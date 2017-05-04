function y = evaluate_polynomial_(polynomial_coefficients, X)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
% X interval
% nadhodnocuje !!!!!
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
%  Copyright (C) 2017  Charles University in Prague, Czech Republic
%
%  LIME 1.0 is free for private use and for purely academic purposes.
%  It would be very kind from the future user of LIME 1.0 to give
%  reference that this software package has been developed
%  by at Charles University, Czech Republic.
%
%  For any other use of LIME 1.0 a license is required.
%
%  THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED
%  WARRANTIES, INCLUDING, WITHOUT LIMITATIONS, THE IMPLIED WARRANTIES
%  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
%
%--------------------------------------------------------------------------
% .History.
%
%  2017-05-05  first version
%
%--------------------------------------------------------------------------
% .Todo.
%
%
%ENDDOC====================================================================

delta = 0.0003;

t = inf(X);
y = eval_at_point_(polynomial_coefficients,t);

t = t + delta;
while (t < sup(X))

	ny = eval_at_point_(polynomial_coefficients,t);

	y = hull(y,ny);

	t = t + delta;
end

y = hull(y,eval_at_point_(polynomial_coefficients,sup(X)));

end

function y = eval_at_point_(polynomial_coefficients, x)

	y = (polynomial_coefficients(1));

	for i = 2:length(polynomial_coefficients)
		y = y*x + polynomial_coefficients(i);
	end

end
