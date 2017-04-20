%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Script remaps some INTLAB functions to Octave interval pkg's functions.
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
