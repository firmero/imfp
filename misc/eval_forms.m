%
% For testing purpose
%
function res = eval_forms(form_cell,p,X)

	n = length(form_cell);
	% range of form and evaltime
	res = cell(n,2);

	for i = 1:n
		tic;
		res{i,1} = form_cell{i}(p,X);
		res{i,2} = toc;
	end

end
