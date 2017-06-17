function [iy ver] = pvenc(p,ix,strategy)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Evaluates enclosure of range of polynomial over the input interval.
%  Using the third parameter can be specified approach of evaluating.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p        ... vector of polynomial coefficients [a_1 ... a_n]
%  ix       ... interval x
%  strategy ... optional, can be lowercase, default is EFFECTIVE,
%               one of the values: FASTEST, FASTER, EFFECTIVE, TIGHTER, TIGHTEST
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  iy       ... enclosure of range
%  ver      ... 1 when the used method was verified
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Strategy and the methods which are used for them:
%
%  FASTEST  - pvhornerenc or pvhornerbzenc (HF, HFBZ)
%  FASTER   - pvmeanvalbcenc (MVFBC)
%  EFFECTIVE - pvmeanvalbcenc (MVFBC) for x with 0,
%             otherwise pvinterpolation2enc (IF2)
%  TIGHTER  - pvinterpolationslenc (ISF)
%  TIGHTEST - pvbernsteinenc, pvbernsteinbzenc (BF, BFBZ)
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
verified = [];

switch strategy
	case 'FASTEST'
		if (in(0,ix))
			iy = pvhornerbzenc(p,ix);
		else
			[iy verified] = pvhornerenc(p,ix);
		end
	case 'FASTER'
		iy = pvmeanvalbcenc(p,ix);
	case 'TIGHTER'
		iy = pvinterpolationslenc(p,ix);
	case 'TIGHTEST'
		if (in(0,ix))
			[iy verified] = pvbernsteinbzenc(p,ix);
		else
			[iy verified] = pvbernsteinenc(p,ix);
		end
	otherwise
		% default
		if (in(0,ix))
			iy = pvmeanvalbcenc(p,ix);
		else
			iy = pvinterpolation2enc(p,ix);
		end
end

if (isempty(verified))
	ver = 0;
else 
	ver = verified;
end
