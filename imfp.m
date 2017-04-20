function imfp(par_opt)
%BEGINDOC==================================================================
% .Author
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
% .Todo
%
%
%ENDDOC====================================================================
%
% To use parallelization run it with string 'par'
%

has_intval_arithmetic = which('infsup');
if (isempty(has_intval_arithmetic))
	disp('---- Please initialize INTLAB, then call this function again.');
	return
end

loc = which('imfp.m');
global IMFP_DIR;
IMFP_DIR = loc(1:end-6);

addpath( [ IMFP_DIR filesep 'forms' ] );
addpath( [ IMFP_DIR filesep 'forms' filesep 'aux' ] );

addpath( [ IMFP_DIR filesep 'tests' ] );
addpath( [ IMFP_DIR filesep 'tests' filesep 'aux' ] );

running_octave = 0 ~= exist('OCTAVE_VERSION', 'builtin'); 

if (running_octave)
	% to support octave specific functions
	addpath( [ IMFP_DIR filesep 'forms' filesep 'aux' filesep 'octave_env'] );
	addpath( [ IMFP_DIR filesep 'tests' filesep 'aux' filesep 'octave_env'] );
%else
%	addpath( [ IMFP_DIR filesep 'forms' filesep 'aux' filesep 'matlab_env'] );
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
		c = input('Do you want to install pkg parallel and dependencies? y/n :','s');
		if (strcmp(c,'y'))

			disp 'Installing pkg struct-1.0.14.tar.gz';
			pkg('install',[ IMFP_DIR filesep 'lib' filesep 'struct-1.0.14.tar.gz']);
			disp 'Pkg struct-1.0.14.tar.gz installed';

			disp 'Installing pkg parallel-3.1.1.tar.gz';
			pkg('install',[ IMFP_DIR filesep 'lib' filesep 'parallel-3.1.1.tar.gz']);
			disp 'Pkg parallel-3.1.1.tar.gz installed';
		else
			warning('Parallelization cannot be established.');
			load_noparallel;
			return
		end

	end

	pkg load struct;
	pkg load parallel;

	% running script makes local functions global in octave,
	% not working in matlab :/
	load_interval_forms_par;

	% while testing use parallel version of evaluation of polynomial
	addpath( [ IMFP_DIR filesep 'tests/aux/evaluate_polynomial/private' ] );
	disp 'paralell...';

	main;
	return
end

if (par && ~running_octave)
	warning('Parallelization cannot be established in matlab.');
end

load_noparallel;
main;
return

end

function load_noparallel

	global IMFP_DIR;

	disp 'no paralell...';
	% in matlab cannot promote local function to global
	% by calling script :/
	addpath( [ IMFP_DIR filesep 'forms/aux/interval_polynomial_forms' ] );
	% shade parallel version
	addpath( [ IMFP_DIR filesep 'tests/aux/evaluate_polynomial' ] );
end

function main

	run_tests;
end
