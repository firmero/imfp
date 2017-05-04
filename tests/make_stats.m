function make_stats(test_filename, stats_fileID, time_stats_fileID)
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Generates statistics from test data produced by function test.
%  Sec is used as the unit of time.
%
%--------------------------------------------------------------------------
% .Input parameters.
%
%  test_filename     ... location to test data
%  stats_fileID      ... file identifier returned by fopen for output stats
%  time_stats_fileID ... file identifier returned by fopen for time stats output
%
%--------------------------------------------------------------------------
% .Output parameters.
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Test data loaded from test_filename contains paths to test data to every
%  form. Test data also contains reference ranges with minimal overestimation
%  error.
%
%  Stats uses the following function to get values for statistics:
%  100 * (width(ix) - width(iy)) / width(ix)
%  ix is range produced by form, iy is reference range
%
%  Statistical quantities are computed:
%  max, min, mean, median
%  (smaller is better)
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

distance_fcn = @distance2;

load(test_filename,'-mat');
n = test.n;


fprintf(stats_fileID,'>> STATS for %s\n', test_filename);
fprintf(stats_fileID,' #polynomials = %-5i  deg = %-4i  X = [%f , %f]\n', ...
		test.n, test.deg, inf(test.ix), sup(test.ix));

fprintf(time_stats_fileID,'>> STATS for %s\n', test_filename);
fprintf(time_stats_fileID,' #polynomials = %-5i  deg = %-4i  X = [%f , %f]\n', ...
		test.n, test.deg, inf(test.ix), sup(test.ix));

fprintf(stats_fileID,'>> [DISTANCE]\n');
fprintf(stats_fileID,...
'Form         max          min         mean       median  deg         X\n');
fprintf(stats_fileID,...
'-------------------------------------------------------------------------\n');
for i = 1:test.forms_count

	% load ranges of a i-th form
	load(test.filenames(i).form,'-mat');

	distances = zeros(1,n);
	for j = 1:n
		distances(j) = distance_fcn(form.ranges(j), test.polynomials_ranges(j));
	end

	fprintf(stats_fileID,' %-6s %10.3f  %10.3f  %10.3f  %10.3f  %2i [%f, %f]\n' ,...
		form.desc,...
		max(distances), min(distances), mean(distances), median(distances),...
		test.deg, inf(test.ix), sup(test.ix));

end
fprintf(stats_fileID,...
'-------------------------------------------------------------------------\n');


fprintf(time_stats_fileID,'>> [EVAL_TIME]\n');
fprintf(time_stats_fileID,...
'Form         max          min         mean       median  deg         X\n');

fprintf(time_stats_fileID,...
'-------------------------------------------------------------------------\n');
for i = 1:test.forms_count

	load(test.filenames(i).form,'-mat');
	eval_times = form.eval_times;

	fprintf(time_stats_fileID,' %-6s %10.4f  %10.4f  %10.4f  %10.4f  %2i [%f, %f]\n' ,...
		form.desc,...
		max(eval_times), min(eval_times), mean(eval_times), median(eval_times),...
		test.deg, inf(test.ix), sup(test.ix));

end
fprintf(time_stats_fileID,...
'-------------------------------------------------------------------------\n');

end

%
% ix is computed, iy is referenced
%
function d = distance2(ix,iy)

	wX = (sup(ix)-inf(ix));
	wY = (sup(iy)-inf(iy));

	d = 100 * (wX-wY)/wX;
end
