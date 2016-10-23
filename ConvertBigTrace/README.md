Main script : ConvertBigTrace.m (a Matlab Function)

This software package makes sense in the context of the following downloadable scientific publication in OSA's optics express 2016 : "Time-Dependant Laser Linewidth : beat-note digital acquisition and numerical analysis", N.Von Bandel, M. Myara, M. Sellahi, T. Souici, R. Dardaillon and P.Signoret.

Both software and publication can be downloaded for free. The publication is under OSA license, while the software is under BSD license. Please cite our Optics Express publication if you use this software or part of this software in the frame of scientific works or publications. Please mention the authors of this software if you reuse this code or part of this code in another software.

This part of the software mainly contains a function called "ConvertBigTrace" transforming Agilent's TSC files into a matlab workspace file suitable for both BeatingDemodulation and LineWidthExplorer Softwares. The structure of the generated files is :
a "dt" field containing the sampling frequency in seconds. The Matlab type should be "double".
a column vector named "Y" containing the sampled beat-note. The Matlab type should be "double" too.


