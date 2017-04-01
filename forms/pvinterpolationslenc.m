function iifsl = pvinterpolationslenc(p,ix)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Interpolation slope form works similar as interpolation form.
%  It uses uniquely defined polynomial gc(x) that:
%		p(x) = p(c) + p`(c)*(x-c) + gc(x)*(x-c)^2
%  !t evaluates gc over ix, and reduced previous equation to two parabolas.
%
%  ISF(X) = p(c) + [inf(parabola_down),sup(parabola_up)]
%
%  igc = HF(gc,ix)
%  c = mid(X)
%
%  parabola_up(x)   = p`(c)(x-c) + sup(igc)*(x-c)^2 
%					=	  sup(igc)*x^2
%						+ (p`(c)-2*sup(igc)*c)*x
%						+ (-p`(c)*c+sup(igc)*c^2)
%
%  parabola_down(x) = p`(c)(x-c) + inf(igc)*(x-c)^2 
%					=	  inf(igc)*x^2
%						+ (p`(c)-2*inf(igc)*c)*x
%						+ (-p`(c)*c+inf(igc)*c^2)
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iifsl ... Interpolation Slope form
%
%--------------------------------------------------------------------------
% .Implementation details.
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

if (n < 3)
	iifsl = pvhornerenc(p,ix);
	return;
end

% make interval coefficients
ip = repmat(intval(0),1,n);
for i = 1:n 
	ip(i) = intval(p(i));
end

c = mid(ix);
% eval HF(ip,c)
for i = 2:n
	ip(i) = ip(i) + c*ip(i-1);
end
% for i=1..n
%   ip(i) = a_i + sum j=1..i-1 c^j*a_(i-j)
%     e.g.  ip(4) = a_4 + c*a_3 + c^2*a_2 + c^3*a_1
% ip(n) = HF(ip,c)

for i = 2:n-1
	ip(i) = ip(i) + c*ip(i-1);
end
% for i=1..n-1
%   ip(i) = a_i + sum j=1..i-1 (j+1)*c^j*a_(i-j)
%     e.g.  ip(4) = a_4 + 2c*a_3 + 3c^2*a_2 + 4c^3*a_1
% ip(n-1) = HF(ip`,c)
% ip(n)   = HF(ip,c)

% compute HF(gc,ix)
% gc is uniquely defined polynomial:
% p(x) = p(c) + p`(x)*(x-c) + gc(x)*(x-c)^2 
% it can be proved that gc(x) = sum i=1..n-2 p(i)*x^(n-2-i)
% where in p are previously computed coefficients
igc = ip(1);
% igc = a_1
for i = 2:n-2
	igc = igc*ix + ip(i);
	% igc = sum j=1..i p(j)*ix^(i-j)
end
% igc = sum i=1..n-2 p(i)*ix^(n-2-i)

% coefficients for parabolas
t1 = intval(sup(igc))*c;
t2 = ip(n-1) - t1; 
% t2 = HF(ip`,c) - sup(igc)*c
a1_up = t2 - t1;
a0_up = -t2*c;
% a1_up = HF(ip`,c) - 2*sup(igc)*c
% a0_up = -HF(ip`,c)*c + sup(igc)*c^2


t1 = intval(inf(igc))*c;
t2 = ip(n-1) - t1; 
% t2 = HF(ip`,c) - inf(igc)*c
a1_down = t2 - t1;
a0_down = -t2*c;
% a1_down = HF(ip`,c) - 2*inf(igc)*c
% a0_down = -HF(ip`,c)*c + inf(igc)*c^2

ipar_up   = evaluate_parabola(sup(igc),a1_up,  a0_up,  ix);
ipar_down = evaluate_parabola(inf(igc),a1_down,a0_down,ix);

% ip(n)=HF(ip,c)
iifsl = ip(n) + hull(ipar_up,ipar_down);

end
