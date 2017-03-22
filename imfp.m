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
	addpath( [ IFMP_DIR filesep 'tests' ] );

	running_octave = 0 ~= exist('OCTAVE_VERSION', 'builtin'); 

	if (running_octave)
		addpath( [ IFMP_DIR filesep 'octave_env' ] );
	%else
	%	addpath( [ IFMP_DIR filesep 'matlab_env' ] );
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


	run_tests

end
