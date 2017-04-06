function [ihf ver] = pvhornerenc(p, ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Compute Horner form of polynomial p over interval ix.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%         greater value leads to tighter enclosure
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  ihf ... Horner form
%  ver ... if 1 then Horner form do not overetimate
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  The implementation tests sufficient condition for non-overestimation
%  of Horner form. The result of test is returned by variable ver.
%
%  The condition is: if the intersection of io and interior of ix
%  is empty then Horner form is exact. 
%
%  io is the hull of all real x such that q_i(x) = 0 for some i in 1..n,
%  n = length(p). It's evident that 0 is in io, if degree is more than 0.
%
%  q_i is defined for i = 1..n:
%
%  q_1(x)     = a_1
%  q_i(x)     = q_(i-1)(x)*x + a_i  for i = 1..n
%
%  The range of Horner form of p is obviously q_n(ix).
%
%  The emptiness of intersection of io and interior of ix is equivalent
%  to satisfying the following conditions:
%
%  inf(x) >= 0 and inf(HF(q_i,x)) >= 0 for i=1..n
%    or	
%  sup(x) <= 0 and inf(sgn_i*HF(q_i,x)) >= 0 for i=1..n
%    where for j = 1..n
%      sgn_j =  1 if j is odd
%      sgn_j = -1 if j is even
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

ix = intval(ix);

% allocate vector for polynomial q
n = length(p);
iq = repmat(intval(0),1,n);

iq(1) = p(1);

for i = 2:n
	iq(i) = iq(i-1)*ix + p(i);
end

ihf = iq(n);

if (inf(ix) == sup(ix))
	ver = true;
	return
end

% testing disjointness of overestimation interval with ix
% trivial test
if (in0(0,ix) && n>1 )
	ver = false;
	return
end

% testing disjointness of overestimation interval with ix
if (inf(ix) >= 0)
	% on the right
	for i = 1:n
		if (inf(iq(i)) < 0)
			ver = false;
			return
		end
	end
else
	% on the left
	sgn = 1;
	for i = 1:n
		if (inf(sgn*iq(i)) < 0)
			ver = false;
			return
		end
		sgn = sgn * (-1);
	end
end

ver = true;
end
