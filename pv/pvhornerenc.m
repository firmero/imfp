function [ihf ver] = pvhornerenc(p, ix)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Horner form over
%  interval.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%         greater value leads to tighter enclosure
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  ihf ... interval computed by Horner form
%  ver ... if 1 then Horner form do not overestimate
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
%  q_i(x)     = q_(i-1)(x)*x + a_i  for i = 2..n
%
%  The range of Horner form of p is obviously q_n(ix).
%
%  The emptiness of intersection of io and interior of ix is equivalent
%  to satisfying the following conditions:
%
%  inf(ix) >= 0 and inf(HF(q_i,ix)) >= 0 for i=1..n
%    or	
%  sup(ix) <= 0 and inf(sgn_i*HF(q_i,ix)) >= 0 for i=1..n
%    where sgn_j is defined for j = 1..n as:
%      sgn_j =  1 if j is odd
%      sgn_j = -1 if j is even
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
