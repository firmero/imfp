
%
% Computes optimal points c_left and c_right in sense of:
% 
% For all c in X it holds:
%
%	sup(MVF(p,c_right)) <= sup(MVF(p,c))
%	inf(MVF(p,c_left))  >= inf(MVF(p,c))
%
%	width(MVF(p,mid(X))) <= width(MVF(p,c)
%
function [c_left, c_right] = centres_mean_value_form(f_derivated, X)

	if (inf(f_derivated) >= 0)
		c_left = inf(X);
		c_right = sup(X);
		return
	end

	if (sup(f_derivated) <= 0)
		c_left = sup(X);
		c_right = inf(X);
		return
	end

	% else approximate, it is correct thanks to lemma of optimality
	width = sup(X) - inf(X);
	c_right = (sup(f_derivated)*sup(X) - inf(f_derivated)*inf(X))/width;
	c_left = (sup(f_derivated)*inf(X) - inf(f_derivated)*sup(X))/width;

end


