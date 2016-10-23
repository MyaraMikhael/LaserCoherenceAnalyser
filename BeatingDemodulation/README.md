Main script : BeatingDemodulation.m (a Matlab Object)
Helper script (good start point) : BeatingDemodulationExample.m

This software package makes sense in the context of the following downloadable scientific publication in OSA's optics express 2016 : "Time-Dependant Laser Linewidth : beat-note digital acquisition and numerical analysis", N.Von Bandel, M. Myara, M. Sellahi, T. Souici, R. Dardaillon and P.Signoret.

Both software and publication can be downloaded for free. The publication is under OSA license, while the software is under BSD license. Please cite our Optics Express publication if you use this software or part of this software in the frame of scientific works or publications. Please mention the authors of this software if you reuse this code or part of this code in another software.

This part of the software mainly contains a function that implements the Hilbert Transform. It performs thus the phase demodulation of the beating and allows to obtain the associated frequency noise. The software is not really complex but it gives well calibrated results (this was checked through experimental work).
This function takes as argument a Matlab workspace file which may contain the following :
a "dt" field containing the sampling frequency in seconds. The Matlab type should be "double".
a column vector named "Y" containing the sampled beat-note. The Matlab type should be "double" too.

This software was tested under Matlab 2014b for Macintosh and requires both Signal Analysis Toolbox. Of course it should work under Windows and Linux, as older versions of the software were implemented on these platforms. As all this software relies a lot on FFT implemetation, it should work really quickly on multicore computers.
