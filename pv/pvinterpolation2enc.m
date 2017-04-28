function iif2 = pvinterpolation2enc(p,ix) 
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial using Interpolation form 2
%  of polynomial over interval.
%  Interpolation form 2 gives not worse result as Interpolation form.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p  ... vector of polynomial coefficients [a_1 ... a_n]
%  ix ... interval x
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iif2 ... interval computed by Interpolation form 2
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Interpolation form follows from:
%  p(x) = p(c) + p`(c)*(x-c) + 0.5*p``(y)*(x-c)^2,
%    where c = mid(ix), y is between c and x.
%
%  IF2(ix) = [ inf(p_down(ix)), sup(p_up(ix)) ]
%
%  p_up(x)	= p(c) + p`(c)(x-c) + 0.5*sup(HF(p``,ix))*(x-c)^2 
%			= p(c) + parabola_up(x)
%
%    parabola_up(x) =	  0.5*sup(HF(p``,ix))*x^2 
%						+ (p`(c) - sup(HF(p``,ix))*c)*x 
%						+ (0.5*sup(HF(p``,ix)*c - p`(c))*c
%
%  p_down(x)= p(c) + p`(c)(x-c) + 0.5*inf(HF(p``,ix))*(x-c)^2
%			= p(c) + parabola_down(x)
%
%    parabola_down(x) =	  0.5*inf(HF(p``,ix))*x^2 
%						+ (p`(c) - inf(HF(p``,ix))*c)*x 
%						+ (0.5*inf(HF(p``,ix)*c - p`(c))*c
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

% interval coefficients of derivative of p
ip_der = derivate_polynomial(p);

% interval coefficients of the second derivative of p
ip_der2 = derivate_polynomial(ip_der);

c = mid(ix);

% to find out parabolas coeffcients the following values are needed
% p(c), p`(c) and p``(ix)
ip_at_c = pvhornerenc(p,c);
ip_der_at_c = pvhornerenc(ip_der,c);
ip_der2_val = pvhornerenc(ip_der2,ix);

% parabola coefficients
ia2 = 0.5*ip_der2_val;

ia2_up   = intval(sup(ia2));
ia1_up   = ip_der_at_c - intval(sup(ip_der2_val))*c;
ia0_up   = (ia2_up*c - ip_der_at_c)*c;

ia2_down = intval(inf(ia2));
ia1_down = ip_der_at_c - intval(inf(ip_der2_val))*c;
ia0_down = (ia2_down*c - ip_der_at_c)*c;

iparabola_up   = evaluate_parabola(ia2_up  ,ia1_up,  ia0_up  ,ix);
iparabola_down = evaluate_parabola(ia2_down,ia1_down,ia0_down,ix);

% IF2(ix)    = [ inf(p_down(ix)), sup(p_up(ix)) ]
% p_up(ix)   = p(c) + parabola_up(ix)
% p_down(ix) = p(c) + parabola_down(ix)
iif2 = hull(iparabola_down,iparabola_up) + ip_at_c;

end
