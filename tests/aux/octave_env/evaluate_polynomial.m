function y = evaluate_polynomial(polynomial_coefficients, X)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
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

ncpus = nproc();

% assert ncpus != 0
delta = (sup(X) - inf(X))/ncpus;

coefficients = cell(1,ncpus);
intervals = cell(1,ncpus);


left = inf(X);
for i = 1:ncpus

	% todo rounding
	setround(1);
	right = left + delta;
	intervals(i) = infsup(left,right);
	left = right;

	coefficients(i) = polynomial_coefficients;

end

a = parcellfun(ncpus, @evaluate_polynomial_, coefficients, intervals,...
		'UniformOutput', false, 'VerboseLevel', 0);

y = a{1};
for i=2:ncpus
	y = hull(y,a{i});
end

end
