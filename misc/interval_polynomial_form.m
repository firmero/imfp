function res = interval_polynomial_form(p,X,form)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
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

n = length(p);
up = repmat(0,1,n);
down = repmat(0,1,n);

if (inf(X) < 0)

	for i = n:-2:1
		up(i) = sup(p(i));
		down(i) = inf(p(i));
	end

	for i = n-1:-2:1
		up(i) = inf(p(i));
		down(i) = sup(p(i));
	end

	% compute over A
	bound = min(sup(X),0);
	Y = infsup(inf(X), bound);

	left_max = form(up,Y);
	left_min = form(down,Y);
	left_res = infsup(inf(left_min),sup(left_max));
else
	for i = 1:n
		up(i) = sup(p(i));
		down(i) = inf(p(i));
	end

	% compute over B
	right_max = form(up,X);
	right_min = form(down,X);

	res = infsup(inf(right_min),sup(right_max));
	return
end

if (sup(X) <= 0)
	res = left_res;
	return 
end

% compute over B
% reuse previous state of up and down vector
for i = n-1:-2:1
	up(i) = sup(p(i));
	down(i) = inf(p(i));
end

Y = infsup(0,sup(X));
right_max = form(up,Y);
right_min = form(down,Y);

right_res = infsup(inf(right_min),sup(right_max));

% A U B
res = hull(left_res,right_res);

end
