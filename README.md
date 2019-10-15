# `AErOOtools` : Aircraft Equations of Motion Object-oriented Tools

This toolbox provides object-oriented tools to model aircraft equations of motion as well as aerodynamic coefficients. 
The source code may be used, modified, and distributed in the understanding that license and copyright information are preserved; the latter does not apply if distributed unaltered as library. (GNU LGPL-2.1) Full license information can be found in the repository. The toolbox has been created, developed, and maintained 2018--today by Torbjørn Cunis.

## Usage

`AErOOtools` is written purely in MATLAB and can be used either as stand-alone toolbox or as package folder:

1. **stand-alone**: check-out the *master* branch and add the root folder to your MATLAB path variable. The namespaces `eompkg` and `aerocoeffs` are provided for the equations of motion auxiliary classes and aerodynamic coefficients, respectively.
1. **package folder**: check-out the *package* branch and add its **parent** folder to your MATLAB path. The namespace `aerootools` is now provided with subpackage namespaces `pkg` and `coeffs` as described above.

In brief, the equations of motion are modeled as autonomous, ordinary differential equations
```
   dx = f(x,u,μ)
    y = g(x,u,μ)
```
where `x` is the state vector, `u` is the input vector, `μ` is a vector of (optional) parameters, `y` is the output vector, and `dx` is the first derivative of `x` by the time `t`. For the aircraft, the state is here considered to be the *aerodynamic* variables (airspeed, angle of attack, etc.) as well as orientation and body rates, whereas the aircraft's change of position with respect to an observer (i.e., its position in earth-fixed coordinates) constitute an output of the equations of motion. Inputs are the aircraft's control surfaces as well as its engine; and the optional parameters could include, e.g., system parameters or external disturbances.

At top-level, `AErOOtools` provides two classes, `EOM3` and `EOM6`, modeling the aircraft longitudinal and six-degrees-of-freedom (6-DOF) equations of motion. In order to model a specific aircraft, derive from either of the two classes and implement its abstract methods for the aerodynamic coefficients. The abstract classes of `aerocoeffs` (`coeffs` in *package* mode) can help to model the aircraft's aerodynamic coefficients as functions of angle of attack, side-slip (6-DOF only), normalized body rates, and surface deflections. The additional classes in `eompkg` (`pkg` in *package* mode) represent the state, input, and output vectors of the equations of motion as well as further parameters. They may or may not be inherited from in order to add further functionality. Furthermore, the pair of super classes `RealFunctions` and `PolyApproximations` facilitate the polynomial approximation of the (by default real) equations of motion, providing Taylor expansions of the trigonometric functions, the inversion, and the square root.

Indeed, inheriting any of the provided classes and overriding the respective member function(s) allows to adjust both the definition of equations of motion as well as its states, inputs, or outputs to any specific needs.

## Notes
*Please note*: I have developed these tools during and for my PhD thesis. It is understood that parts may be untested and I do not provide warranty nor liability for its present or future functionality.
