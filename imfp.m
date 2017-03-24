%
% To use parallelization run it with string 'par'
%
function imfp(par_opt)

	has_intval_arithmetic = which('infsup');
	if (isempty(has_intval_arithmetic))
		disp('---- Please initialize INTLAB, then call this function again.');
		return
	end

	loc = which('imfp.m');
	IMFP_DIR = loc(1:end-6);

	addpath( [ IMFP_DIR filesep 'forms' ] );
	addpath( [ IMFP_DIR filesep 'misc' ] );
	addpath( [ IMFP_DIR filesep 'tests' ] );

	running_octave = 0 ~= exist('OCTAVE_VERSION', 'builtin'); 

	if (running_octave)
		% to support octave specific functions
		addpath( [ IMFP_DIR filesep 'octave_env' ] );
	%else
	%	addpath( [ IMFP_DIR filesep 'matlab_env' ] );
	end

	% 1 for parallel
	par = 0;
	if ((1 == nargin) && strcmp(par_opt,'par'))
		par = 1;
	end

	if (par && running_octave)

		has_par = pkg('list','parallel');

		if (isempty(has_par))

			warning('Pkg parallel not found');

			disp 'Installing pkg struct-1.0.14.tar.gz'
			pkg('install',[ IMFP_DIR filesep 'lib' filesep 'struct-1.0.14.tar.gz']);
			disp 'Pkg struct-1.0.14.tar.gz installed'

			disp 'Installing pkg parallel-3.1.1.tar.gz'
			pkg('install',[ IMFP_DIR filesep 'lib' filesep 'parallel-3.1.1.tar.gz']);
			disp 'Pkg parallel-3.1.1.tar.gz installed'

		end

		pkg load struct
		pkg load parallel

		% running script makes local functions global in octave,
		% not working in matlab :/
		load_interval_forms_par
		addpath( [ IMFP_DIR filesep 'misc/evaluate_polynomial/private' ] );
		disp 'paralell...'

		main
		return
	end

	if (par && ~running_octave)
		warning('Parallelization cannot be established.');
	end

	disp 'no paralell...'
	% in matlab cannot promote local function to global
	% by calling script :/
	addpath( [ IMFP_DIR filesep 'misc/interval_polynomial_forms' ] );
	% shade parallel version
	addpath( [ IMFP_DIR filesep 'misc/evaluate_polynomial' ] );

	main
	return
end
%% start of misc

function main

	run_tests;
end
