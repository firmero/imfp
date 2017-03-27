function make_stats(test_filename, stats_fileID, time_stats_fileID, distance_fcn)
%BEGINDOC==================================================================
% .Author
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  stats_fileID ... output stats filename
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

%todo distance_fcn = @distance
distance_fcn = @distance2;

load(test_filename,'-mat');
n = test.polynomials_count;


fprintf(stats_fileID,'>> STATS for %s\n', test_filename);
fprintf(stats_fileID,' #polynomials = %-5i  deg = %-4i  X = [%f , %f]\n', ...
		test.polynomials_count, test.deg, inf(test.X), sup(test.X));

fprintf(stats_fileID,'>> [DISTANCE]\n');
fprintf(stats_fileID,...
'Form        max         min        mean        median  deg         X\n');
fprintf(stats_fileID,...
'-------------------------------------------------------------------------\n');
for i = 1:test.forms_count

	% load ranges of a i-th form
	load(test.filenames(i).form,'-mat');

	distances = zeros(1,n);
	for j = 1:n
		distances(j) = distance_fcn(form.ranges(j), test.polynomials_ranges(j));
	end

	fprintf(stats_fileID,' %-6s %10.2f  %10.2f  %10.2f  %10.2f  %2i [%f, %f]\n' ,...
		form.desc,...
		max(distances), min(distances), mean(distances), median(distances),...
		test.deg, inf(test.X), sup(test.X));

end
fprintf(stats_fileID,...
'-------------------------------------------------------------------------\n');


fprintf(time_stats_fileID,'>> [EVAL_TIME]\n');
fprintf(time_stats_fileID,...
'Form        max         min        mean        median  deg         X\n');

fprintf(time_stats_fileID,...
'-------------------------------------------------------------------------\n');
for i = 1:test.forms_count

	load(test.filenames(i).form,'-mat');
	eval_time = form.eval_time;

	fprintf(time_stats_fileID,' t_%-6s %10.2f  %10.2f  %10.2f  %10.2f  %2i [%f, %f]\n' ,...
		form.desc,...
		max(eval_time), min(eval_time), mean(eval_time), median(eval_time),...
		test.deg, inf(test.X), sup(test.X));

end
fprintf(time_stats_fileID,...
'-------------------------------------------------------------------------\n');

end

%
% X is computed, Y is referenced
%
function d = distance2(X,Y)

	wX = (sup(X)-inf(X));
	wY = (sup(Y)-inf(Y));

	d = 100 * (wX-wY)/wX;
end

%
% X is computed, Y is referenced
%
function d = distance(X,Y)

	% todo if y i point?
	% todo check if x is subset of y

	if (~in(intval(Y),intval(X)))
		;
		%return
	end

	setround(1);
	wX = (sup(X)-inf(X));
	wY = (sup(Y)-inf(Y));
	d = 1024*(wX - wY)/wY;

	d = abs(d);

end
