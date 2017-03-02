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
		t += 0.00003;
		ny = polyval(polynom_coefficients,t);
		y = hull(y,ny);
	endwhile

	y = hull(y,polyval(polynom_coefficients,sup(x)));

endfunction

%
% x is computed, y is referenced
%
function d = distance(x,y)

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%p = rand(1,1100);
p = [1026,-470,53,-0.5];
%p = [infsup(1026,1026.002),-470,infsup(53,53.001),-0.5];
%p = [4,3,6];
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

distance(infsup(0.040,0.069), infsup(0.05,0.055))
distance(infsup(0.041,0.069), infsup(0.05,0.055))
distance(infsup(0.040,0.068), infsup(0.05,0.055))
distance(infsup(0.041,0.068), infsup(0.05,0.055))

