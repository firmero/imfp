%
% Return the hull of the j-th Bernstein polynomials of order k over X,
%	j = 0..k where k >= deg(p)
%
function res = bernstein_form(polynomial_coefficients,X,k)

	%todo
	k = -321;
	w = sup(X) - inf(X);
	n = length(polynomial_coefficients);

	% k should be at least n-1 (deg of polynom)
	if (k == -321)
		k = n-1;
	elseif (k< n-1)
		warning('Parameter k should be at least the degree of polynomial');
		k = n-1;
	end

	% temporary, not bernstein coefficients
	b(1) = intval(1);

	% to simulate factorial
	q = w;

	for i = 2:n
		b(i) = b(i-1)*q/(k-i+2);
		q = q + w; % trick to simulate factorial
	end
	
	tc = taylor_coefficients_(polynomial_coefficients,inf(X));
	for i = 1:n
		b(i) = b(i)*tc(i);
	end

	% scheme to compute iteratively bernstein coefficients (stored in b(1))
	res = b(1);
	for j = 1:k
		for i = 1:min(n-1,k-j+1)
			b(i) = b(i) + b(i+1);
		end

		% b(1) is bernstein coeffcient <- b1,b2,b3,bj.. after the j-th loop
		res = hull(res,b(1));
	end

end


