function pvinit(par_opt)
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
%  par_opt ... optional parallelization
%              to use parallelization use string 'par' (only Octave)
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

running_octave = 0 ~= exist('OCTAVE_VERSION', 'builtin'); 
has_intval_arithmetic = which('infsup');

loc = mfilename('fullpath');
global LOC_DIR;
LOC_DIR = loc(1:end-7);

if (isempty(has_intval_arithmetic))
	disp('-- Please initialize interval arithmetic, then call this function again.');
	if (running_octave)
		disp('It is possible to use INTLAB or Octave interval pkg.');
		disp('-- In octave to get the latest version of interval pkg you can use command:');
		disp('pkg install -forge interval');

		disp('-- Or install interval pkg from lib directory:');
		interval_pkg = [ LOC_DIR filesep 'lib' filesep 'interval-2.1.0.tar.gz'];
		disp([ 'pkg install ' interval_pkg ]);
		disp('-- To load octave interval use:');
		disp('pkg load interval');
	end
	return
end

addpath( [ LOC_DIR filesep 'pv' ] );
addpath( [ LOC_DIR filesep 'pv' filesep 'aux' ] );

addpath( [ LOC_DIR filesep 'tests' ] );
addpath( [ LOC_DIR filesep 'tests' filesep 'aux' ] );


if (running_octave)

	% to support octave specific functions
	addpath( [ LOC_DIR filesep 'pv' filesep 'aux' filesep 'octave_env'] );
	addpath( [ LOC_DIR filesep 'tests' filesep 'aux' filesep 'octave_env'] );

	has_intlab = which('intval');

	if (isempty(has_intlab))
		load_intlab_camouflage
		disp 'problem...'
	end
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
			pkg('install',[ LOC_DIR filesep 'lib' filesep 'struct-1.0.14.tar.gz']);
			disp 'Pkg struct-1.0.14.tar.gz installed';

			disp 'Installing pkg parallel-3.1.1.tar.gz';
			pkg('install',[ LOC_DIR filesep 'lib' filesep 'parallel-3.1.1.tar.gz']);
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
	% load forms for interval polynomial, they use parallelism
	load_interval_forms_par;

	% while testing use parallel version of evaluation of polynomial
	addpath( [ LOC_DIR filesep 'tests/aux/evaluate_polynomial/private' ] );
	disp 'DEBUG: paralell...';

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

	global LOC_DIR;

	disp 'DEBUG: no paralell...';
	% in matlab cannot promote local function to global
	% by calling script :/
	addpath( [ LOC_DIR filesep 'pv/aux/interval_polynomial_forms' ] );
	% shade parallel version
	addpath( [ LOC_DIR filesep 'tests/aux/evaluate_polynomial' ] );
end

function main
	%run_tests;
end
