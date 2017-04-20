function res_cell = eval_forms(forms_cell,p,ix)
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
%  forms_cell ... cell of function handlers 
%                  e.g.  { @pvbernsteinenc, @pvinterpolationenc }
%  p          ... vector of polynomial coefficients [a_1 ... a_n]
%  ix         ... interval x
%
%	p(x) = a_1*x^(n-1) + a_2*x^(n-2) + .. + a_(n-1)*x^1 + a_n
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%  res_cell ... in the first dimension are returned values from calling
%               a function handler form input cell with args p and ix,
%               in the second dimension are eval times
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
% .Todo.
%
%
%ENDDOC====================================================================

n = length(forms_cell);
% range of form and evaltime
res_cell = cell(n,2);

for i = 1:n
	t = tic;
	res_cell{i,1} = forms_cell{i}(p,ix);
	res_cell{i,2} = toc(t);
end

end
