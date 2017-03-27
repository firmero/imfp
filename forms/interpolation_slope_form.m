function res = interpolation_slope_form(polynomial_coefficients,X)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
% Vector polynomial_coefficients [a_1, a_2, ..., a_n] is interpreted as polynom:
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + ... + a_(n-1)*x^1 + a_n
%
% ISF(X) = [inf(p_down),sup(p_up)]
%
% c = mid(X)
%
% p_up(x)   = p(c) + p`(c)(x-c) + sup(G)*(x-c)^2 
%			= sup(G) + (p`(c)-2*sup(G)*c)*x + (p(c)-p`(c)*c+sup(G)*c^2)
%
% p_down(x) = p(c) + p`(c)(x-c) + inf(G)*(x-c)^2 
%			= inf(G) + (p`(c)-2*inf(G)*c)*x + (p(c)-p`(c)*c+inf(G)*c^2)
%
% G = HF(g(c,x)), g(c,x) is uniquely defined polynomial that:
% 
%	p(x) = p(c) + p`(c)*(x-c) + g(c,x)*(x-c)^2
%
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%--------------------------------------------------------------------------
% .Output parameters.
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

n = length(polynomial_coefficients);

if (n < 3)
	res = horner_form(polynomial_coefficients,X);
	return;
end

p = repmat(intval(0),1,n);
for i = 1:n 
	p(i) = intval(polynomial_coefficients(i));
end

c = mid(X);
for i = 2:n
	p(i) = p(i) + c*p(i-1);
end
% p(n) = HF(p,c)

for i = 2:n-1
	p(i) = p(i) + c*p(i-1);
end
% p(n-1) = HF(p`,c)
% p(n)   = HF(p,c)

G = p(1);
for i = 2:n-2
	G = G*X + p(i);
end

GC_up = intval(sup(G))*c;
tmp = p(n-1) - GC_up; 
a1_up = tmp - GC_up;
a0_up = -tmp*c;

GC_down = intval(inf(G))*c;
tmp = p(n-1) - GC_down; 
a1_down = tmp - GC_down;
a0_down = -tmp*c;

p1 = evaluate_parabola(sup(G),a1_up,a0_up,X);
p2 = evaluate_parabola(inf(G),a1_down,a0_down,X);

res = hull(p1,p2) + p(n);

end
