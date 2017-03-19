
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

