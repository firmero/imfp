function resi = generate_polynomials_interval(deg, n, mid, max_radius)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Generates n polynomials of deg degree with interval coefficients.
%
%  Coefficients have middle in mid and radius < max_radius.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  deg        ... degree of generated polynomial
%  n          ... count of generated polynomials
%  max_radius ... coeffcient radius is less than max_radius
%  mid        ... coeffcient middle is in mid
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  resi ... n*(deg+1) matrix with interval coeffcients
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

if nargin < 2
	n = 1;
end
if nargin < 3
	mid=0;
end

if nargin < 4
	max_radius=0.5;
end

deg = deg + 1;
resi = repmat(repmat(intval(0),1,deg),n,1);
middles = zeros(1,deg);
radii = zeros(1,deg);

for i = 1:n 

	radii = max_radius*rand(1,deg)

	for j = 1:deg
		resi(i,j) = midrad(mid,radii(j));
	end

end

end
