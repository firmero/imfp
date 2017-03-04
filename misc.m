% not a function file:
% Prevent Octave from thinking that this
% is a function file:
1;

% todo rounding
% todo sparse polynoms, input form?
% certainly_ok if true then HF not overestimate, if precise arithmetic
function [hf, certainly_ok] = horner_simple(polynom_coefficients, x)

	n = length(polynom_coefficients);

	p(1) = intval(polynom_coefficients(1));

	% isnt it slow? append?
	for i = 2:n
		p(i) = p(i-1) * x + polynom_coefficients(i);
		%p(i) = p(i-1) * (x^1) + polynom_coefficients(i);
	endfor
    
	hf = p(n);

	if (inf(x) == sup(x))
		certainly_ok = true; % what if coefficients are intervals
		return
	endif

	if (in(0,intval(x)))
		certainly_ok = false; % what if coefficients are intervals
		return
	endif

	sgn = sign(polynom_coefficients(1));
	% not working on interval koefficients


	% !! duplicity of code
	if (inf(x) >= 0 )		% on right
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

function pplot(polynom, interval)

	x = linspace(inf(interval), sup(interval));
	y = polyval(polynom,x);
	min(y)
	max(y)
	plot(x, y);

endfunction

% intvalinit('displaymidrad')
% intvalinit('displayinfsup')
% format long

% if x is [0,R]
function [hf, certainly_ok] = horner_left_zero(polynom_coefficients, x)

	n = length(polynom_coefficients);

	p(1) = intval(polynom_coefficients(1));

	% getround(1);
	xx = sup(x);

	for i = 2:n

		if (inf(p(i-1)) < 0)
			getround(-1);
			left = p(i-1)*xx + polynom_coefficients(i);
		else % save multiply by zero
			left = polynom_coefficients(i);
		endif

		if (sup(p(i-1)) > 0)
			getround(1);
			right = p(i-1)*xx + polynom_coefficients(i);
		else
			right = polynom_coefficients(i);
		endif

		p(i) = infsup(inf(intval(left)), sup(intval(right)));

	endfor
	
	hf = p(n);
	certainly_ok = false;

endfunction

function op_polynomial = polynomial_opposite(polynom_coefficients)

	n = length(polynom_coefficients);

	sgn = -1;
	op_polynomial(n) = polynom_coefficients(n);

	for i = n-1:-1:1
		op_polynomial(i) = sgn * polynom_coefficients(i); 
		sgn *= (-1);
	endfor

endfunction

function [hf, certainly_ok] = horner_bisect_at_zero(polynom_coefficients, x)

	% todo check '0 in x'
	left_interval  = infsup(inf(x),0);
	right_interval = infsup(0,sup(x));

	hf = hull(horner_left_zero(polynomial_opposite(polynom_coefficients),
								-left_interval), 
			  horner_left_zero(polynom_coefficients,right_interval));

	certainly_ok = false;

endfunction

function f_derivated = derivate_polynom(polynom_coefficients)

	n = length(polynom_coefficients);

	% co je rychlejsie, downto or for, append
	for i = 1:n-1

		% rounding?
		f_derivated(i) = i * polynom_coefficients(i+1);

	endfor

endfunction

% poradie koeficienov?
function mvf = mean_value_form(polynom_coefficients, x)

	polynom_coefficients = fliplr(polynom_coefficients);
	c = mid(x);

	hf_at_center = horner_simple(polynom_coefficients,c);

	n = length(polynom_coefficients);


	f_derivated = derivate_polynom(polynom_coefficients,x);


	hf_derivated = horner_simple(fliplr(f_derivated), x);

	mvf = hf_at_center + hf_derivated*(x-c);

endfunction

% poradie?
function sf = slope_form(polynom_coefficients, x)

	polynom_coefficients = fliplr(polynom_coefficients);
	n = length(polynom_coefficients);
	c = mid(x);

	% get coefficients of polynom g()
	g(n-1) = polynom_coefficients(n);
	for i = n-1:-1:2
		g(i-1) = g(i)*c + polynom_coefficients(i);
	endfor

	%for testing purpose
	%{ 
	polynom_coefficients = fliplr(polynom_coefficients)
	g = fliplr(g)
	xx=2.345; ((polyval(polynom_coefficients,c) + polyval(g,xx)*(xx-c)) == \
				polyval(polynom_coefficients,xx))
	%} 


	hf_g = horner_simple(g,x);

	% what if interval coefficients?
	f_at_c = polyval(polynom_coefficients, c);

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
function mvfb = mean_value_form_bicentred(polynom_coefficients,x)

	polynom_coefficients = fliplr(polynom_coefficients);
	f_derivated = fliplr(derivate_polynom(polynom_coefficients));

	hf_derivated = horner_simple(f_derivated,x);

	[c_left, c_right] = centres_mean_value_form(hf_derivated,x);

	% to do rounding
	right = horner_simple(polynom_coefficients,c_right) + sup(hf_derivated*(x-c_right));
	left = horner_simple(polynom_coefficients,c_left) + inf(hf_derivated*(x-c_left));

	mvfb = infsup(inf(left),sup(right));

endfunction

%
%  tc(1) = hf(p,c), tc(2) = hf(p',c),...
%
function tc = taylor_coefficient(polynom_coefficients, c)

	n = length(polynom_coefficients);

	%tc = zeros(1,n);

	tc(1) = horner_simple(polynom_coefficients,c);

	fact = 1;

	for j = 2:n
		k = 2;
		polynom_coefficients(n) = polynom_coefficients(n-1);
		for i = n-1:-1:j
			polynom_coefficients(i) = polynom_coefficients(i-1)*k;
			k++;
		endfor
		
		p = polynom_coefficients(j:n);

		tc(j) = horner_simple(p,c) / fact;
		% todo overflow
		fact *= j;

	endfor

endfunction

function tf = taylor_form(polynom_coefficients, x)

	%todo check special cases for x

	c = mid(x);
	r = rad(x);

	n = length(polynom_coefficients);

	tay_coeff = taylor_coefficient(polynom_coefficients,c);

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

function y = evaluate_parallel(polynom_coefficients, x)

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

		coefficients(i) = polynom_coefficients;

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
function y = evaluate(polynom_coefficients, x)

	t = inf(x);
	y = intval(polyval(polynom_coefficients,t));

	while (t < sup(x))
		t += 0.0003;
		ny = polyval(polynom_coefficients,t);
		y = hull(y,ny);
	endwhile

	y = hull(y,polyval(polynom_coefficients,sup(x)));

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
		parabola_range = horner_simple([a2 a1 a0],x);
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
function res = interpolation_form(polynom_coefficients,x)
	
	f_derivated = fliplr(derivate_polynom(fliplr(polynom_coefficients)));
	f_twice_derivated = fliplr(derivate_polynom(fliplr(f_derivated)));

	c = mid(x);

	f_at_c = horner_simple(polynom_coefficients,c);
	f_derivated_at_c = horner_simple(f_derivated,c);
	f_twice_derivated_range = horner_simple(f_twice_derivated,x);

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

function res = modified_interpolation_form(polynom_coefficients,x) 
	f_derivated = fliplr(derivate_polynom(fliplr(polynom_coefficients)));
	f_twice_derivated = fliplr(derivate_polynom(fliplr(f_derivated)));

	c = mid(x);

	f_at_c = horner_simple(polynom_coefficients,c);
	f_derivated_at_c = horner_simple(f_derivated,c);
	f_twice_derivated_range = horner_simple(f_twice_derivated,x);

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
		disp "  HORNER ",horner_simple(p,x),sup(ans)-inf(ans), toc, 
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

%[y,ok] = horner_simple(p, x), toc
%y = horner_left_zero(p, x),toc
%horner_bisect_at_zero(p,x), toc

%p = [infsup(2,2.3), infsup(4,4.2)];
%horner_simple(p,x), toc

%disp "  HORNER ",horner_simple(p,x), toc
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

function res = bernstein_coefficients(polynom_coefficients,x)

	w = sup(x) - inf(x);
	n = length(polynom_coefficients);

	k = n-1; % todo

	% temporary, not bernstein coefficients
	b(1) = intval(1);

	for i = 2:n
		b(i) = b(i-1)*w/(k-i+2);
		w += w; % trick to simulate factorial
	endfor
	

	tc = taylor_coefficient(polynom_coefficients,inf(x));
	for i = 1:n
		b(i) = b(i)*tc(i);
	endfor

	res = b(1)
	for j = 1:k
		for i = 1:min(n-1,k-j+1)
			b(i) = b(i) + b(i+1);
		endfor
		res = hull(res,b(1));
		% b(1) is bernstein coeffcient b1,b2,b3,bj.. after a loop of j
		b(1)
	endfor
	

endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=infsup(0,1);
p = intval("-1 0.7 -0.2 0.9");

%tic, evaluate_parallel(p,x), toc

bernstein_coefficients(p,x)
