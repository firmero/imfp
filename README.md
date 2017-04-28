## Documentation

### Introduction
Package pv (polynomial value) implements methods evaluating range of polynomial  
over interval. Polynomial can have interval coefficients.
  
Methods are based on the following form:  
* Horner  
* Bernstein  
* Taylor  
* Mean value  
* Slope  
* Interpolation  
  
The source code is commented and the documentation in doc folders is generated  
from them. More details about the mentioned forms and their modification for  
special cases can be found there. For genarating documentation is used  
documentation system [ocdoc](http://kam.mff.cuni.cz/~horacek/projekty/ocdoc/).
  
To load functions to your workspace you need to call pvinit. In octave  
it is possible to run some code from pv in parallel mode. That can be enabled by  
calling pvinit with argument 'par'. Packages parallel-3.1.1 and its dependency  
struct-1.0.14 are used to achieve it. They can be installed during pvinit  
execution. Pvinit loads pkg tests to make its functions available.  
Parallelization is used in evaluation of interval polynomials. Interval polynomial  
is reduced to 2 or 4 polynomial with point coefficients. It also speeds up  
function used in tests for getting as tight as possible range, which is slow.  
  
After initialization, it should be possible to call function from directory  
pv having prefix pv. These methods works for polynomials with point (not intval  
type) coefficients. The functions for evaluating polynomial with interval  
coefficients have almost the same name. They differ only in prefix, which is pvi.  
Helper functions that are used by implementation are in directory aux.
  
For interval arithmetic it's recommended to use INTLAB (Matlab/Octave).  
Octave interval pkg is also an option. Code uses INTLAB's function names.  
Using octave interval pkg pvinit remaps INTLAB's function to octave equivalent.  
(TODO getround, setround octave equivalent?)
  
Code works in Octave 4.0.3 and Matlab R2017a (9.2.0.538062).  
Tested with INTLAB v9 and octave interval pkg (located in lib folder).

### Tests
Functions for that purpose are in pkg tests which is documented. To use it, pvinit  
is needed to call.

Test suites are hardcoded in file run\_tests.m and can be easily added or removed  
from there. By default, none of test suites runs by calling run\_tests function.  
To enable uncomment proper suite in run\_tests function. Test suite has  
as argument filename of statistics and how many times  should be one test repeated.  
Generated files appear in directories stats\_out and tests\_out.  

Test suites use polynomials of deg 4,5,6,7,11,16,21,26,31.  
Polynomials with point coefficients have random coefficients from (-1,1).  
Interval polynomials coefficients have middle in (-0.9,0.9) and radius < 0.05.  

Interval polynomials are tested with suites 2 and 4. Polynomials with point  
coefficients in 1 and 3.

Test suites 1 and 2 use intervals:  
\[-0.3,0.2] \[-0.15, 0.1] \[-0.1,0.1] \[-0.3,-0.2] \[0.2,0.3]  
Test suites 3 and 4:  
\[-0.03,0.02] \[-0.015, 0.01] \[-0.01,0.01] \[-0.03,-0.02] \[0.02,0.03]  

### Stats
Copy of generated tests data is in directory report. It also contains  
tables produced by script table.awk used on stats files. That script  
can use as output values median, mean, min, max.  
Data was produced in Matlab.  

Stats uses the following function to get values for statistics:  
100 * (width(ix) - width(iy)) / width(ix)  
ix is range produced by form, iy is reference range  

Some observations from stats output for polynomial with point coefficients:  
* HFBZ: for interval not containing 0 faster while not using interval  
  arithmetic and it gives half overestimation of HF.  
* MVF: very similar ranges to HF, for wider interval even worse.  
  2 times slower than HF.  
* SF: also very similar to HF, but for interval x without 0 gives  
  half overestimation of HF. 3-5 slower than HF.  
* MVFBC: the most time gives very precise range. 3 slower than HF.  
* IF, IF2: IF2 can give a little better range as IF, but not worse.  
  Tight range. 4 time slower than HF.  
* ISF: very tight range. 4 times slower than HF.  
* TF: similar to HF. For interval x without 0 gives half overestimation of HF.  
  Similar ranges to SF but with increasing degree is much more slower.  
* TFBM: ranges similar to HFBM, but work very well also on interval without 0.  
  In average it gives half overestimation of TF. Runtime is like TF.  
* BF: the most precise but the most time consuming form.  
* BFBM: in average overestimation reduced by half comaped to BF.  
  For interval x with zero runs twice longer than BF.  

Some observations from stats output for polynomial with interval coefficients:  
Evaluation of interval polynomial over x with zero is reduced to evaluation  
of 4 point polynomials (over interval [inf(x),0] and [0,sup(x)]). So, form  
specialized for interval with zero gives same range as their non specialized  
version.  The following observations are based on data from Matlab with INTLAB  
generated by non parallel functions.  
* iHFBZ: same range as iHF. Faster than iHF for x without 0, while not using  
  interval arithmetic.  
* iMVF: very similar ranges to iHF, 2-3 slower than iHF.  
* iSF: iHF gives 2-4 worse range, 3 slower than iHF.  
* iMVFBC: the most time gives very precise range, 3 slower than iHF.  
* iIF, iIF2: iIF2 can give a little better range as iIF, but not worse.  
  Tight range. 4 time slower than HF.  
* iISF: iHF gives 2-4 worse range, 3 slower than iHF, for interval  
  without zero 2 times.  
* iTF: similar ranges to iSF but with increasing degree is much more slower.  
* iTFBM: in average it gives half overestimation of iTF. Runtime is like iTF.  
* iBF: the most precise but the most time consuming form.  
* iBFBM: for interval x with zero runs twice longer than iBF.  
  Gives same range as iBF.

