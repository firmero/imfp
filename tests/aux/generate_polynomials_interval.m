function resi = generate_polynomials_interval(deg, n, max_radius, mag_mid)
%BEGINDOC==================================================================
% .Author.
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
%  defualt n is 1, max_radius 0.05, and mag_mid 0.9
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

if nargin < 2
	n = 1;
end
if nargin < 3
	max_radius=0.05;
end

if nargin < 4
	mag_mid=0.9;
end

deg = deg + 1;
% works for intlab, but not for octave interval pkg
% resi = repmat(repmat(intval(0),1,deg),n,1);
resi = intval(zeros(n,deg));

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
