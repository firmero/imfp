function run_tests()
%BEGINDOC==================================================================
% .Author.
%
%  Roman Firment
%
%--------------------------------------------------------------------------
% .Description.
%
%  Script executes test suites hardcoded in this file.
%
%--------------------------------------------------------------------------
% .Implementation details.
%
%  Test suites call private function exec_tests with proper arguments.
%
%  Functions test_suite* have args:
%  stats_filename and repetitions which are forwarded to exec_tests.
%
%  Parameter repetitions represents how many polynomials should be 
%  created for specific combination of interval and degree.
%
%  Stats are generated in directory stats_out.
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

warning('off','all');

t = tic; 
test_suite1('stats1',1), toc(t)

t = tic; 
test_suite2('stats2',1), toc(t)

t = tic;
test_suite3('stats3',1), toc(t)

t = tic;
test_suite4('stats4',1), toc(t)

%warning('on','notzero');

end

function test_suite1(stats_filename, repetitions)

	disp('-- starting test_suite 1 --'); 

	forms_structs = {	
				% form_handler, description
				{ @pvhornerenc, 'HF'};
				{ @pvhornerbzenc, 'HFBZ'};

				{ @pvmeanvalenc, 'MVF'};
				{ @pvslopeenc, 'SF'} ;
				{ @pvmeanvalbcenc, 'MVFBC'};

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

	%tests_prms = { struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'x11_')};

	exec_tests(tests_prms, repetitions, @generate_polynomials,...
				@evaluate_polynomial, forms_structs,stats_filename)
end

function test_suite2(stats_filename, repetitions)
	
	disp('-- starting test_suite 2 --'); 

	forms_structs = {	

				% form_handler, description
				{ @pvihornerenc, 'iHF'};
				{ @pvihornerbzenc, 'iHFBZ'};

				{ @pvimeanvalenc, 'iMVF'};
				{ @pvislopeenc, 'iSF'} ;
				{ @pvimeanvalbcenc, 'iMVFBC'};

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

	%tests_prms = { struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'y11_')};

	exec_tests(tests_prms, repetitions, @generate_polynomials_interval,...
				@evaluate_polynomial_int, forms_structs, stats_filename)

end

function test_suite3(stats_filename, repetitions)

	disp('-- starting test_suite 3 --'); 

	forms_structs = {	
				% form_handler, description
				{ @pvhornerenc, 'HF'};
				{ @pvhornerbzenc, 'HFBZ'};

				{ @pvmeanvalenc, 'MVF'};
				{ @pvslopeenc, 'SF'} ;
				{ @pvmeanvalbcenc, 'MVFBC'};

				{ @pvtaylorenc, 'TF'};
				{ @pvtaylorbmenc, 'TFBM'};

				{ @pvbernsteinenc, 'BF'};
				{ @pvbernsteinbzenc, 'BFBZ'};

				{ @pvinterpolationenc, 'IF'};
				{ @pvinterpolation2enc, 'IF2'};
				{ @pvinterpolationslenc, 'ISF'};
		};

	tests_prms = { 

				struct('deg',  4, 'interval', infsup(-0.03, 0.02), 'prefix', 'u11_');
				struct('deg',  5, 'interval', infsup(-0.03, 0.02), 'prefix', 'u12_');
				struct('deg',  6, 'interval', infsup(-0.03, 0.02), 'prefix', 'u13_');
				struct('deg',  7, 'interval', infsup(-0.03, 0.02), 'prefix', 'u14_');
				struct('deg', 11, 'interval', infsup(-0.03, 0.02), 'prefix', 'u15_');
				struct('deg', 16, 'interval', infsup(-0.03, 0.02), 'prefix', 'u16_');
				struct('deg', 21, 'interval', infsup(-0.03, 0.02), 'prefix', 'u17_');
				struct('deg', 26, 'interval', infsup(-0.03, 0.02), 'prefix', 'u18_');
				struct('deg', 31, 'interval', infsup(-0.03, 0.02), 'prefix', 'u19_');

				struct('deg',  4, 'interval', infsup(-0.015, 0.01), 'prefix', 'u21_');
				struct('deg',  5, 'interval', infsup(-0.015, 0.01), 'prefix', 'u22_');
				struct('deg',  6, 'interval', infsup(-0.015, 0.01), 'prefix', 'u23_');
				struct('deg',  7, 'interval', infsup(-0.015, 0.01), 'prefix', 'u24_');
				struct('deg', 11, 'interval', infsup(-0.015, 0.01), 'prefix', 'u25_');
				struct('deg', 16, 'interval', infsup(-0.015, 0.01), 'prefix', 'u26_');
				struct('deg', 21, 'interval', infsup(-0.015, 0.01), 'prefix', 'u27_');
				struct('deg', 26, 'interval', infsup(-0.015, 0.01), 'prefix', 'u28_');
				struct('deg', 31, 'interval', infsup(-0.015, 0.01), 'prefix', 'u29_');

				struct('deg',  4, 'interval', infsup(-0.01, 0.01), 'prefix', 'u31_');
				struct('deg',  5, 'interval', infsup(-0.01, 0.01), 'prefix', 'u32_');
				struct('deg',  6, 'interval', infsup(-0.01, 0.01), 'prefix', 'u33_');
				struct('deg',  7, 'interval', infsup(-0.01, 0.01), 'prefix', 'u34_');
				struct('deg', 11, 'interval', infsup(-0.01, 0.01), 'prefix', 'u35_');
				struct('deg', 16, 'interval', infsup(-0.01, 0.01), 'prefix', 'u36_');
				struct('deg', 21, 'interval', infsup(-0.01, 0.01), 'prefix', 'u37_');
				struct('deg', 26, 'interval', infsup(-0.01, 0.01), 'prefix', 'u38_');
				struct('deg', 31, 'interval', infsup(-0.01, 0.01), 'prefix', 'u39_');

				struct('deg',  4, 'interval', infsup(-0.03, -0.02), 'prefix', 'u41_');
				struct('deg',  5, 'interval', infsup(-0.03, -0.02), 'prefix', 'u42_');
				struct('deg',  6, 'interval', infsup(-0.03, -0.02), 'prefix', 'u43_');
				struct('deg',  7, 'interval', infsup(-0.03, -0.02), 'prefix', 'u44_');
				struct('deg', 11, 'interval', infsup(-0.03, -0.02), 'prefix', 'u45_');
				struct('deg', 16, 'interval', infsup(-0.03, -0.02), 'prefix', 'u46_');
				struct('deg', 21, 'interval', infsup(-0.03, -0.02), 'prefix', 'u47_');
				struct('deg', 26, 'interval', infsup(-0.03, -0.02), 'prefix', 'u48_');
				struct('deg', 31, 'interval', infsup(-0.03, -0.02), 'prefix', 'u49_');

				struct('deg',  4, 'interval', infsup(0.02, 0.03), 'prefix', 'u51_');
				struct('deg',  5, 'interval', infsup(0.02, 0.03), 'prefix', 'u52_');
				struct('deg',  6, 'interval', infsup(0.02, 0.03), 'prefix', 'u53_');
				struct('deg',  7, 'interval', infsup(0.02, 0.03), 'prefix', 'u54_');
				struct('deg', 11, 'interval', infsup(0.02, 0.03), 'prefix', 'u55_');
				struct('deg', 16, 'interval', infsup(0.02, 0.03), 'prefix', 'u56_');
				struct('deg', 21, 'interval', infsup(0.02, 0.03), 'prefix', 'u57_');
				struct('deg', 26, 'interval', infsup(0.02, 0.03), 'prefix', 'u58_');
				struct('deg', 31, 'interval', infsup(0.02, 0.03), 'prefix', 'u59_');
			};

	%tests_prms = { struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'x11_')};

	exec_tests(tests_prms, repetitions, @generate_polynomials,...
				@evaluate_polynomial, forms_structs,stats_filename)
end
function test_suite4(stats_filename, repetitions)

	disp('-- starting test_suite 4 --'); 

	forms_structs = {	
				% form_handler, description
				{ @pvihornerenc, 'iHF'};
				{ @pvihornerbzenc, 'iHFBZ'};

				{ @pvimeanvalenc, 'iMVF'};
				{ @pvislopeenc, 'iSF'} ;
				{ @pvimeanvalbcenc, 'iMVFBC'};

				{ @pvitaylorenc, 'iTF'};
				{ @pvitaylorbmenc, 'iTFBM'};

				{ @pvibernsteinenc, 'iBF'};
				{ @pvibernsteinbzenc, 'iBFBZ'};

				{ @pviinterpolationenc, 'iIF'};
				{ @pviinterpolation2enc, 'iIF2'};
				{ @pviinterpolationslenc, 'iISF'};
		};

	tests_prms = { 

				struct('deg',  4, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu11_');
				struct('deg',  5, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu12_');
				struct('deg',  6, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu13_');
				struct('deg',  7, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu14_');
				struct('deg', 11, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu15_');
				struct('deg', 16, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu16_');
				struct('deg', 21, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu17_');
				struct('deg', 26, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu18_');
				struct('deg', 31, 'interval', infsup(-0.03, 0.02), 'prefix', 'iu19_');

				struct('deg',  4, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu21_');
				struct('deg',  5, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu22_');
				struct('deg',  6, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu23_');
				struct('deg',  7, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu24_');
				struct('deg', 11, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu25_');
				struct('deg', 16, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu26_');
				struct('deg', 21, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu27_');
				struct('deg', 26, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu28_');
				struct('deg', 31, 'interval', infsup(-0.015, 0.01), 'prefix', 'iu29_');

				struct('deg',  4, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu31_');
				struct('deg',  5, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu32_');
				struct('deg',  6, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu33_');
				struct('deg',  7, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu34_');
				struct('deg', 11, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu35_');
				struct('deg', 16, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu36_');
				struct('deg', 21, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu37_');
				struct('deg', 26, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu38_');
				struct('deg', 31, 'interval', infsup(-0.01, 0.01), 'prefix', 'iu39_');

				struct('deg',  4, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu41_');
				struct('deg',  5, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu42_');
				struct('deg',  6, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu43_');
				struct('deg',  7, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu44_');
				struct('deg', 11, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu45_');
				struct('deg', 16, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu46_');
				struct('deg', 21, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu47_');
				struct('deg', 26, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu48_');
				struct('deg', 31, 'interval', infsup(-0.03, -0.02), 'prefix', 'iu49_');

				struct('deg',  4, 'interval', infsup(0.02, 0.03), 'prefix', 'iu51_');
				struct('deg',  5, 'interval', infsup(0.02, 0.03), 'prefix', 'iu52_');
				struct('deg',  6, 'interval', infsup(0.02, 0.03), 'prefix', 'iu53_');
				struct('deg',  7, 'interval', infsup(0.02, 0.03), 'prefix', 'iu54_');
				struct('deg', 11, 'interval', infsup(0.02, 0.03), 'prefix', 'iu55_');
				struct('deg', 16, 'interval', infsup(0.02, 0.03), 'prefix', 'iu56_');
				struct('deg', 21, 'interval', infsup(0.02, 0.03), 'prefix', 'iu57_');
				struct('deg', 26, 'interval', infsup(0.02, 0.03), 'prefix', 'iu58_');
				struct('deg', 31, 'interval', infsup(0.02, 0.03), 'prefix', 'iu59_');
			};

	%tests_prms = { struct('deg',  4, 'interval', infsup(-0.3, 0.2), 'prefix', 'x11_')};

	exec_tests(tests_prms, repetitions, @generate_polynomials_interval,...
				@evaluate_polynomial_int, forms_structs, stats_filename)
end

function exec_tests(tests_prms, repetitions, gen_polynomial_handler,...
					evaluate_polynomial_handler, forms_structs, stats_filename)

	[~,~] = mkdir('stats_out');
	stats_fileID = fopen( [ 'stats_out' filesep stats_filename '.txt' ], 'w');
	time_stats_fileID = fopen( [ 'stats_out' filesep stats_filename '_t.txt'], 'w');

	tests_cnt = length(tests_prms);
	for i = 1:tests_cnt

		fprintf('Test case        %4i/%i\n', i, tests_cnt);

		test_filename = test(tests_prms{i}.deg, repetitions, ...
						gen_polynomial_handler, ...
						evaluate_polynomial_handler, ...
						tests_prms{i}.interval, forms_structs, tests_prms{i}.prefix);

		make_stats(test_filename, stats_fileID, time_stats_fileID);
	end

	fclose(stats_fileID);
	fclose(time_stats_fileID);
end
