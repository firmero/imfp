function imfp

	global IFMP_DIR;

	loc = which('imfp.m');
	IFMP_DIR = loc(1:end-6);

	if (0 ~= exist('OCTAVE_VERSION', 'builtin'))
		addpath( [ IFMP_DIR filesep 'octave_env' ] );
	else
		addpath( [ IFMP_DIR filesep 'matlab_env' ] );
	end

	addpath( [ IFMP_DIR filesep 'forms' ] );

	disp ok
end
%% start of misc

%
% The range of natural power over interval X (as a function) 
%
% To achieve:
%
%	[-8,1]=pow_3( [-2,1] )  !=  [-2,1]*[-2,1]*[-2,1]=[-8,4]
%
function res = interval_power(X,n)

	if (even(n))
		res = X^n;
		return
	end

	res = infsup(inf(X)^n, sup(X)^n);

end

function y = evaluate_parallel(polynomial_coefficients, X)

	ncpus = nproc();

	% assert ncpus != 0
	delta = (sup(X) - inf(X))/ncpus;

	coefficients = cell(1,ncpus);
	intervals = cell(1,ncpus);


	left = inf(X);
	for i = 1:ncpus
	
		% todo rounding
		getround(1);
		right = left + delta;
		intervals(i) = infsup(left,right);
		left = right;

		coefficients(i) = polynomial_coefficients;

	end

	a = parcellfun(ncpus, @evaluate, coefficients, intervals,'UniformOutput', false,...
					'VerboseLevel', 0);

	y = a{1};
	for i=2:ncpus
		y = hull(y,a{i});
	end

end

%
% X interval
% nadhodnocuje !!!!!
%
function y = evaluate(polynomial_coefficients, X)

	t = inf(X);
	y = intval(polyval(polynomial_coefficients,t));

	while (t + 0.0003 < sup(X))

		t = t + 0.0003;
		ny = polyval(polynomial_coefficients,t);

		y = hull(y,ny);

	end

	y = hull(y,polyval(polynomial_coefficients,sup(X)));

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

	getround(1);
	wX = (sup(X)-inf(X));
	wY = (sup(Y)-inf(Y));
	d = 1024*(wX - wY)/wY;

	d = abs(d);

end
%% end of misc

%% start interval polynomials

function res = horner_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@horner_form);
end

function res = horner_form_bisect_zero_int(p,X)
	 res = interval_polynomial_form_par(p,X,@horner_form_bisect_zero);
end

function res = mean_value_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@mean_value_form);
end

function res = mean_value_slope_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@mean_value_slope_form);
end

% not working
%
%function res = mean_value_form_bicentred_int(p,X)
%	 res = interval_polynomial_form(p,X,@mean_value_form_bicentred);
%end

function res = taylor_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@taylor_form);
end

function res = taylor_form_bisect_middle_int(p,X)
	 res = interval_polynomial_form_par(p,X,@taylor_form_bisect_middle);
end

function res = bernstein_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@bernstein_form);
end

function res = bernstein_form_bisect_zero_int(p,X)
	 res = interval_polynomial_form_par(p,X,@bernstein_form_bisect_zero);
end

function res = interpolation_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@interpolation_form);
end

function res = interpolation_form2_int(p,X)
	 res = interval_polynomial_form_par(p,X,@interpolation_form2);
end

function res = interpolation_slope_form_int(p,X)
	 res = interval_polynomial_form_par(p,X,@interpolation_slope_form);
end
%% end interval polynomials

%% start of INTERPOLATION FORM
%
% Returns n polynomials of degree deg with coefficients in (-1,1)
%
function res = generate_polynomials(deg, n)

	%todo n=1

	deg = deg + 1;
	res = zeros(n,deg);

	for i = 1:n
		res(i,:) = rand(1,deg) - 0.5;
	end

end

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

%
%
%
function test(deg, polynomials_count, polynomials_generator,...
				X, forms_struct, prefix)
	% todo prefix = ''

	mkdir 'tests';
	test_dir_prefix = strcat('tests/',prefix);

	polynomials = polynomials_generator(deg, polynomials_count);
	polynomials_ranges = repmat(intval(0),polynomials_count,1);


	for i = 1:polynomials_count
		polynomials_ranges(i) = evaluate_parallel(polynomials(i,:),X);
		printf('\rEval polynomial: %4i/%i', i, polynomials_count);
	end
	printf('\n');

	form_cnt = length(forms_struct);
	filenames = repmat(struct('form',''),form_cnt,1);

	for i = 1:form_cnt

		ranges = repmat(intval(0),polynomials_count,1);
		eval_time = zeros(polynomials_count,1);

		for j = 1:polynomials_count
			printf('\rEval form: %4i/%i polynomial: %4i/%i',...
					i, form_cnt, j, polynomials_count);
			tic;
			ranges(j) = forms_struct{i}{1}(polynomials(j,:),X);
			eval_time(j) = toc;
		end

		fname = func2str(forms_struct{i}{1});

		form.ranges = ranges;
		form.eval_time = eval_time;
		form.desc = forms_struct{i}{2};

		filename = strcat(test_dir_prefix,fname,'.bin');
		save(filename, 'form', '-binary');

		filenames(i).form = filename;

	end
	printf('\n');

	test.X = X;
	test.polynomials_count = polynomials_count;
	test.deg = deg;
	test.polynomials = polynomials;
	% the 'real' values of polynomials
	test.polynomials_ranges = polynomials_ranges;

	test.forms_count = form_cnt;
	test.filenames = filenames;

	test_filename = strcat(test_dir_prefix,'test.bin');
	save(test_filename,'test', '-binary');

end

%
% fileID ... output stats filename
%
function make_stats(test_filename, fileID, distance_fcn)

	%todo distance_fcn = @distance
	distance_fcn = @distance;
	load(test_filename);
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
		load(test.filenames(i).form);

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

		load(test.filenames(i).form);
		eval_time = form.eval_time;

		fprintf(fileID,' t_%-6s %10.4f  %10.4f  %10.4f  %10.4f  %2i [%f, %f]\n' ,...
			form.desc,...
			max(eval_time), min(eval_time), mean(eval_time), median(eval_time),...
			test.deg, inf(test.X), sup(test.X));

	end
	fprintf(fileID,...
	'-------------------------------------------------------------------------\n');

end

function test_suite2()
	
	forms_struct = {	
				{ @horner_form_int, 'iHF'};
				{ @horner_form_bisect_zero_int, 'iHFBZ'};

				{ @mean_value_form_int, 'iMVF'};
				{ @mean_value_slope_form_int, 'iMVSF'} ;

				{ @taylor_form_int, 'iTF'};
				{ @taylor_form_bisect_middle_int, 'iTFBM'};

				{ @bernstein_form_int, 'iBF'};
				{ @bernstein_form_bisect_zero_int, 'iBFBZ'};

				{ @interpolation_form_int, 'iIF'};
				{ @interpolation_form2_int, 'iIF2'};
				{ @interpolation_slope_form_int, 'iISF'};
		};

	 tests_prms ={ { 5,infsup(-0.3, 0.2), 'x11_' } };

	% one test repetition
	cnt = 20;

	fileID = fopen('stats2.txt','a');

	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		printf('Test case        %4i/%i\n', i, tests_cnt);

		test(tests_prms{i}{1}, cnt, @generate_polynomials_interval,...
			tests_prms{i}{2}, forms_struct, tests_prms{i}{3});

		make_stats(strcat('tests/',tests_prms{i}{3},'test.bin'),fileID)

	end

	fclose(fileID);

end

function test_suite()
	
	forms_struct = {	
				{ @horner_form, 'HF'};
				{ @horner_form_bisect_zero, 'HFBZ'};

				{ @mean_value_form, 'MVF'};
				{ @mean_value_slope_form, 'MVSF'} ;
				{ @mean_value_form_bicentred, 'MVFB'};

				{ @taylor_form, 'TF'};
				{ @taylor_form_bisect_middle, 'TFBM'};

				{ @bernstein_form, 'BF'};
				{ @bernstein_form_bisect_zero, 'BFBZ'};

				{ @interpolation_form, 'IF'};
				{ @interpolation_form2, 'IF2'};
				{ @interpolation_slope_form, 'ISF'};
		};

	tests_prms ={ 
					% deg,  X, prefix
					{ 4, infsup(-0.3, 0.2), 't11_' };
					{ 5, infsup(-0.3, 0.2), 't12_' };
					{ 6, infsup(-0.3, 0.2), 't13_' };
					{ 7, infsup(-0.3, 0.2), 't14_' };
					{ 11, infsup(-0.3, 0.2), 't15_' };
					{ 16, infsup(-0.3, 0.2), 't16_' };
					{ 21, infsup(-0.3, 0.2), 't17_' };
					{ 26, infsup(-0.3, 0.2), 't18_' };
					{ 31, infsup(-0.3, 0.2), 't19_' };

					{ 4, infsup(-0.15, 0.1), 't21_' };
					{ 5, infsup(-0.15, 0.1), 't22_' };
					{ 6, infsup(-0.15, 0.1), 't23_' };
					{ 7, infsup(-0.15, 0.1), 't24_' };
					{ 11, infsup(-0.15, 0.1), 't25_' };
					{ 16, infsup(-0.15, 0.1), 't26_' };
					{ 21, infsup(-0.15, 0.1), 't27_' };
					{ 26, infsup(-0.15, 0.1), 't28_' };
					{ 31, infsup(-0.15, 0.1), 't29_' };

					{ 4, infsup(-0.1, 0.1), 't31_' };
					{ 5, infsup(-0.1, 0.1), 't32_' };
					{ 6, infsup(-0.1, 0.1), 't33_' };
					{ 7, infsup(-0.1, 0.1), 't34_' };
					{ 11, infsup(-0.1, 0.1), 't35_' };
					{ 16, infsup(-0.1, 0.1), 't36_' };
					{ 21, infsup(-0.1, 0.1), 't37_' };
					{ 26, infsup(-0.1, 0.1), 't38_' };
					{ 31, infsup(-0.1, 0.1), 't39_' };

				};

	 ests_prms ={ { 5,infsup(-0.3, 0.2), 'x11_' } };

	% one test repetition
	cnt = 2;

	fileID = fopen('stats.txt','a');

	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		printf('Test case        %4i/%i\n', i, tests_cnt);

		test(tests_prms{i}{1}, cnt, @generate_polynomials,...
			tests_prms{i}{2}, forms_struct, tests_prms{i}{3});

		make_stats(strcat('tests/',tests_prms{i}{3},'test.bin'),fileID)

	end

	fclose(fileID);

end
%%%%%%%%%%%%%%%%%%%%%

function res = interval_polynomial_form(p,X,form)
	
	n = length(p);
	up = repmat(0,1,n);
	down = repmat(0,1,n);

	if (inf(X) < 0)

		for i = n:-2:1
			up(i) = sup(p(i));
			down(i) = inf(p(i));
		end

		for i = n-1:-2:1
			up(i) = inf(p(i));
			down(i) = sup(p(i));
		end

		% compute over A
		bound = min(sup(X),0);
		Y = infsup(inf(X), bound);

		left_max = form(up,Y);
		left_min = form(down,Y);
		left_res = infsup(inf(left_min),sup(left_max));
	else
		for i = 1:n
			up(i) = sup(p(i));
			down(i) = inf(p(i));
		end

		% compute over B
		right_max = form(up,X);
		right_min = form(down,X);

		res = infsup(inf(right_min),sup(right_max));
		return
	end

	if (sup(X) <= 0)
		res = left_res;
		return 
	end

	% compute over B
	% reuse previous state of up and down vector
	for i = n-1:-2:1
		up(i) = sup(p(i));
		down(i) = inf(p(i));
	end

	Y = infsup(0,sup(X));
	right_max = form(up,Y);
	right_min = form(down,Y);

	right_res = infsup(inf(right_min),sup(right_max));

	% A U B
	res = hull(left_res,right_res);

end

function res = interval_polynomial_form_par(p,X,form)
	
	n = length(p);
	up = repmat(0,1,n);
	down = repmat(0,1,n);
	ncpus = nproc();

	if (inf(X) < 0)

		for i = n:-2:1
			up(i) = sup(p(i));
			down(i) = inf(p(i));
		end

		for i = n-1:-2:1
			up(i) = inf(p(i));
			down(i) = sup(p(i));
		end

		% compute over A
		bound = min(sup(X),0);
		Y = infsup(inf(X), bound);

		intervals{1} = Y;
		intervals{2} = Y;

		coefficients{1} = down;
		coefficients{2} = up;

	else
		for i = 1:n
			up(i) = sup(p(i));
			down(i) = inf(p(i));
		end

		% compute over B
		intervals{1} = X;
		intervals{2} = X;

		coefficients{1} = down;
		coefficients{2} = up;

		pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
						'VerboseLevel', 0);

		res = infsup(inf(pack{1}),sup(pack{2}));
		return
	end

	if (sup(X) <= 0)

		pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
						'VerboseLevel', 0);

		res = infsup(inf(pack{1}),sup(pack{2}));
		return 
	end

	% compute over B
	% reuse previous state of up and down vector
	for i = n-1:-2:1
		up(i) = sup(p(i));
		down(i) = inf(p(i));
	end

	Y = infsup(0,sup(X));
	intervals{3} = Y;
	intervals{4} = Y;

	coefficients{3} = down;
	coefficients{4} = up;

	% left and right interval
	pack = parcellfun(ncpus,form,coefficients,intervals,'UniformOutput', false,...
					'VerboseLevel', 0);

	left_res = infsup(inf(pack{1}),sup(pack{2}));
	right_res = infsup(inf(pack{3}),sup(pack{4}));

	% A U B
	res = hull(left_res,right_res);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Generates n polynomials of deg degree with interval coefficients.
%
% Coefficients have middle in (-mid,mid) and radius in (-max_radius, max_radius)
%
function res = generate_polynomials_interval(deg, n, max_radius, midd)

	%todo n=1, max_radius=0.4, midd=4
	deg = deg + 1;
	res = repmat(repmat(intval(0),1,deg),n,1);
	middles = zeros(1,deg);
	radii = zeros(1,deg);

	midd = 2*midd;

	for i = 1:n 

		middles = midd*(rand(1,deg)-0.5);
		radii = max_radius*rand(1,deg);

		for j = 1:deg
			res(i,j) = midrad(middles(j),radii(j));
		end

	end

end

%%%%%%%%%%%%%%%%%%%%
%test_suite
%p = [ infsup(-2.0,-1.3) infsup(-3.0,-2.0) infsup(2,2.5) infsup(-4,-3.0) ];
%p = generate_polynomials_interval(30);
%X = infsup(-0.3,0.2);

%{
evaluate_parallel(p,X)
horner_form(p,X)

disp '==============='
%tic, interval_polynomial_form_par(p,X, @horner_form),% toc
tic, interval_polynomial_form_par(p,X, @horner_form_bisect_zero),% toc
disp '==============='


%tic, interval_polynomial_form_par(p,X, @mean_value_form),% toc
tic, interval_polynomial_form_par(p,X, @mean_value_slope_form),% toc
tic, interval_polynomial_form_par(p,X, @mean_value_form_bicentred),% toc
disp '==============='

%tic, interval_polynomial_form_par(p,X, @taylor_form),% toc
tic, interval_polynomial_form_par(p,X, @taylor_form_bisect_middle),% toc
disp '==============='

%tic, interval_polynomial_form_par(p,X, @bernstein_form),% toc
tic, interval_polynomial_form_par(p,X, @bernstein_form_bisect_zero),% toc
disp '==============='

%tic, interval_polynomial_form_par(p,X, @interpolation_form),% toc
tic, interval_polynomial_form_par(p,X, @interpolation_form2),% toc
tic, interval_polynomial_form_par(p,X, @interpolation_slope_form),% toc
%}
