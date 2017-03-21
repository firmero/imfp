%
% Generates n polynomials of deg degree with interval coefficients.
%
% Coefficients have middle in (-mid,mid) and radius in (-max_radius, max_radius)
%
function res = generate_polynomials_interval(deg, n, max_radius, midd)

	%todo n=1; 	
	% todo not default ...
	max_radius=0.4; midd=4;

	deg = deg + 1;
	res = repmat(repmat(intval(0),1,deg),n,1);
	middles = zeros(1,deg);
	radii = zeros(1,deg);

	midd = 2*midd;

	for i = 1:n 

		middles = midd*(rand(1,deg)-0.5);
		radii = max_radius*rand(1,deg);

		for j = 1:deg
			res(i,j) = midrad(middles(j),radii(j));
		end

	end
end

