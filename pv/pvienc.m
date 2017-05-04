function iy = pvienc(ip,ix,strategy)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of interval polynomial over the input interval.
%  Using the third parameter can be specified approach of evaluating.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  ip       ... vector of polynomial interval coefficients [ia_1 ... ia_n]
%  ix       ... interval x
%  strategy ... optional, can be lowercase, default is EFECTIVE,
%               one of the values: FASTEST, FASTER, EFECTIVE, TIGHTER, TIGHTEST
%
%	ip(x) = ia_1*x^(n-1) + ia_2*x^(n-2) + .. + ia_(n-1)*x^1 + ia_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iy ... enclosure of range
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Strategy and the methods which are used for them:
%
%  FASTEST  - pvihornerbzenc (iHFBZ)
%  FASTER   - pvislopeenc (iSF)
%  EFECTIVE - pvimeanvalbcenc (iMVFBC)
%  TIGHTER  - pviinterpolationslenc (iISF)
%  TIGHTEST - pvibernsteinenc (iBF)
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

% not handled bad calling
if (nargin() == 2)
	strategy = 'DEFUALT';
end

strategy = upper(strategy);

switch strategy
	case 'FASTEST'
		iy = pvihornerbzenc(ip,ix);
	case 'FASTER'
		iy = pvislopeenc(ip,ix);
	case 'TIGHTER'
		iy = pviinterpolationslenc(ip,ix);
	case 'TIGHTEST'
		iy = pvibernsteinenc(ip,ix);
	otherwise
		% default
		iy = pvimeanvalbcenc(ip,ix);
end
