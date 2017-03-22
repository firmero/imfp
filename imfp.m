%
% To use parallelization run it with non-empty par_opt argument 
%
function imfp(par_opt)

	has_intval_arithmetic = which('infsup');

	if (isempty(has_intval_arithmetic))
		disp('---- Please initialize INTLAB, then call this function again.');
		return
	end

	global IFMP_DIR;

	loc = which('imfp.m');
	IFMP_DIR = loc(1:end-6);

	addpath( [ IFMP_DIR filesep 'forms' ] );
	addpath( [ IFMP_DIR filesep 'misc' ] );

	running_octave = 0 ~= exist('OCTAVE_VERSION', 'builtin'); 

	if (running_octave)
		addpath( [ IFMP_DIR filesep 'octave_env' ] );
	else
		addpath( [ IFMP_DIR filesep 'matlab_env' ] );
	end

	% 1 for parallel
	par = 0;
	if (1 == nargin)
		par = 1;
	end

	if (par && running_octave)

		has_par = pkg('list','parallel');

		if (isempty(has_par))

			warning('Pkg parallel not found');

			disp 'Installing pkg struct-1.0.14.tar.gz'
			pkg('install',[ IFMP_DIR filesep 'lib' filesep 'struct-1.0.14.tar.gz']);
			disp 'Pkg struct-1.0.14.tar.gz installed'

			disp 'Installing pkg parallel-3.1.1.tar.gz'
			pkg('install',[ IFMP_DIR filesep 'lib' filesep 'parallel-3.1.1.tar.gz']);
			disp 'Pkg parallel-3.1.1.tar.gz installed'

		end

		pkg load struct
		pkg load parallel

		% running script makes local functions global in octave,
		% not working in matlab :/
		load_interval_forms_par
		addpath( [ IFMP_DIR filesep 'misc/evaluate_polynomial/private' ] );
		disp 'paralell'

		main
		return
	end

	if (par && ~running_octave)
		warning('Parallelization cannot be established');
	end

	disp 'no paralell'
	% in matlab cannot promote local function to global
	% by calling script :/
	addpath( [ IFMP_DIR filesep 'misc/interval_polynomial_forms' ] );
	addpath( [ IFMP_DIR filesep 'misc/evaluate_polynomial' ] );

	main
	return
end
%% start of misc

function main

	X = infsup(2,3);
	horner_form([2],X);
	horner_form_int([intval(2)],X);

	disp 'test'
	test_suite
	disp 'test2'
	test_suite2

end
function test_suite2()
	
	forms_struct = {	
				{ @horner_form_int, 'iHF'};
				{ @horner_form_bisect_zero_int, 'iHFBZ'};

				{ @mean_value_form_int, 'iMVF'};
				{ @mean_value_slope_form_int, 'iMVSF'} ;
				% problem infsup
				% { @mean_value_form_bicentred, 'iMVFB'};

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
	cnt = 2;

	fileID = fopen('stats2.txt','a');

	mkdir 'tests';
	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		fprintf('Test case        %4i/%i\n', i, tests_cnt);

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

	tests_prms ={ { 5,infsup(-0.3, 0.2), 'x11_' } };

	% one test repetition
	cnt = 2;

	fileID = fopen('stats.txt','a');

	mkdir 'tests';
	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		fprintf('Test case        %4i/%i\n', i, tests_cnt);

		test(tests_prms{i}{1}, cnt, @generate_polynomials,...
			tests_prms{i}{2}, forms_struct, tests_prms{i}{3});

		make_stats(strcat('tests/',tests_prms{i}{3},'test.bin'),fileID)
	end

	fclose(fileID);

end
