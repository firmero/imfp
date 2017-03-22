%
%
%
function test_filename = test(deg, polynomials_count, polynomials_generator,...
								X, forms_struct, prefix)
	test_out_dir = 'tests_out';
	[~,~] = mkdir(test_out_dir);

	test_dir_prefix = [test_out_dir filesep prefix];

	polynomials = polynomials_generator(deg, polynomials_count);
	polynomials_ranges = repmat(intval(0),polynomials_count,1);

	for i = 1:polynomials_count

		% real value
		polynomials_ranges(i) = evaluate_polynomial(polynomials(i,:),X);

		fprintf('\rEval polynomial: %4i/%i', i, polynomials_count);
	end
	fprintf('\n');

	form_cnt = length(forms_struct);
	filenames = repmat(struct('form',''),form_cnt,1);

	for i = 1:form_cnt

		ranges = repmat(intval(0),polynomials_count,1);
		eval_time = zeros(polynomials_count,1);

		for j = 1:polynomials_count
			fprintf('\rEval form: %4i/%i polynomial: %4i/%i',...
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
		% in binary mode
		save(filename, 'form', '-mat');

		filenames(i).form = filename;

	end
	fprintf('\n');

	test.X = X;
	test.polynomials_count = polynomials_count;
	test.deg = deg;
	test.polynomials = polynomials;
	% the 'real' values of polynomials
	test.polynomials_ranges = polynomials_ranges;

	test.forms_count = form_cnt;
	test.filenames = filenames;

	test_filename = [ test_dir_prefix 'test.bin' ];

	save(test_filename,'test', '-mat');

end

