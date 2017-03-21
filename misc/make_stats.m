%
% fileID ... output stats filename
%
function make_stats(test_filename, fileID, distance_fcn)

	%todo distance_fcn = @distance
	distance_fcn = @distance;
	load(test_filename,'-mat');
	n = test.polynomials_count;


	fprintf(fileID,'>> STATS for %s\n', test_filename);
	fprintf(fileID,' #polynomials = %-5i  deg = %-4i  X = [%f , %f]\n', ...
			test.polynomials_count, test.deg, inf(test.X), sup(test.X));


	fprintf(fileID,'>> [DISTANCE]\n');
	fprintf(fileID,...
	'Form        max         min        mean        median  deg         X\n');
	fprintf(fileID,...
	'-------------------------------------------------------------------------\n');
	for i = 1:test.forms_count

		% load ranges of a i-th form
		load(test.filenames(i).form,'-mat');

		distances = zeros(1,n);
		for j = 1:n
			distances(j) = distance_fcn(form.ranges(j), test.polynomials_ranges(j));
		end

		fprintf(fileID,' %-6s %10.4f  %10.4f  %10.4f  %10.4f  %2i [%f, %f]\n' ,...
			form.desc,...
			max(distances), min(distances), mean(distances), median(distances),...
			test.deg, inf(test.X), sup(test.X));

	end
	fprintf(fileID,...
	'-------------------------------------------------------------------------\n');


	fprintf(fileID,'>> [EVAL_TIME]\n');
	fprintf(fileID,...
	'Form        max         min        mean        median  deg         X\n');

	fprintf(fileID,...
	'-------------------------------------------------------------------------\n');
	for i = 1:test.forms_count

		load(test.filenames(i).form,'-mat');
		eval_time = form.eval_time;

		fprintf(fileID,' t_%-6s %10.4f  %10.4f  %10.4f  %10.4f  %2i [%f, %f]\n' ,...
			form.desc,...
			max(eval_time), min(eval_time), mean(eval_time), median(eval_time),...
			test.deg, inf(test.X), sup(test.X));

	end
	fprintf(fileID,...
	'-------------------------------------------------------------------------\n');

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
