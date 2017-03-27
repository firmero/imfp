function isf = pvslopeenc(p, ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%    The function computes range of Slope form of polynomial p over ix.
%  
%  c = mid(ix)
%  gc is uniquely defined polynomial such that: f(x) = f(c) + gc(x)*(x-c).
%  Then the slope form is defined SF = f(c) + HF(gc,ix)*(ix-c)
%
%  Coefficients of gc:
%  n = length(p)
%  gc(x) = b_1*x^(n-2) + b_2*x^(n-3) + ... + b_(n-2)*x + b_(n-1)
%
%  b_1 =  a_1 
%  b_2 =  a_1*c + a_2 
%  b_3 = (a_1*c + a_2)*c + a_3 
%  ...
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval x
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  isf ... Slope form
%
%--------------------------------------------------------------------------
% .License.
%
%  [license goes here]
%
%--------------------------------------------------------------------------
% .History.
%
%  2017-MM-DD   first version
%
%--------------------------------------------------------------------------
% .Todo
%
%
%ENDDOC====================================================================

n = length(p);
if (n == 1)
	isf = p(1);
	return;
end

c = mid(ix);

% get coefficients of polynom gc()
g = repmat(intval(0),1,n-1);

g(1) = p(1);
for i = 2:n-1
	g(i) = g(i-1)*c + p(i);
end

% todo intval coefficients? 
hf_g = pvhornerenc(g,ix);

p_at_c = g(n-1)*c + p(n);
isf = p_at_c + hf_g*(ix-c);

end
