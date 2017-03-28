function ibf = pvbernsteinenc(p,ix,k)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Return the hull of the j-th Bernstein polynomials of order k over X,
%    j = 0..k where k >= deg(p)
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ix ... interval x
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  k  ... optional, should be at least deg(p), which is default value.
%         greater value leads to tighter enclosure
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  ibf ... Bernstein form
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  The j-th Generalized Bernstein polynomial of order k over ix is defined
%  as: 
%
%  p_j(x) = (k choose j)*(x-inf(ix))^j*(sup(ix)-x)^(k-j) / width(ix)^k
%  
%  Generalized Bernstein polynomials p_j for j=0..k forms a basis of the
%  vector space of polynomials of degree <= k. So, k in the call should be
%  at least degree of p.
%
%  The j-th Generalized Bernstein coeffcient of p of order k over ix
%  is defined as:
%
%  b_j = sum i=0..j (j over i)/(k over i)*tay_coeff(i,inf(ix))*width(ix)^i
%
%    where tay_coeff(i,z) = (i-th derivative of p at z) / i!
%
%  Polynomial p can be rewritten as
%
%  p(x) = sum j=0..k  b_j * p_j(x)
%
%  Bernstein form is a hull of set of b_j for j=0..k.
%  That form doesn't overestimate if and if only max and min of b_j j=0..k
%  is in {b_0, b_k}.
%
%  Algorithm for computation of Bernstein coefficients uses the following
%  scheme:
%
%  d = degree of p
%
%  for i=1..d+1
%   b_i_0 = width(ix)^(i-1) / (k over (i-1)) * tay_coeff((i-1),inf(ix))
%         =(width(ix)^(i-1) / (k*(k-1)*...*(k-i+2))) * (i-1)! *
%           * tay_coeff((i-1),inf(ix))
%
%  for j = 1..k-d                      b_(d+1)_j = b_(d+1)_0
%
%  for j = 1..k   i=0..min(d-1, k-j)   b_i_j = b_i_(j-1) + b_(i+1)_(j-1)   
%
%  Then b_j = b_1_j     for j=0..k
%
%  The implementation use only one dimensional array b.
%  Direction j symboles a j-th computation round. todo
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

% k should be at least n-1 (deg of polynomial)
if (nargin() == 2)
	k = n-1;
elseif (k< n-1)
	warning('Parameter k should be at least the degree of polynomial');
	k = n-1;
end

w = sup(ix) - inf(ix);

% used for computation of bernstein coefficients
ib = repmat(intval(0),1,n);

% temporary, this doesn't represent all bernstein coefficients
ib(1) = intval(1);
% ib(1) = ib_1_1

% to simulate factorial
q = w;
for i = 2:n
	ib(i) = ib(i-1)*q/(k-i+2);
	q = q + w; % trick to simulate factorial
end
% ib(1) = 1
% ib(i) = w^(i-1)*(i-1)! / (k*(k-1)*...*(k-i+2))   for i=2..n


tc = taylor_coefficients_(p,inf(ix));
% tc(i) = HF( (i-1) derivative of p, inf(ix))/ (i-1)!
for i = 1:n
	ib(i) = ib(i)*tc(i);
end
% first round finished:
%   ib(i) = b_i_1   for i=1..d+1

% scheme to compute iteratively bernstein coefficients (stored in ib(1))
ibf = ib(1);
for j = 1:k
	for i = 1:min(n-1,k-j+1)
		ib(i) = ib(i) + ib(i+1);
	end

	% ib(1) is bernstein coeffcient <- b1,b2,b3,bj.. after the j-th loop
	ibf = hull(ibf,ib(1));
end

end
