function ocdoc ()
%BEGINDOC=================================================================
% .Author.
%
%  Jaroslav Horacek
%
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% .Description.
%
%   OcDoc is a lightweight documentation tool for Octave
%   It searches for all .m files in the currents working directory 
%   and creates an automatic documentation into a doc directory in
%   a form of .thml page  
%
%-------------------------------------------------------------------------
% .Input parameters.
%   
% There are no inputs yet
%
%------------------------------------------------------------------------
% .Output parameters.
%
% There are no outputs yet
%
%------------------------------------------------------------------------
% .Implementation details. 
%
%
%------------------------------------------------------------------------
% 
% .Copyright. 
%   
%   (C) 2016  Jaroslav Horacek
%
%   LIME 1.0 is free for private use and for purely academic purposes. 
%   It would be very kind from the future user of LIME 1.0 to give 
%   reference that this software package has been developed 
%   by .... at Charles University, Czech Republic.
%
%   For any other use of LIME 1.0 a license is required.
%
%   THIS SOFTWARE IS PROVIDED AS IS AND WITHOUT ANY EXPRESS OR IMPLIED 
%   WARRANTIES, INCLUDING, WITHOUT LIMITATIONS, THE IMPLIED WARRANTIES 
%   OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.    
%    
%-------------------------------------------------------------------------
% .History.
%       
%   2016-10-20    first version
%
%------------------------------------------------------------------------
% .Todo.
%  
%
%ENDDOC===================================================================


% makes list of all .m files contained in directory 
% takes only .m files
  filestodoc = ls('-1 *enc.m');
  [m, n] = size(filestodoc);

  
 printf("         ******                \n");
 printf("        * _  _ *               \n");
 printf("        *(o)(o)*      -----    \n");
 printf("         *    *       OcDoc    \n");
 printf("        ** ** **      -----    \n");
 printf("       ** ** ** **    2016     \n");     
 printf("         *  *  *              \n");
  
  

  date = ctime (time());
  [status, msg] = mkdir ("doc");

  if (status != 1)
    disp(msg);
    return
  end
  
  printf("Directory doc created \n");

% ========================================================================================
% creating css file ======================================================================
% ========================================================================================
  cssfile = "doc/style.css";
  [fcss, msg] = fopen (cssfile, "w");

  % test of opening file
  if (fcss == -1)
    disp(msg);
    return
  end
  
  fprintf(fcss, "/* CSS file for MatlabDoc documentation  */ \n \n");
  fprintf(fcss, "body { position: relative; margin: 0 auto; height:100%%; font-family:Verdana; font-size: 16px; line-height: 1.5} \n" );
  fprintf(fcss, ".caption {  background-color: #CCFF66; font-size: 24px; line-height: 3;} \n");
  fprintf(fcss, ".section { background-color: #CCFF66; font-size: 24px; line-height: 2; } \n");
  fprintf(fcss, ".subsection { background-color: #CCFFCC; font-size: 18px;} \n");
  fprintf(fcss, "#obsah { position:relative; width:900; height:120%%; margin: 0 auto} \n");
  fprintf(fcss, "#text { position:relative; width:800;height:100%%; margin:0 50 0 50; text-indent:0px; } \n");
  fprintf(fcss, "/* Generated automatically by OcDoc %s */ \n", date);

  fclose(fcss);
  
  
  
  printf("File doc/style.css created \n");
 
 
% ======================================================================================== 
% creating html index file ===============================================================
% ========================================================================================
  [findex, msg] = fopen("doc/index.html", "w");
 
  % test of opening file
  if (findex == -1)
    disp(msg);
    return
  end 
 
  fprintf(findex, "<html> \n");
  fprintf(findex, "<head> \n");
  fprintf(findex, "<title>Documentation by OcDoc</title> \n");  
  fprintf(findex, "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-9\"> \n");
  fprintf(findex, "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"> \n");
  fprintf(findex, "</head> \n");
  fprintf(findex, "<div id=\"obsah\"> \n");
  fprintf(findex, "<div id=\"text\"> \n");

  % extracting name of supfolder
  path = pwd;
  parts = strsplit(path, '/');
  directory = parts{end};
  fprintf(findex, "&nbsp; <h1 class=\"section\"> &nbsp; Documentation for package <code> %s </code> </h1> ", directory);
  fprintf(findex, "<ul>");


% ========================================================================================
% creating .html files for every function ================================================
% ========================================================================================
for i=1:m

  filename = filestodoc(i, :);
  filename = strtrim(filename);
  len = length(filename);
  functionname = filename(1:len-2);
  docfilename = strcat("doc/", functionname, ".html");


  outputon = 0; % indicates whether commented lines are transfered to documentation 
  description = 0;
  docon = 0;

  [fin, msg] = fopen (filename, "r");
  
  % test of opening file
  if (fin == -1)
    disp(msg);
    return
  end
  
  
  [fout, msg] = fopen (docfilename, "w");
  
  % test of opening file
  if (fout == -1)
    disp(msg);
    return
  end
 
  
  fprintf(fout, "<html> \n");
  fprintf(fout, "<head> \n");
  fprintf(fout, "<title>%s.m</title> \n", functionname);
  fprintf(fout, "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-9\"> \n");
  fprintf(fout, "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\"> \n");
  fprintf(fout, "</head> \n");
  fprintf(fout, "<div id=\"obsah\"> \n");
  fprintf(fout, "<div id=\"text\"> \n");

  fprintf(fout, "<br> &nbsp; <a href=\"index.html\">&lt;&lt; back to list of functions </a> \n");

  fprintf(fout, "<br> \n");
  fprintf(fout, "&nbsp; <h1 class=\"section\"> &nbsp; function <code> %s.m </code> </h1> ", functionname);



  while (! feof (fin) )
    textline = fgetl (fin);
  
      % line of at least two characters
      if length(textline) > 0
  
        % line is a comment
        if textline(1) == "%"
    
        % trim of line
        textline = textline(2:end);
        textline = strtrim(textline);
        
        if index(textline, "BEGINDOC")
          docon = 1;
          continue;
        end
        
        if index(textline, "ENDDOC")
          docon = 0;
          break;
        end
      
        % we are currently within BEGINDOC-ENDDOC
        if docon
      
          if isempty(textline)
            fprintf(fout, "<br> \n");
            continue;
          end
            
          % start output
          if strcmp(textline, ".Author.") || strcmp(textline, ".Input parameters.") || strcmp(textline, ".Output parameters.") || strcmp(textline, ".Implementation details.") || strcmp(textline, ".License.") || strcmp(textline, ".History.") || strcmp(textline, ".Todo.")
            outputon = 1; 
         
            % print headline (trim dots)
            fprintf(fout, "<h2 class=\"subsection\"> &nbsp; %s </h2> \n", textline(2:end-1));
            continue; 
          end
      
          % for ".Description." writes first line to also to index.html    
          if strcmp(textline, ".Description.") 
            outputon = 1;
            description = 1; 
         
            % print headline (trim dots)
            fprintf(fout, "<h2 class=\"subsection\"> &nbsp; %s </h2> \n", textline(2:end-1) );
            fprintf(findex, "<li> <a href=\" %s.html \"> %s.m </a> - \n", functionname, functionname);
         
            continue;
         
          end
      
         
          % end output    
          if textline(1) == "-"
            outputon = 0;
            description = 0;
          end
      
          if outputon
          
            % displaying variables in bold, search for "..."
            in = index(textline, "...");
            if in
              fprintf(fout, "<b> %s </b> %s <br> \n", textline(1:in-1), textline(in:end) );              
            
            else
              fprintf(fout, "%s <br> \n", textline);
            end
          end
      
          if description 
            fprintf(findex, "%s <br> \n", textline);
            description = 0;
          end
        
        end
          
      end
    end
  endwhile 

  fprintf(fout, "<br><br><br><br> \n");
  fprintf(fout, "<hr> \n");
  fprintf(fout, "<code> Generated automatically by OcDoc %s </code> \n", date)
  fprintf(fout, "</div> \n");
  fprintf(fout, "</div> \n");
  fprintf(fout, "</body> \n");
  fprintf(fout, "</html> \n");


  fclose(fin);
  fclose(fout);

  printf("File %s created \n", docfilename);

end
fprintf(findex, "</ul>");

%%my section

fprintf(findex, '&nbsp; <h1 class=\"section\" style="font-size: 20px"> &nbsp; Interval coefficients version</h1>');

fprintf(findex, 'Package pv also contain functions for evaluating range of polynomials<br>');
fprintf(findex, 'with interval coefficients. They have almost the same name as their non interval<br>');
fprintf(findex, 'version. They differ in the prefix which is pvi. ');
fprintf(findex, 'The order of input arguments is the same.<br>');
fprintf(findex, 'Instead of point coefficients it should be used interval.<br>');

fprintf(findex, 'These functions are aliases for calling function ');
fprintf(findex, '<a target="_blank" href="../aux/doc/interval_polynomial_form.html">interval_polynomial_form</a>');
fprintf(findex, ' with proper arguments.');

%%end of my section

% finishing index.html
fprintf(findex, "<hr> \n");
fprintf(findex, "<code> Generated automatically by OcDoc %s </code> \n", date)
fprintf(findex, "</div> \n");
fprintf(findex, "</div> \n");
fprintf(findex, "</body> \n");
fprintf(findex, "</html> \n");

fclose(findex);
printf("File doc/index.html created \n");

printf("Done... \n", docfilename);

end
