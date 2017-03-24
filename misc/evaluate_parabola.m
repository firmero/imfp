%
% Computes range of parabola a2*x^2 + a1*x + a0.
%
function parabola_range = evaluate_parabola(a2,a1,a0,X)
	
	if (in0(0,intval(a2)))
		parabola_range = (a2*X + a1)*X + a0;
		return
	end

	mx = 0.5*a1;
	my = hull((a2*inf(X) + a1)*inf(X),(a2*sup(X) + a1)*sup(X));

	% contain X extrem point mx
	mxi = intersect(-mx/a2,X);
	if (~isnan(mxi))
		% extrem points
		my = hull(my,mx*mxi);
	end

	parabola_range = my + a0;

end

