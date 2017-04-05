function resi = generate_polynomials_interval(deg, n, max_radius, mag_mid)
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
%  Coefficients have middle in (-mag_mid,mag_mid) and radius < max_radius.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  deg        ... degree of generated polynomial
%  n          ... count of generated polynomials
%  max_radius ... coeffcient radius is less than max_radius
%  mag_mid    ... coeffcient middle is in (-mag_mid,mag_mid), mag_mid >=0
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
	max_radius=0.4;
end

if nargin < 4
	mag_mid=-0.1;
end

deg = deg + 1;
resi = repmat(repmat(intval(0),1,deg),n,1);
middles = zeros(1,deg);
radii = zeros(1,deg);

mag_mid = 2*mag_mid;

for i = 1:n 

	middles = mag_mid*(rand(1,deg)-0.5);
	radii = max_radius*rand(1,deg);

	for j = 1:deg
		resi(i,j) = midrad(middles(j),radii(j));
	end

end

end
