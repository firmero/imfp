function res = generate_polynomials(deg, n)
%BEGINDOC==================================================================
% .Author
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
%
% Returns n polynomials of degree deg with coefficients in (-1,1)
%

%todo n=1

deg = deg + 1;
res = zeros(n,deg);

for i = 1:n
	res(i,:) = rand(1,deg) - 0.5;
end

end
