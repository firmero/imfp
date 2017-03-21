function res = interval_polynomial_form_par(p,X,form)
	
	n = length(p);
	up = repmat(0,1,n);
	down = repmat(0,1,n);
	ncpus = nproc();

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

		intervals{1} = Y;
		intervals{2} = Y;

		coefficients{1} = down;
		coefficients{2} = up;

	else
		for i = 1:n
			up(i) = sup(p(i));
			down(i) = inf(p(i));
		end

		% compute over B
		intervals{1} = X;
		intervals{2} = X;

		coefficients{1} = down;
		coefficients{2} = up;

		pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
						'VerboseLevel', 0);

		res = infsup(inf(pack{1}),sup(pack{2}));
		return
	end

	if (sup(X) <= 0)

		pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
						'VerboseLevel', 0);

		res = infsup(inf(pack{1}),sup(pack{2}));
		return 
	end

	% compute over B
	% reuse previous state of up and down vector
	for i = n-1:-2:1
		up(i) = sup(p(i));
		down(i) = inf(p(i));
	end

	Y = infsup(0,sup(X));
	intervals{3} = Y;
	intervals{4} = Y;

	coefficients{3} = down;
	coefficients{4} = up;

	% left and right interval
	pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
					'VerboseLevel', 0);

	left_res = infsup(inf(pack{1}),sup(pack{2}));
	right_res = infsup(inf(pack{3}),sup(pack{4}));

	% A U B
	res = hull(left_res,right_res);

end
