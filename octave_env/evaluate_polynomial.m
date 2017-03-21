function y = evaluate_polynomial(polynomial_coefficients, X)

	ncpus = nproc();

	% assert ncpus != 0
	delta = (sup(X) - inf(X))/ncpus;

	coefficients = cell(1,ncpus);
	intervals = cell(1,ncpus);


	left = inf(X);
	for i = 1:ncpus
	
		% todo rounding
		setround(1);
		right = left + delta;
		intervals(i) = infsup(left,right);
		left = right;

		coefficients(i) = polynomial_coefficients;

	end

	a = parcellfun(ncpus, @evaluate_polynomial_, coefficients, intervals,...
			'UniformOutput', false, 'VerboseLevel', 0);

	y = a{1};
	for i=2:ncpus
		y = hull(y,a{i});
	end

end

