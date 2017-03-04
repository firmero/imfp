% Not a function file:
% Prevent Octave from thinking that this is a function file:
1;


% intvalinit('displaymidrad')
% intvalinit('displayinfsup')
% format long
% allocate vector
% p = repmat(intval(0),1,n);

%%%-------------------------------------------------------------

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

%% start of HORNER FORM

%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% Return:
%
%	hf				- Horner form
%	certainly_ok	- if true then Horner form gives no overestimation 
%
function [hf, certainly_ok] = horner_form(polynomial_coefficients, X)

	%{ 
	% gives better result but is expensive
	if (inf(X) < 0)
		hf = horner_form_bisect_zero(polynomial_coefficients,X);
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
    
	hf = p(n);

	% tests for covering overestimation interval
	if (inf(X) == sup(X))
		certainly_ok = true; % what if coefficients are intervals
		return
	endif

	if (in(0,intval(X)))
		certainly_ok = false; % what if coefficients are intervals
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
function hf = horner_form_left_zero(polynomial_coefficients, X)

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
	
	hf = p(n);

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
function hf = horner_form_bisect_zero(polynomial_coefficients, X)

	if (!in(0,X))
		error("Interval doesn't contain 0")
		return
	endif

	left_interval  = infsup(inf(X),0);
	right_interval = infsup(0,sup(X));

	hf = hull(horner_form_left_zero(invert_polynomial(polynomial_coefficients),
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
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function mvf = mean_value_form(polynomial_coefficients, x)

	c = mid(x);
	hf_at_center = horner_form(polynomial_coefficients,c);

	p_derivated = derivate_polynomial(polynomial_coefficients,x);

	hf_derivated = horner_form(p_derivated,x);

	mvf = hf_at_center + hf_derivated*(x-c);

endfunction

%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
function sf = slope_form(polynomial_coefficients, x)

	n = length(polynomial_coefficients);
	c = mid(x);


	% get coefficients of polynom g()
	g = repmat(intval(0),1,n-1);

	g(n-1) = polynomial_coefficients(n);
	for i = n-1:-1:2
		g(i-1) = g(i)*c + polynomial_coefficients(i);
	endfor

	%for testing purpose
	%{ 
	polynomial_coefficients = fliplr(polynomial_coefficients)
	g = fliplr(g)
	xx=2.345; ((polyval(polynomial_coefficients,c) + polyval(g,xx)*(xx-c)) == \
				polyval(polynomial_coefficients,xx))
	%} 


	hf_g = horner_form(g,x);

	% what if interval coefficients?
	f_at_c = polyval(polynomial_coefficients, c);

	sf = f_at_c + hf_g*(x-c);

endfunction

function [c_left, c_right] = centres_mean_value_form(f_derivated, x)

	if (inf(f_derivated) >= 0)
		c_left = inf(x);
		c_right = sup(x);
		return
	endif

	if (sup(f_derivated) <= 0)
		c_left = sup(x);
		c_right = inf(x);
		return
	endif

	% else approximate

	c_right = (sup(f_derivated)*sup(x) - inf(f_derivated)*inf(x))/width;
	c_left = (sup(f_derivated)*inf(x) - inf(f_derivated)*sup(x))/width;

	% todo check rounding

endfunction

% poradie?
function mvfb = mean_value_form_bicentred(polynomial_coefficients,x)

	polynomial_coefficients = fliplr(polynomial_coefficients);
	f_derivated = fliplr(derivate_polynomial(polynomial_coefficients));

	hf_derivated = horner_form(f_derivated,x);

	[c_left, c_right] = centres_mean_value_form(hf_derivated,x);

	% to do rounding
	right = horner_form(polynomial_coefficients,c_right) + sup(hf_derivated*(x-c_right));
	left = horner_form(polynomial_coefficients,c_left) + inf(hf_derivated*(x-c_left));

	mvfb = infsup(inf(left),sup(right));

endfunction

%% end of MEAN VAL FORM
%
%  tc(1) = hf(p,c), tc(2) = hf(p',c),...
%
function tc = taylor_coefficient(polynomial_coefficients, c)

	n = length(polynomial_coefficients);

	%tc = zeros(1,n);

	tc(1) = horner_form(polynomial_coefficients,c);

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
		% todo overflow
		fact *= j;

	endfor

endfunction

function tf = taylor_form(polynomial_coefficients, x)

	%todo check special cases for x

	c = mid(x);
	r = rad(x);

	n = length(polynomial_coefficients);

	tay_coeff = taylor_coefficient(polynomial_coefficients,c);

	% magnitude....
	% rounding...
	magnitude = mag(tay_coeff(n)) * r;

	for i = n:-1:2
		magnitude = (magnitude + mag(tay_coeff(i)))*r;
	endfor

	%tay_coeff(1)
	% disp " [-magnitude, magnitude]", infsup(-magnitude, magnitude)

	tf = tay_coeff(1) + infsup(-magnitude, magnitude);

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
%
function y = evaluate(polynomial_coefficients, x)

	t = inf(x);
	y = intval(polyval(polynomial_coefficients,t));

	while (t < sup(x))
		t += 0.0003;
		ny = polyval(polynomial_coefficients,t);
		y = hull(y,ny);
	endwhile

	y = hull(y,polyval(polynomial_coefficients,sup(x)));

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

function parabola_range = evaluate_parabola(a2,a1,a0,x)
	
	if (in0(0,x))
		parabola_range = horner_form([a2 a1 a0],x);
		return
	endif

	mx = 0.5*a1;
	my = hull((a2*inf(x)+a1)*inf(x),(a2*sup(x)+a1)*sup(x));

	% contain x extrem point mx
	mxi = intersect(-mx/a2,x);
	if (!isnan(mxi))
		my = hull(my,mx*mxi);
	endif

	parabola_range = my + a0;

endfunction

%
% a_1*x^n + a_2*x^(n-1) + ... + a_(n+1)
%
% [ a_1 a_2 ... a_(n+1) ]
%
function res = interpolation_form(polynomial_coefficients,x)
	
	f_derivated = fliplr(derivate_polynomial(fliplr(polynomial_coefficients)));
	f_twice_derivated = fliplr(derivate_polynomial(fliplr(f_derivated)));

	c = mid(x);

	f_at_c = horner_form(polynomial_coefficients,c);
	f_derivated_at_c = horner_form(f_derivated,c);
	f_twice_derivated_range = horner_form(f_twice_derivated,x);

	m = mid(f_twice_derivated_range);

	% parabola coefficients
	a2 = 0.5*m;
	a1 = f_derivated_at_c - m*c;
	a0 = (a2*c - f_derivated_at_c)*c + f_at_c;

	parabola_range = evaluate_parabola(a2,a1,a0,x);

	getround(1);
	r = mag(x-c);
	res = parabola_range + (f_twice_derivated_range - m)*infsup(0,0.5*r*r);

endfunction

function res = modified_interpolation_form(polynomial_coefficients,x) 
	f_derivated = fliplr(derivate_polynomial(fliplr(polynomial_coefficients)));
	f_twice_derivated = fliplr(derivate_polynomial(fliplr(f_derivated)));

	c = mid(x);

	f_at_c = horner_form(polynomial_coefficients,c);
	f_derivated_at_c = horner_form(f_derivated,c);
	f_twice_derivated_range = horner_form(f_twice_derivated,x);

	m = mid(f_twice_derivated_range);

	% parabola coefficients
	a2 = 0.5*f_twice_derivated_range;

	a2_up = a2;
	a2_down = a2;


	a1_up = f_derivated_at_c - sup(f_twice_derivated_range)*c;
	a1_down = f_derivated_at_c - inf(f_twice_derivated_range)*c;

	a0_up = (a2_up*c - f_derivated_at_c)*c;
	a0_down = (a2_down*c - f_derivated_at_c)*c;

	p1 = evaluate_parabola(a2_up,a1_up,a0_up,x);
	p2 = evaluate_parabola(a2_down,a1_down,a0_down,x);

	res = hull(p1,p2) + f_at_c;

endfunction

function test1

	%tic, evaluate_parallel(p,x), toc
	n = 1
	MP = random(n,10);

	for i = 1:n
		p = MP(i,:);
		x = infsup(-0.2,0.3);

		evaluate_parallel(p,x);
		disp "  HORNER ",horner_form(p,x),sup(ans)-inf(ans), toc, 
		disp "  MEAV_VAL ",mean_value_form(p,x),sup(ans)-inf(ans), toc
		disp "  MEAN_SLOPE ",slope_form(p,x),sup(ans)-inf(ans), toc
		%disp "  MEAN_BICENTRED ", mean_value_form_bicentred(p,x),sup(ans)-inf(ans), toc
		disp "  TAYLOR ", taylor_form(p,x),sup(ans)-inf(ans), toc

		disp "  INTERPOLATION ",interpolation_form(p,x), sup(ans)-inf(ans),toc
		disp "  MOD_INTERPOLATION ",modified_interpolation_form(p,x), sup(ans)-inf(ans),toc
	endfor

endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%p = rand(1,1100);
%p = [1026,-470,53,-0.5];	% [-11,5261, 1.2642]
%p = [infsup(1026,1026.002),-470,infsup(53,53.001),-0.5];
p = [4,3,6];				% [5.7400, 6.7601]

x = infsup(-0.1,0.2);
tic

%[y,ok] = horner_form(p, x), toc
%y = horner_left_zero(p, x),toc
%horner_form_bisect_zero(p,x), toc

%p = [infsup(2,2.3), infsup(4,4.2)];
%horner_form(p,x), toc

%disp "  HORNER ",horner_form(p,x), toc
%disp "  MEAV_VAL ",mean_value_form(p,x), toc
%disp "  MEAN_SLOPE ",slope_form(p,x), toc
%disp "  MEAN_BICENTRED ", mean_value_form_bicentred(p,x), toc
%disp "  TAYLOR ", taylor_form(p,x), toc
%tic, evaluate_parallel(p,x), toc
%tic, evaluate(p,x), toc

%distance(infsup(0.040,0.069), infsup(0.05,0.055))
%distance(infsup(0.041,0.069), infsup(0.05,0.055))
%distance(infsup(0.040,0.068), infsup(0.05,0.055))
%distance(infsup(0.041,0.068), infsup(0.05,0.055))

%disp "  INTERPOLATION ",interpolation_form(p,x), toc
%disp "  MOD_INTERPOLATION ",modified_interpolation_form(p,x), toc
%test1


%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res = bernstein_coefficients(polynomial_coefficients,x)

	w = sup(x) - inf(x);
	n = length(polynomial_coefficients);

	% k should be at least n-1 (deg of polynom)
	k = n-1; % todo

	% temporary, not bernstein coefficients
	b(1) = intval(1);

	% to simulate factorial
	q = w;

	for i = 2:n
		b(i) = b(i-1)*q/(k-i+2);
		q += w; % trick to simulate factorial
	endfor
	
	tc = taylor_coefficient(polynomial_coefficients,inf(x));
	for i = 1:n
		b(i) = b(i)*tc(i);
	endfor

	res = b(1)
	for j = 1:k
		for i = 1:min(n-1,k-j+1)
			%printf("i j  %d %d\n", i,j);
			b(i) = b(i) + b(i+1);
		endfor

		% b(1) is bernstein coeffcient b1,b2,b3,bj.. after a loop of j
		res = hull(res,b(1));
	endfor


endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=infsup(-0.3,0.2);

p = rand(1,7);
p = p - 0.5;

tic, evaluate_parallel(p,x), toc
tic, horner_form(p,x), toc
tic, mean_value_form(p,x), toc
tic, slope_form(p,x), toc

%tic, evaluate_parallel(p,x), toc


%bernstein_coefficients(p,x)
%horner_form(p,x)

