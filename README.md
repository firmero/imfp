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
### Stats
