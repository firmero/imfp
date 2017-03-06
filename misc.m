% Not a function file:
% Prevent Octave from thinking that this is a function file:
1;

% intvalinit('displaymidrad')
% intvalinit('displayinfsup')
% format long

%% start of misc

%
% The range of natural power over interval X (as a function) 
%
% To achieve:
%
%	[-8,1]=pow_3( [-2,1] )  !=  [-2,1]*[-2,1]*[-2,1]=[-8,4]
%
function res = interval_power(X,n)

	if (even(n))
		res = X^n;
		return
	endif

	res = infsup(inf(X)^n, sup(X)^n);

endfunction

function y = evaluate_parallel(polynomial_coefficients, x)

	ncpus = nproc();

	% assert ncpus != 0
	delta = (sup(x) - inf(x))/ncpus;

	coefficients = cell(1,ncpus);
	intervals = cell(1,ncpus);


	left = inf(x);
	for i = 1:ncpus
	
		% todo rounding
		getround(1);
		right = left + delta;
		intervals(i) = infsup(left,right);
		left = right;

		coefficients(i) = polynomial_coefficients;

	endfor

	a = parcellfun(ncpus, @evaluate, coefficients, intervals,"UniformOutput", false);

	y = a{1};

	for i=2:ncpus
		y = hull(y,a{i});
	endfor

endfunction

%
% x interval
% nadhodnocuje !!!!!
%
function y = evaluate(polynomial_coefficients, X)

	t = inf(X);
	y = intval(polyval(polynomial_coefficients,t));

	while (t < sup(X))
		t += 0.0003;
		ny = polyval(polynomial_coefficients,t);
		y = hull(y,ny);
	endwhile

	y = hull(y,polyval(polynomial_coefficients,sup(X)));

endfunction

%
% x is computed, y is referenced
%
function d = distance(x,y)% todo

	% to do if y i point?
	% todo check if x is subset of y

	if (!in(intval(y),intval(x)))
		d = -1;
		return
	endif

	getround(1);

	d = 1024*max(sup(x)-sup(y),inf(y)-inf(x)); % scale
	d /=(sup(y)-inf(y));

endfunction
%% end of misc

%% start of HORNER FORM

%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% Return:
%
%	res				- Horner form
%	certainly_ok	- if true then Horner form gives no overestimation 
%
function [res, certainly_ok] = horner_form(polynomial_coefficients, X)

	%{ 
	% gives better result but is expensive
	if (inf(X) < 0)
		res = horner_form_bisect_zero(polynomial_coefficients,X);
		certainly_ok = false;
		return
	endif
	%}

	n = length(polynomial_coefficients);
	% allocate vector
	p = repmat(intval(0),1,n);

	p(1) = intval(polynomial_coefficients(1));

	for i = 2:n
		p(i) = p(i-1) * X + polynomial_coefficients(i);
	endfor
    
	res = p(n);

	% tests for covering overestimation interval
	if (inf(X) == sup(X))
		certainly_ok = true; % what if coefficients are intervals
		return
	endif

	if (in(0,intval(X)))
		certainly_ok = false; % what if coefficients are intervals
		return
	endif

	
	if (isa(polynomial_coefficients(1),'intval'))
		certainly_ok = false;
		return
	endif
	% !! not working on interval coefficients !!
	sgn = sign(polynomial_coefficients(1));

	if (inf(X) >= 0 )		% on right
		for i = 2:n-1
			if (inf(sgn*p(i)) < 0)
				certainly_ok = false;
				return
			endif
		endfor
	else	% on left
		for i = 2:n-1
			sgn *= (-1);
			if (inf(sgn*p(i)) < 0)
				certainly_ok = false;
				return
			endif
		endfor
	endif

	certainly_ok = true;

endfunction

%
% Horner form for X = [0,R]
%
function res = horner_form_left_zero(polynomial_coefficients, X)

	n = length(polynomial_coefficients);
	% allocate vector
	p = repmat(intval(0),1,n);

	p(1) = intval(polynomial_coefficients(1));

	% getround(1);
	xx = sup(X);

	for i = 2:n

		if (inf(p(i-1)) < 0)
			getround(-1);
			left = p(i-1)*xx + polynomial_coefficients(i);
		else % save multiply by zero
			left = polynomial_coefficients(i);
		endif

		if (sup(p(i-1)) > 0)
			getround(1);
			right = p(i-1)*xx + polynomial_coefficients(i);
		else
			right = polynomial_coefficients(i);
		endif

		p(i) = infsup(inf(intval(left)), sup(intval(right)));

	endfor
	
	res = p(n);

endfunction

%
% Invert polynomial coefficients
%
function op_polynomial = invert_polynomial(polynomial_coefficients)

	n = length(polynomial_coefficients);

	sgn = -1;
	op_polynomial(n) = polynomial_coefficients(n);

	for i = n-1:-1:1
		op_polynomial(i) = sgn * polynomial_coefficients(i); 
		sgn *= (-1);
	endfor

endfunction

%
% Horner form for X containing 0
%
function res = horner_form_bisect_zero(polynomial_coefficients, X)

	if (!in(0,X))
		warning("Interval doesn't contain 0");
		res = horner_form(polynomial_coefficients,X);
		return
	endif

	left_interval  = infsup(inf(X),0);
	right_interval = infsup(0,sup(X));

	res = hull(horner_form_left_zero(invert_polynomial(polynomial_coefficients),
								-left_interval), 
			  horner_form_left_zero(polynomial_coefficients,right_interval));

endfunction

%% end of HORNER


%% start of MEAN VAL FORM

%
% Compute derivative of p(x)
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function p_derivated = derivate_polynomial(polynomial_coefficients)

	n = length(polynomial_coefficients);
	p_derivated = repmat(intval(0),1,n-1);

	for i = 1:n-1
		p_derivated(i) = (n-i) * polynomial_coefficients(i);
	endfor

endfunction

%
% Compute MVF(p,mid(X))
%
%	mvf = p(mid(X)) + HF(p',X)*(X-mid(X))
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% If 0 is not in HF(p',X) then range is without overestimation
%
function mvf = mean_value_form(polynomial_coefficients, X)

	c = mid(X);
	hf_at_center = horner_form(polynomial_coefficients,c);

	p_derivated = derivate_polynomial(polynomial_coefficients,X);

	hf_derivated = horner_form(p_derivated,X);

	mvf = hf_at_center + hf_derivated*(X-c);

endfunction

%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function res = slope_form(polynomial_coefficients, X)

	n = length(polynomial_coefficients);
	c = mid(X);

	%
	% gc(x) = b_1*x^(n-2) + b_2*x^(n-3) + ... + b_(n-2)*x + b_(n-1)
	%
	% b_1 =  a_1 
	% b_2 =  a_1*c + a_2 
	% b_3 = (a_1*c + a_2)*c + a_3 
	%

	% get coefficients of polynom gc()
	g = repmat(intval(0),1,n-1);

	g(1) = polynomial_coefficients(1);
	for i = 2:n-1
		g(i) = g(i-1)*c + polynomial_coefficients(i);
	endfor

	hf_g = horner_form(g,X);

	p_at_c = g(n-1)*c + polynomial_coefficients(n);
	res = p_at_c + hf_g*(X-c);

endfunction

%
% Computes optimal points c_left and c_right in sense of:
% 
% For all c in X it holds:
%
%	sup(MVF(p,c_right)) <= sup(MVF(p,c))
%	inf(MVF(p,c_left))  >= inf(MVF(p,c))
%
%	width(MVF(p,mid(X))) <= width(MVF(p,c)
%
function [c_left, c_right] = centres_mean_value_form(f_derivated, X)

	if (inf(f_derivated) >= 0)
		c_left = inf(X);
		c_right = sup(X);
		return
	endif

	if (sup(f_derivated) <= 0)
		c_left = sup(X);
		c_right = inf(X);
		return
	endif

	% else approximate, it is correct thanks to lemma of optimality
	width = sup(X) - inf(X);
	c_right = (sup(f_derivated)*sup(X) - inf(f_derivated)*inf(X))/width;
	c_left = (sup(f_derivated)*inf(X) - inf(f_derivated)*sup(X))/width;

endfunction

%
% MVFB(p,X) = infsup(inf(HF(p,c_left)), sup(HF(p,c_right)))
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function res = mean_value_form_bicentred(polynomial_coefficients,X)

	p_derivated = derivate_polynomial(polynomial_coefficients);

	hf_derivated = horner_form(p_derivated,X);

	[c_left, c_right] = centres_mean_value_form(hf_derivated,X);

	getround(1);
	right = sup(horner_form(polynomial_coefficients,c_right)) ...
			+ sup(hf_derivated*(X-c_right));

	getround(-1);
	left = inf(horner_form(polynomial_coefficients,c_left)) ...
			+ inf(hf_derivated*(X-c_left));

	res = infsup(left,right);

endfunction

%% end of MEAN VAL FORM

%% start of BERNSTEIN

%
% Return the hull of the j-th Bernstein polynomials of order k over X,
%	j = 0..k where k >= deg(p)
%
function res = bernstein_form(polynomial_coefficients,X, k = -321)

	w = sup(X) - inf(X);
	n = length(polynomial_coefficients);

	% k should be at least n-1 (deg of polynom)
	if (k == -321)
		k = n-1;
	elseif (k< n-1)
		warning("Parameter k should be at least the degree of polynomial");
		k = n-1;
	endif

	% temporary, not bernstein coefficients
	b(1) = intval(1);

	% to simulate factorial
	q = w;

	for i = 2:n
		b(i) = b(i-1)*q/(k-i+2);
		q += w; % trick to simulate factorial
	endfor
	
	tc = taylor_coefficients(polynomial_coefficients,inf(X));
	for i = 1:n
		b(i) = b(i)*tc(i);
	endfor

	% scheme to compute iteratively bernstein coefficients (stored in b(1))
	res = b(1);
	for j = 1:k
		for i = 1:min(n-1,k-j+1)
			b(i) = b(i) + b(i+1);
		endfor

		% b(1) is bernstein coeffcient <- b1,b2,b3,bj.. after the j-th loop
		res = hull(res,b(1));
	endfor

endfunction

%
% Bernstein form for X containing 0.
%
function res = bernstein_form_bisect_zero(polynomial_coefficients,X, k = -321)

	n = length(polynomial_coefficients);

	if (!in(0,X))
		warning("Interval X doesn't contain 0");
		res = bernstein_form(polynomial_coefficients,X,k);
		return
	endif

	if (k == -321)
		k = n-1;
	elseif (k< n-1)
		warning("Parameter k should be at least the degree of polynomial");
		k = n-1;
	endif

	right = bernstein_form(polynomial_coefficients,infsup(0,sup(X)), k);

	% coefficients for p(-x)
	start = 1;
	if (odd(n))
		start++;
	endif
	
	for i = start:2:n
		polynomial_coefficients(i) *= -1;
	endfor

	left = bernstein_form(polynomial_coefficients,infsup(0,-inf(X)), k);

	res = hull(left, right);

endfunction
%% end of BERNSTEIN

%% start of TAYLOR FORM

%
%  tc(1) = HF(p,c) ; tc(2) = HF(p`,c)/1! ; tc(3) = HF(p``,c)/2! ...
%
function tc = taylor_coefficients(polynomial_coefficients, c)

	n = length(polynomial_coefficients);
	% assert n < 166 ... factorial

	% allocate vector
	tc = repmat(intval(0),1,n);
	tc(1) = horner_form(polynomial_coefficients,c);

	% factorial
	fact = 1;

	for j = 2:n
		k = 2;
		polynomial_coefficients(n) = polynomial_coefficients(n-1);
		for i = n-1:-1:j
			polynomial_coefficients(i) = polynomial_coefficients(i-1)*k;
			k++;
		endfor
		
		p = polynomial_coefficients(j:n);

		tc(j) = horner_form(p,c) / fact;
		fact *= j;

	endfor

endfunction

%
%	c = mid(X)
%	r = rad(X)
%
%	p_series = sum i=0..deg(p) a(p,c,i)*x^i
%	g_series = sum i=1..deg(p) a(p,c,i)*x^(i-1)
%			where a(p,c,i) = HF(derivative(p,i),c)/i!
%
%	TF	= HF(p_series,X-c)
%		= p(c) + HF(g_series,X-c)*(X-c) = p(c) + mag(HF(g_series,X-c))*[-r,r]
%
function res = taylor_form(polynomial_coefficients, X)

	if (inf(X) == sup(X))
		res = horner_form(polynomial_coefficients,X);
		return
	endif

	c = mid(X);
	r = rad(X);

	n = length(polynomial_coefficients);
	tay_coeff = taylor_coefficients(polynomial_coefficients,c);

	getround(1);
	magnitude = mag(tay_coeff(n)) * r;

	% compute mag(HF(g_series,X-c))*[-r,r]
	% X - c == [-r,r]
	for i = n-1:-1:2
		magnitude = (magnitude + mag(tay_coeff(i)))*r;
	endfor

	% tay_coeff(1) == p(c)
	res = tay_coeff(1) + infsup(-magnitude, magnitude);

endfunction

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

%
%	TF	= HF(p_series,X-c)
%			X - c is centered interval
%
%	p_series(x) = sum i=0..deg(p) a(p,c,i)*x^i
%		where a(p,c,i) = HF(derivative(p,i),c)/i!
%
function res = taylor_form_bisect_middle(polynomial_coefficients, X)

	c = mid(X);

	n = length(polynomial_coefficients);
	tay_coeff = taylor_coefficients(polynomial_coefficients,c);

	% right half [0,|c|]
	getround(1);
	x =	sup(X) - c;
	R = _taylor_form_eval_half(tay_coeff,x);

	% left half [-|c|,0] -> [0,|c|] && p_series(-x)
	getround(-1);
	x = c - inf(X);

	% coefficients for p_series(-x)
	for i = 2:2:n
		tay_coeff(i) *= -1;
	endfor

	L = _taylor_form_eval_half(tay_coeff,x);

	res = hull(L,R);

endfunction

%% end of TAYLOR FORM

%% start of INTERPOLATION FORM

%
% Computes range of parabola a2*x^2 + a1*x + a0.
%
function parabola_range = evaluate_parabola(a2,a1,a0,X)
	
	if (in0(0,intval(a2)))
		parabola_range = (a2*X + a1)*X + a0;
		return
	endif

	mx = 0.5*a1;
	my = hull((a2*inf(X) + a1)*inf(X),(a2*sup(X) + a1)*sup(X));

	% contain X extrem point mx
	mxi = intersect(-mx/a2,X);
	if (!isnan(mxi))
		% extrem points
		my = hull(my,mx*mxi);
	endif

	parabola_range = my + a0;

endfunction

%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% m = mid(HF(p``,X))
% c = mid(X)
%
% IF(X) = HF(parabola,X) + 0.5*(HF(p``,X) - m)*(X-c)^2
%
% parabola(x) = 0.5*m*x^2 + (p`(c) - m*c)*x + (p(c) - p`(c)*c + 0.5*m*c^2)
%
function res = interpolation_form(polynomial_coefficients,X)
	
	p_derivated = derivate_polynomial(polynomial_coefficients);
	p_twice_derivated = derivate_polynomial(p_derivated);

	c = mid(X);

	p_at_c = horner_form(polynomial_coefficients,c);
	p_derivated_at_c = horner_form(p_derivated,c);
	p_twice_derivated_range = horner_form(p_twice_derivated,X);

	m = mid(p_twice_derivated_range);

	% parabola coefficients
	a2 = 0.5*m;
	a1 = p_derivated_at_c - m*c;
	a0 = (a2*c - p_derivated_at_c)*c + p_at_c;

	parabola_range = evaluate_parabola(a2,a1,a0,X);

	getround(1);
	r = mag(X-c);
	res = parabola_range + (p_twice_derivated_range - m)*infsup(0,0.5*r*r);

endfunction

%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% IF2(X) = [inf(p_down),sup(p_up)]
%
% IF2(X) is subset of IF(X)
%
% c = mid(X)
%
% p_up(x)   = p(c) + p`(c)(x-c) + 0.5*sup(HF(p``,X))*(x-c)^2 
%  = p(c)	+ 0.5*sup(HF(p``,X))*x^2 
%			+ (p`(c) - sup(HF(p``,X))*c)*x 
%			+ (0.5*sup(HF(p``,X)*c - p`(c))*c
%  = p(c) + p2(X)
%
% p_down(x) = p(c) + p`(c)(x-c) + 0.5*inf(HF(p``,X))*(x-c)^2
%  = p(c)	+ 0.5*inf(HF(p``,X))*x^2 
%			+ (p`(c) - inf(HF(p``,X))*c)*x 
%			+ (0.5*inf(HF(p``,X)*c - p`(c))*c
%  = p(c) + p1(X)
%
function res = interpolation_form2(polynomial_coefficients,X) 

	p_derivated = derivate_polynomial(polynomial_coefficients);
	p_twice_derivated = derivate_polynomial(p_derivated);

	c = mid(X);

	p_at_c = horner_form(polynomial_coefficients,c);
	p_derivated_at_c = horner_form(p_derivated,c);
	p_twice_derivated_range = horner_form(p_twice_derivated,X);

	% parabola coefficients for polynomials par_up
	a2 = 0.5*p_twice_derivated_range;

	a2_up = sup(a2);
	a2_down = inf(a2);

	a1_up = p_derivated_at_c - intval(sup(p_twice_derivated_range))*c;
	a1_down = p_derivated_at_c - intval(inf(p_twice_derivated_range))*c;

	a0_up = (a2_up*c - p_derivated_at_c)*c;
	a0_down = (a2_down*c - p_derivated_at_c)*c;

	p1 = evaluate_parabola(a2_up,a1_up,a0_up,X);
	p2 = evaluate_parabola(a2_down,a1_down,a0_down,X);

	res = hull(p1,p2) + p_at_c;

endfunction

%
%
%
function res = interpolation_slope_form(polynomial_coefficients,X)

	n = length(polynomial_coefficients);
	% todo special cases

	p = repmat(intval(0),1,n);
	for i = 1:n 
		p(i) = intval(polynomial_coefficients(i));
	endfor
	
	c = mid(X);
	for i = 2:n
		p(i) = p(i) + c*p(i-1);
	endfor

	for i = 2:n-1
		p(i) = p(i) + c*p(i-1);
	endfor

	H = p(1);

	for i = 2:n-2
		H = H*X + p(i);
	endfor

	HC_up = intval(sup(H))*c;
	H1_up = p(n-1) - HC_up; 
	a1_up = H1_up - HC_up;
	a0_up = -H1_up*c;

	HC_down = intval(inf(H))*c;
	H1_down = p(n-1) - HC_down; 
	a1_down = H1_down - HC_down;
	a0_down = -H1_down*c;


	p1 = evaluate_parabola(sup(H),a1_up,a0_up,X);
	p2 = evaluate_parabola(inf(H),a1_down,a0_down,X);

	res = hull(p1,p2) + p(n);

endfunction

%% end of INTERPOLATION FORM

%distance(infsup(0.040,0.069), infsup(0.05,0.055))
%distance(infsup(0.041,0.069), infsup(0.05,0.055))
%distance(infsup(0.040,0.068), infsup(0.05,0.055))
%distance(infsup(0.041,0.068), infsup(0.05,0.055))

x=infsup(-0.3,0.2);

p = rand(1,5);
p = p - 0.5;

tic, evaluate_parallel(p,x), %toc
%tic, horner_form(p,x), toc
tic, horner_form_bisect_zero(p,x), %toc
%tic, mean_value_form(p,x), toc
%tic, slope_form(p,x), toc
%tic, mean_value_form_bicentred(p,x), toc
%tic, taylor_form(p,x), toc
%tic, taylor_form_bisect_middle(p,x), toc
%tic, bernstein_form(p,x), %toc
tic, bernstein_form_bisect_zero(p,x), %toc
%tic, interpolation_form(p,x), %toc
tic, interpolation_form2(p,x), %toc
tic, interpolation_slope_form(p,x), %toc


