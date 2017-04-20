function run_tests()
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
% .Todo.
%
%
%ENDDOC====================================================================

warning('off','all'); t = tic; 
test_suite1('stats1',2), toc(t)
warning('on','all');

warning('off','all'); t = tic; 
test_suite2('stats2',2), toc(t)
warning('on','all');

%p = generate_polynomials_interval(31,1);
%X = infsup(-0.1,0.1);

end

function test_suite1(stats_filename, test_repetition)

	disp('-- starting test_suite 1 --'); 

	forms_struct = {	
				% form_handler, description
				{ @pvhornerenc, 'HF'};
				{ @pvhornerbzenc, 'HFBZ'};

				{ @pvmeanvalenc, 'MVF'};
				{ @pvslopeenc, 'MVSF'} ;
				{ @pvmeanvalbcenc, 'MVFB'};

				{ @pvtaylorenc, 'TF'};
				{ @pvtaylorbmenc, 'TFBM'};

				{ @pvbernsteinenc, 'BF'};
				{ @pvbernsteinbzenc, 'BFBZ'};

				{ @pvinterpolationenc, 'IF'};
				{ @pvinterpolation2enc, 'IF2'};
				{ @pvinterpolationslenc, 'ISF'};
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

				struct('deg',  4, 'interval', infsup(-0.3, -0.2), 'prefix', 't41_');
				struct('deg',  5, 'interval', infsup(-0.3, -0.2), 'prefix', 't42_');
				struct('deg',  6, 'interval', infsup(-0.3, -0.2), 'prefix', 't43_');
				struct('deg',  7, 'interval', infsup(-0.3, -0.2), 'prefix', 't44_');
				struct('deg', 11, 'interval', infsup(-0.3, -0.2), 'prefix', 't45_');
				struct('deg', 16, 'interval', infsup(-0.3, -0.2), 'prefix', 't46_');
				struct('deg', 21, 'interval', infsup(-0.3, -0.2), 'prefix', 't47_');
				struct('deg', 26, 'interval', infsup(-0.3, -0.2), 'prefix', 't48_');
				struct('deg', 31, 'interval', infsup(-0.3, -0.2), 'prefix', 't49_');

				struct('deg',  4, 'interval', infsup(0.2, 0.3), 'prefix', 't51_');
				struct('deg',  5, 'interval', infsup(0.2, 0.3), 'prefix', 't52_');
				struct('deg',  6, 'interval', infsup(0.2, 0.3), 'prefix', 't53_');
				struct('deg',  7, 'interval', infsup(0.2, 0.3), 'prefix', 't54_');
				struct('deg', 11, 'interval', infsup(0.2, 0.3), 'prefix', 't55_');
				struct('deg', 16, 'interval', infsup(0.2, 0.3), 'prefix', 't56_');
				struct('deg', 21, 'interval', infsup(0.2, 0.3), 'prefix', 't57_');
				struct('deg', 26, 'interval', infsup(0.2, 0.3), 'prefix', 't58_');
				struct('deg', 31, 'interval', infsup(0.2, 0.3), 'prefix', 't59_');
			};

	tests_prms = { struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'x11_')};

	exec_tests(tests_prms, test_repetition, @generate_polynomials,...
				@evaluate_polynomial, forms_struct,stats_filename)
end

function test_suite2(stats_filename, test_repetition)
	
	disp('-- starting test_suite 2 --'); 

	forms_struct = {	

				% form_handler, description
				{ @pvihornerenc, 'iHF'};
				{ @pvihornerbzenc, 'iHFBZ'};

				{ @pvimeanvalenc, 'iMVF'};
				{ @pvislopeenc, 'iMVSF'} ;
				% problem infsup
				% { @pvimeanvalbcenc, 'iMVFB'};

				{ @pvitaylorenc, 'iTF'};
				{ @pvitaylorbmenc, 'iTFBM'};

				{ @pvibernsteinenc, 'iBF'};
				{ @pvibernsteinbzenc, 'iBFBZ'};

				{ @pviinterpolationenc, 'iIF'};
				{ @pviinterpolation2enc, 'iIF2'};
				{ @pviinterpolationslenc, 'iISF'};
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

				struct('deg',  4, 'interval', infsup(-0.3, -0.2), 'prefix', 'it41_');
				struct('deg',  5, 'interval', infsup(-0.3, -0.2), 'prefix', 'it42_');
				struct('deg',  6, 'interval', infsup(-0.3, -0.2), 'prefix', 'it43_');
				struct('deg',  7, 'interval', infsup(-0.3, -0.2), 'prefix', 'it44_');
				struct('deg', 11, 'interval', infsup(-0.3, -0.2), 'prefix', 'it45_');
				struct('deg', 16, 'interval', infsup(-0.3, -0.2), 'prefix', 'it46_');
				struct('deg', 21, 'interval', infsup(-0.3, -0.2), 'prefix', 'it47_');
				struct('deg', 26, 'interval', infsup(-0.3, -0.2), 'prefix', 'it48_');
				struct('deg', 31, 'interval', infsup(-0.3, -0.2), 'prefix', 'it49_');

				struct('deg',  4, 'interval', infsup(0.2, 0.3), 'prefix', 'it51_');
				struct('deg',  5, 'interval', infsup(0.2, 0.3), 'prefix', 'it52_');
				struct('deg',  6, 'interval', infsup(0.2, 0.3), 'prefix', 'it53_');
				struct('deg',  7, 'interval', infsup(0.2, 0.3), 'prefix', 'it54_');
				struct('deg', 11, 'interval', infsup(0.2, 0.3), 'prefix', 'it55_');
				struct('deg', 16, 'interval', infsup(0.2, 0.3), 'prefix', 'it56_');
				struct('deg', 21, 'interval', infsup(0.2, 0.3), 'prefix', 'it57_');
				struct('deg', 26, 'interval', infsup(0.2, 0.3), 'prefix', 'it58_');
				struct('deg', 31, 'interval', infsup(0.2, 0.3), 'prefix', 'it59_');
			};

	tests_prms = { struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'y11_')};

	exec_tests(tests_prms, test_repetition, @generate_polynomials_interval,...
				@evaluate_polynomial_int, forms_struct, stats_filename)

end

function exec_tests(tests_prms, repetitions, gen_polynomial_handler,...
					eval_polynom_hander, forms_struct, stats_filename)

	[~,~] = mkdir('stats_out');
	stats_fileID = fopen( [ 'stats_out' filesep stats_filename '.txt' ], 'a');
	time_stats_fileID = fopen( [ 'stats_out' filesep stats_filename '_t.txt'], 'a');

	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		fprintf('Test case        %4i/%i\n', i, tests_cnt);

		test_filename = test(tests_prms{i}.deg, repetitions, ...
						gen_polynomial_handler, ...
						eval_polynom_hander, ...
						tests_prms{i}.interval, forms_struct, tests_prms{i}.prefix);

		make_stats(test_filename, stats_fileID, time_stats_fileID);
	end

	fclose(stats_fileID);
end
