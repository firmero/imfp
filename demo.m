function demo

disp ' Package pv implements methods evaluating enclosure of range of polynomial'
disp ' over interval. Polynomial can have interval coefficients.'
disp ' ' 

disp ' To init pkg pv use pvinit. Can be called with argument ''par'' to enable'
disp ' parallelization, in Octave, in evaluation of interval polynomials'
disp ' and speeds up test pkg.'
disp ' ' 

disp ' Then it enables functions:'
disp ' * pvhornerenc (Horner form)'
disp '   pvhornerbzenc (Horner form with bisection at the zero)'
disp '   pvhornerlzenc (Horner form left zero) - only for non-interval polynomial'
disp ' * pvbernsteinenc (Bernstein form)'
disp '   pvbernsteibznenc (Bernstein form with bisection at the zero)'
disp ' * pvtaylorenc (Taylor form)'
disp '   pvtaylorbmenc (Taylor form with bisection of translated interval in the middle)'
disp ' * pvmeanvalenc (Mean value form)'
disp '   pvmeanvalbcenc (Bicentred mean value form) '
disp ' * pvinterpolationenc (Interpolation form)'
disp '   pvinterpolation2enc (Interpolation form 2)'
disp '   pvinterpolationslenc (Interpolation slope form)' 
disp ' * pvslopeenc (Slope form)'
disp ' '

disp ' The methods for interval polynomials have prefix pvi instead of pv.'
disp ' '

disp ' They have arguments such as (interval) coefficients of polynomial and interval'
disp ' over which we want to get enclosure. Some of them can have optional arguments.'
disp ' '
disp ' For example to get enclosure of range of 34x^4 + 3x^3 - 20x^2 - 4 '
disp ' based on Bernstein form with bisection at the zero of [-0.7,0.6] we use:'
disp ' '
disp '>>  pvbernsteinbzenc([34 3 -20 0 -4], infsup(-0.7,0.6))'
disp ' '

disp ' Example for interval polynomial:'
disp '>> ip = [ infsup(33.61,34.9) infsup(2.99, 3.38) intval(-20) 0 -4]'
disp '>> ix = infsup(-0.7,0.6)'
disp '>> pvinterpolationslenc(ip,ix)'
disp ' '

disp ' Package pv has two main functions solving this problem, pvenc and pvienc.'
disp ' They have the optional third parameter influencing approach of evaluation.'
disp ' That argument can have value: FAST, FASTER, EFFECTIVE, TIGHTER, TIGHTEST.'
disp ' Default mode is EFFECTIVE, which is typically a compromise between time'
disp ' and precision.'
disp ' '

disp ' For example:'

disp '>> p = [1.5 6.2 -4.9 -6.8 -8.6]; ix = infsup(-0.4,0.2);'
disp '>> pvenc(p,ix,''FASTEST'')'
disp '>> pvenc(p,ix,''TIGHTEST'')'
disp '>> pvenc(p,ix)'
disp '>> ip = [infsup(7.55,7.85) infsup(6.17,6.88) infsup(-0.15,0.8) infsup(0.7,0.8)];'
disp '>> pvienc(ip,ix,''TIGHTEST'')'
disp ' ' 


disp ' More details can be found in doc directory and README.'
disp ' '

end
