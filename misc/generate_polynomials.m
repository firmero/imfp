%
% Returns n polynomials of degree deg with coefficients in (-1,1)
%
function res = generate_polynomials(deg, n)

	%todo n=1

	deg = deg + 1;
	res = zeros(n,deg);

	for i = 1:n
		res(i,:) = rand(1,deg) - 0.5;
	end

end


