# A four-dimensional computational model of dynamic contrast-enhanced magnetic resonance imaging measurement of subtle blood-brain barrier leakage

## Publication available
If you use our computational model in your research, please quote the following paper:

> Bernal, J.; Valdés-Hernández, M.; Escudero, J.; Heye, A.; Sakka, E.; Armitage, P.; Makin, S.; Touyz, R.; Wardlaw, J.; Thrippleton, M.  (2021). A four-dimensional computational model of dynamic contrast-enhanced magnetic resonance imaging measurement of subtle blood-brain barrier leakage. NeuroImage, 230, 117786. (https://doi.org/10.1016/j.neuroimage.2021.117786)

## Introduction
Dynamic contrast-enhanced MRI (DCE-MRI) quantifies endothelial dysfunction but is prone to spatiotemporal distortions. In low-permeability scenarios, 1D simulations have shown that noise, scanner drift, and model assumptions hinder permeability estimation [1]. However, the impact of bulk motion and truncation and motion artefacts has been overlooked and cannot be evaluated in 1D. Moreover, imaging protocols are based on limited evidence due to protocol optimisation difficulties and lack of reference methods [2]. We propose a computational model based on real patient data for mimicking the DCE-MRI acquisition process in 4D to evaluate the aforementioned issues and better facilitate protocol optimisation and future testing. 

## Materials and methods
DCE-MRI consists of discretising a dynamic object to a set of finite spatial frequencies and samples in time. We simulated this process through three main steps: MR signal generation, signal sampling, and model fitting to estimate the permeability-surface area product (PS), as illustrated in Fig. 1.

![Workflow](https://github.com/joseabernal/BrainDCEDRO/blob/master/Images/Worflow_generator.jpg)

Our digital reference object (DRO) used a high-resolution (480x350x480 matrix size; 0.5mm isotropic) human head model [3], containing both brain and non-brain regions; and white matter hyperintensities and lacunar stroke lesions that we added using spatial occurrence templates from patient data. We used pharmacokinetic parameters from a patient stroke cohort (n=201) [4] to assign realistic values to each tissue, generate 4D concentration-time curves using the Patlak model and, 4D signal-time curves corresponding to the 1.5-T imaging protocol described in [4]. For generating the signal in non-brain structures, a trained analyst manually sampled signal-time profiles from patient data, guided by an experienced neuroradiologist.
Imaging comprised modelling patient movement between frames using transformation matrices obtained from our cohort, truncating the k-space of each frame of the 4D signal to simulate the scanning resolution (0.94x0.94x4mm), adding additive white Gaussian noise (AWGN), and motion artefacts by creating composite k-spaces from consecutive head positions [5].
After generating the scanner-resolution DCE-MRI, we realigned all frames, computed concentration-time curves, and performed linear regressions to estimate the Patlak pharmacokinetic parameters. We compared the resulting PS maps with the input values and in-vivo data to assess the impact of artefacts and validate our framework.

## Results
These experiments represent a demonstration of the proposed DRO framework. In Fig. 2, we provide visuals of PS maps when affected by truncation, AWGN, bulk motion, and motion artefacts progressively. K-space sampling led to oscillations in the PS maps and negative values around ringing artefacts and blood vessels. The AWGN propagated from the signal-time curves to the PS maps and, occasionally, resulted in negative values. Bulk motion, followed by truncation and noise, produced noticeable deviations in all brain regions, presumably since ringing artefacts varied from one frame to another. Motion artefacts propagated from the signal-time curves to the PS maps and led to overestimated permeability values around them.

![Results](https://github.com/joseabernal/BrainDCEDRO/blob/master/Images/illustrationssimulations.jpg)

## Conclusions
We developed a tool for mimicking the DCE-MRI acquisition process to test and compare existing and future acquisition protocols and processing strategies. We simulated noise, truncation and motion to understand their repercussions in permeability mapping in the ageing brain. To our knowledge, this is the first time that spatiotemporal imaging artefacts have been simulated for this purpose.
Our findings show that AWGN, bulk motion, motion artefacts, and truncation artefact affect the appearance of PS parametric maps, leading to negative values around blood vessels (partial volume), and ringing artefacts. This work provides a means of understanding these hitherto-ignored influences on permeability mapping and a tool for developing new protocols and artefact reduction strategies.

## References
[1]	M. J. Thrippleton et al., “Quantifying blood-brain barrier leakage in small vessel disease: Review and consensus recommendations,” Alzheimer’s Dement., vol. 44, no. 6, pp. 1–19, 2019.

[2]	S. R. Barnes, T. S. C. Ng, A. Montagne, M. Law, B. V. Zlokovic, and R. E. Jacobs, “Optimal acquisition and modeling parameters for accurate assessment of low Ktrans blood-brain barrier permeability using dynamic contrast-enhanced MRI,” Magn. Reson. Med., vol. 75, no. 5, pp. 1967–1977, 2016.

[3]	M. I. Iacono et al., “MIDA: A multimodal imaging-based detailed anatomical model of the human head and neck,” PLoS One, vol. 10, no. 4, 2015.

[4]	A. K. Heye et al., “Tracer kinetic modelling for DCE-MRI quantification of subtle blood-brain barrier permeability,” Neuroimage, vol. 125, pp. 446–455, 2016.

[5]	R. Shaw, C. Sudre, S. Ourselin, and M. J. Cardoso, “MRI k-Space Motion Artefact Augmentation: Model Robustness and Task-Specific Uncertainty,” Int. Conf. Med. Imaging with Deep Learn., pp. 427–436, 2019.
