%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Script remaps some INTLAB functions to Octave interval pkg's functions.
%  Not working when INTLAB paths are loaded.
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
1;

function ix = intval(x)
	ix = infsup(x);
end

function w = diam(ix)
	w = wid(ix);
end

function b = in(a,b)
	b = subset(a,b);
end

function b = in0(a,b)
	b = interior(a,b);
end

function b = isintval(x)
	b = isa(x,'infsup');
end

% todo
function setround(m)
	global ROUND_MOD;
	ROUND_MOD = m;
end

% todo
function m = getround
	global ROUND_MOD;
	m = ROUND_MOD;
end

function b = odd(n)
	b = 1 == mod(n,2);
end

function b = even(n)
	b = ~odd(n);
end

function b = isnan(x)
	b = isempty(x);
end
