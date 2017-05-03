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
%  Using third parameter can be specified approach for evaluating.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  p        ... vector of polynomial coefficients [a_1 ... a_n]
%  ix       ... interval x
%  strategy ... optional, can be lowercase, default is EFECTIVE,
%               one of the values: FASTEST, FASTER, EFECTIVE, TIGHTER, TIGHTEST
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
%  EFECTIVE - pvmeanvalbcenc (MVFBC), pvinterpolation2enc (IF2)
%  TIGHTER  - pvinterpolationslenc (ISF)
%  TIGHTEST - pvbernsteinenc, pvbernsteinbzenc (BF, BFBZ)
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
