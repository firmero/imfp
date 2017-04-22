function isf = pvslopeenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%    Slope form of polynomial p over interval ix.
%  For polynomial p there exists uniquely defined polynomial q such that
%  p(x) = p(c) + q(x)*(x-c), where c = mid(ix). Polynomial q has smaller
%  degree by one.
%  
%  Slope form is defined as SF = p(c) + HF(q,ix)*(ix-c)
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval x
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  isf ... Slope form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Coefficients of polynomial q such that p(x) = p(c) + q(x)*(x-c)
%  n = length(p)
%
%  q(x) = q_1*x^(n-2) + q_2*x^(n-3) + .. + q_(n-2)*x + q_(n-1)
%
%  q_i = sum j=1..i a_j*c^(i-j) 
%
%  That can be computed using horner scheme:
%  q_1 = a_1
%  q_i = q_(i-1)*c + a_i,  i = 2..n-1
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
% .Todo.
%
%
%ENDDOC====================================================================

n = length(p);
if (n == 1)
	isf = p(1);
	return;
end

c = mid(ix);

% coefficients of polynomial q
iq = repmat(intval(0),1,n-1);
iq(1) = p(1);
for i = 2:n-1
	iq(i) = iq(i-1)*c + p(i);
end

iyhorner_q = pvihornerenc(iq,ix);

% iq_(n-1) = sum j=1..(n-1) a_j*c^(n-1-j) 
% p(n) = a_n
ip_at_c = iq(n-1)*c + p(n);

% SF = p(c) + HF(q,ix)*(ix-c)
isf = ip_at_c + iyhorner_q*(ix-c);

end
