Main script : LineWidthExplorer.m (a Matlab Object)

Helper script (good start point) : LineWidthExplorerGUI.m

This software package makes sense in the context of the following downloadable scientific publication in OSA's optics express 2016 : "Time-Dependant Laser Linewidth : beat-note digital acquisition and numerical analysis", N.Von Bandel, M. Myara, M. Sellahi, T. Souici, R. Dardaillon and P.Signoret.

Both software and publication can be downloaded for free. The publication is under OSA license, while the software is under BSD license. Please cite our Optics Express publication if you use this software or part of this software in the frame of scientific works or publications. Please mention the authors of this software if you reuse this code or part of this code in another software.

This part of the software was made to analyse the beat-note spectrum as a function of integration time. Can be time consuming or not, depending on the parameters selected for the data analysis. This software contains both a class for the data analysis part and the code for a useful GUI, that helps determining the relevant parameters for the computation of the laser linewidth as a function of time.
BeatingDemodulation : a function that implements the Hilbert Transform. It performs thus the phase demodulation of the beating and allows to obtain the associated frequency noise. The software is not really complex but it gives well calibrated results (this was checked through experimental work). 
