function [ibf ver] = pvbernsteinenc(p,ix,k)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Bernstein form
%  of polynomial over input interval.
%  Bernstein form is the hull of set of b_j for j=0..k,
%  b_j is j-th Bernstein coefficients of order k over ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%  k  ... optional, should be at least deg(p) (it is default value),
%         greater value leads to tighter enclosure
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  ibf ... interval computed by Bernstein form
%  ver ... 1 iff Bernstein form is exact, otherwise 0
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
%  The j-th Generalized Bernstein coefficient of p of order k over ix
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
%  Bernstein form is the hull of set of b_j for j=0..k.
%  That form doesn't overestimate if and if only max and min of b_j j=0..k
%  is in {b_0, b_k}.
%
%  Algorithm for computation of Bernstein coefficients uses the following
%  scheme:
%
%  d = degree of p
%  n = d + 1
%  
%  for i=1..n 
%   v_i_0 = width(ix)^(i-1) / (k over (i-1)) * tay_coeff((i-1),inf(ix))
%         =(width(ix)^(i-1) / (k*(k-1)*..*(k-i+2))) * (i-1)! *
%           * tay_coeff((i-1),inf(ix))
%
%  for j = 1..k-d                        v_n_j = v_n_0
%
%  for j = 1..k   i=1..min(n-1, k-j+1)   v_i_j = v_i_(j-1) + v_(i+1)_(j-1) 
%
%  Then b_j = v_1_j     for j=0..k
%
%  The implementation use only one dimensional array iv size of n.
%  Direction j symbolizes the j-th computation round. After the j-th loop
%  iv(i) = iv_i_j for all i where iv_i_j is defined.
%
%--------------------------------------------------------------------------
% .License.
%
%  Copyright (C) 2017  Charles University in Prague, Czech Republic
%
%  LIME 1.0 is free for private use and for purely academic purposes.
%  It would be very kind from the future user of LIME 1.0 to give
%  reference that this software package has been developed
%  by at Charles University, Czech Republic.
%
%  For any other use of LIME 1.0 a license is required.
%
%  THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED
%  WARRANTIES, INCLUDING, WITHOUT LIMITATIONS, THE IMPLIED WARRANTIES
%  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
%
%--------------------------------------------------------------------------
% .History.
%
%  2017-05-05  first version
%
%--------------------------------------------------------------------------
% .Todo.
%
%
%ENDDOC====================================================================

n = length(p);

% k should be at least n-1 (deg of polynomial)
if (nargin() == 2)
	k = n-1;
% not hadled bad calling
elseif (k < n-1)
	warning('Parameter k should be at least the degree of polynomial');
	k = n-1;
end

ix = intval(ix);
w = sup(ix) - inf(ix);

% used for computation of Bernstein coefficients
iv = repmat(intval(0),1,n);

% temporary, this doesn't represent all Bernstein coefficients
iv(1) = intval(1);

% to simulate factorial (i-1)! and w^(i-1)
q = w;

for i = 2:n
	iv(i) = iv(i-1)*q/(k-i+2);
	q = q + w; % trick to simulate factorial
end
% iv(1) = 1
% iv(i) = w^(i-1)*(i-1)! / (k*(k-1)*...*(k-i+2))   for i=2..n


itc = taylor_coefficients(p,inf(ix));
% itc(i) = HF( (i-1) derivative of p, inf(ix))/ (i-1)!
for i = 1:n
	iv(i) = iv(i)*itc(i);
end
% zero round (j=0) finished:
%   iv(i) = v_i_0   for i=1..n


% scheme to compute iteratively Bernstein coefficients
% after the j-th loop iv(1) is Bernstein coefficient b_j 

% v(n) is never modified, so after the j-th round 
% it holds that v_n_j = v_n_0 = v(n)

% now iv(1) = iv_1_0 = b_0
ibf = iv(1);
ib_0 = iv(1);
for j = 1:k
	for i = 1:min(n-1,k-j+1)
		iv(i) = iv(i) + iv(i+1);
	end

	% iv(1) = b_j
	ibf = hull(ibf,iv(1));
end
ib_k = iv(1);

% overestimation test
% are max and min of Bernstein coefficients from {b_0, b_k}?
itmp = hull(ib_0, ib_k);
if (itmp == ibf)
	ver = 1;
else 
	ver = 0;
end

end
