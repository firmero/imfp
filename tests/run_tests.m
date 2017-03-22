function run_tests

	global TEST_OUT_DIR
	TEST_OUT_DIR = 'tests_out';
	mkdir(TEST_OUT_DIR);

	disp 'test'
	test_suite1
	%disp 'test2'
	%test_suite2

end

function test_suite1()
	
	forms_struct = {	
				% form_handler, description
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

	tests_prms = { 

				struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 't11_');
				struct('deg',  5, 'interval', infsup(-0.3, 0.2), 'prefix', 't12_');
				struct('deg',  6, 'interval', infsup(-0.3, 0.2), 'prefix', 't13_');
				struct('deg',  7, 'interval', infsup(-0.3, 0.2), 'prefix', 't14_');
				struct('deg', 11, 'interval', infsup(-0.3, 0.2), 'prefix', 't15_');
				struct('deg', 16, 'interval', infsup(-0.3, 0.2), 'prefix', 't16_');
				struct('deg', 21, 'interval', infsup(-0.3, 0.2), 'prefix', 't17_');
				struct('deg', 26, 'interval', infsup(-0.3, 0.2), 'prefix', 't18_');
				struct('deg', 31, 'interval', infsup(-0.3, 0.2), 'prefix', 't19_');

				struct('deg',  4, 'interval', infsup(-0.15, 0.1), 'prefix', 't21_');
				struct('deg',  5, 'interval', infsup(-0.15, 0.1), 'prefix', 't22_');
				struct('deg',  6, 'interval', infsup(-0.15, 0.1), 'prefix', 't23_');
				struct('deg',  7, 'interval', infsup(-0.15, 0.1), 'prefix', 't24_');
				struct('deg', 11, 'interval', infsup(-0.15, 0.1), 'prefix', 't25_');
				struct('deg', 16, 'interval', infsup(-0.15, 0.1), 'prefix', 't26_');
				struct('deg', 21, 'interval', infsup(-0.15, 0.1), 'prefix', 't27_');
				struct('deg', 26, 'interval', infsup(-0.15, 0.1), 'prefix', 't28_');
				struct('deg', 31, 'interval', infsup(-0.15, 0.1), 'prefix', 't29_');

				struct('deg',  4, 'interval', infsup(-0.1, 0.1), 'prefix', 't31_');
				struct('deg',  5, 'interval', infsup(-0.1, 0.1), 'prefix', 't32_');
				struct('deg',  6, 'interval', infsup(-0.1, 0.1), 'prefix', 't33_');
				struct('deg',  7, 'interval', infsup(-0.1, 0.1), 'prefix', 't34_');
				struct('deg', 11, 'interval', infsup(-0.1, 0.1), 'prefix', 't35_');
				struct('deg', 16, 'interval', infsup(-0.1, 0.1), 'prefix', 't36_');
				struct('deg', 21, 'interval', infsup(-0.1, 0.1), 'prefix', 't37_');
				struct('deg', 26, 'interval', infsup(-0.1, 0.1), 'prefix', 't38_');
				struct('deg', 31, 'interval', infsup(-0.1, 0.1), 'prefix', 't39_');
			};

	tests_prms = { 
				struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'x11_');
			};

	% one test repetition
	cnt = 3;
	exec_tests(tests_prms, cnt, @generate_polynomials, forms_struct)
end

function test_suite2()
	
	forms_struct = {	
				% form_handler, description
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

function exec_tests(tests_prms, repetitions, gen_polynomial_handler, forms_struct)

	stats_fileID = fopen('stats.txt','a');

	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		fprintf('Test case        %4i/%i\n', i, tests_cnt);

		test_filename = test(tests_prms{i}.deg, repetitions, gen_polynomial_handler,...
					tests_prms{i}.interval, forms_struct, tests_prms{i}.prefix);

		make_stats(test_filename, stats_fileID);
	end

	fclose(stats_fileID);
end
