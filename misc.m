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
		certainly_ok = true; % what if coeficients are intervals
		return
	endif

	if (in(0,intval(x)))
		certainly_ok = false; % what if coeficients are intervals
		return
	endif

	sgn = sign(polynom_coefficients(1));
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

% poradie koeficienov?
function mvf = mean_value_form(polynom_coefficients, x)

	polynom_coefficients = fliplr(polynom_coefficients);
	c = mid(x);

	hf_at_center = horner_simple(polynom_coefficients,c);

	n = length(polynom_coefficients);

	% co je rychlejsie, downto or for
	for i = 1:n-1

		% rounding?
		f_derivated(i) = i * polynom_coefficients(i+1);

	endfor

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

	f_at_c = polyval(polynom_coefficients, c);

	sf = f_at_c + hf_g*(x-c);

endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%p = rand(1,1100);
%p = [1026,-470,53,-0.5];
p = [4,3,6];
x = infsup(-0.1,0.2);

tic

%[y,ok] = horner_simple(p, x), toc
%y = horner_left_zero(p, x),toc
%horner_bisect_at_zero(p,x), toc

%p = [infsup(2,2.3), infsup(4,4.2)];
%horner_simple(p,x), toc

%horner_simple(p,x), toc
%mean_value_form(p,x), toc
slope_form(p,x), toc
