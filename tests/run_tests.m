function run_tests

	t = tic; test_suite1('stats1',100);
	toc(t)

	%test_suite2('stats2',100);

end

function test_suite1(stats_filename, test_repetition)

	disp('-- starting test_suite 1 --'); 

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

	exec_tests(tests_prms, test_repetition, @generate_polynomials,...
				forms_struct,stats_filename)
end

function test_suite2(stats_filename, test_repetition)
	
	disp('-- starting test_suite 2 --'); 

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

	tests_prms = { 

				struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'it11_');
				struct('deg',  5, 'interval', infsup(-0.3, 0.2), 'prefix', 'it12_');
				struct('deg',  6, 'interval', infsup(-0.3, 0.2), 'prefix', 'it13_');
				struct('deg',  7, 'interval', infsup(-0.3, 0.2), 'prefix', 'it14_');
				struct('deg', 11, 'interval', infsup(-0.3, 0.2), 'prefix', 'it15_');
				struct('deg', 16, 'interval', infsup(-0.3, 0.2), 'prefix', 'it16_');
				struct('deg', 21, 'interval', infsup(-0.3, 0.2), 'prefix', 'it17_');
				struct('deg', 26, 'interval', infsup(-0.3, 0.2), 'prefix', 'it18_');
				struct('deg', 31, 'interval', infsup(-0.3, 0.2), 'prefix', 'it19_');

				struct('deg',  4, 'interval', infsup(-0.15, 0.1), 'prefix', 'it21_');
				struct('deg',  5, 'interval', infsup(-0.15, 0.1), 'prefix', 'it22_');
				struct('deg',  6, 'interval', infsup(-0.15, 0.1), 'prefix', 'it23_');
				struct('deg',  7, 'interval', infsup(-0.15, 0.1), 'prefix', 'it24_');
				struct('deg', 11, 'interval', infsup(-0.15, 0.1), 'prefix', 'it25_');
				struct('deg', 16, 'interval', infsup(-0.15, 0.1), 'prefix', 'it26_');
				struct('deg', 21, 'interval', infsup(-0.15, 0.1), 'prefix', 'it27_');
				struct('deg', 26, 'interval', infsup(-0.15, 0.1), 'prefix', 'it28_');
				struct('deg', 31, 'interval', infsup(-0.15, 0.1), 'prefix', 'it29_');

				struct('deg',  4, 'interval', infsup(-0.1, 0.1), 'prefix', 'it31_');
				struct('deg',  5, 'interval', infsup(-0.1, 0.1), 'prefix', 'it32_');
				struct('deg',  6, 'interval', infsup(-0.1, 0.1), 'prefix', 'it33_');
				struct('deg',  7, 'interval', infsup(-0.1, 0.1), 'prefix', 'it34_');
				struct('deg', 11, 'interval', infsup(-0.1, 0.1), 'prefix', 'it35_');
				struct('deg', 16, 'interval', infsup(-0.1, 0.1), 'prefix', 'it36_');
				struct('deg', 21, 'interval', infsup(-0.1, 0.1), 'prefix', 'it37_');
				struct('deg', 26, 'interval', infsup(-0.1, 0.1), 'prefix', 'it38_');
				struct('deg', 31, 'interval', infsup(-0.1, 0.1), 'prefix', 'it39_');
			};

	tests_prms = { 
				struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'y11_');
			};

	exec_tests(tests_prms, test_repetition, @generate_polynomials_interval,...
				forms_struct, stats_filename)

end

function exec_tests(tests_prms, repetitions, gen_polynomial_handler,...
					forms_struct,stats_filename)

	[~,~] = mkdir('stats_out');
	stats_fileID = fopen( [ 'stats_out' filesep stats_filename '.txt' ], 'a');
	time_stats_fileID = fopen( [ 'stats_out' filesep stats_filename '_t.txt'], 'a');

	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		fprintf('Test case        %4i/%i\n', i, tests_cnt);

		test_filename = test(tests_prms{i}.deg, repetitions, gen_polynomial_handler,...
					tests_prms{i}.interval, forms_struct, tests_prms{i}.prefix);

		make_stats(test_filename, stats_fileID, time_stats_fileID);
	end

	fclose(stats_fileID);
end
