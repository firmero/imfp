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
		certainly_ok = true
		return
	endif

	if (in(0,intval(x)))
		certainly_ok = false
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
% opakujuci sa kod??

function [hf, ok] = horner_without_zero(polynom_coefficients,x)

	n = length(polynom_coefficients);

	p(1) = intval(polynom_coefficients(1));

	for i = 2:n
			p(i) = p(i-1) * sup(x) + polynom_coefficients(i);
		%p(i) = p(i-1) * (x^1) + polynom_coefficients(i);
	endfor
    
	hf = p(n);
	ok = "todo";

endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%p = rand(1,1100)
x = infsup(0.3,0.5);
tic
[y,ok] = horner_simple(p, x)
toc

