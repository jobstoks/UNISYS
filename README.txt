# UNISYS
Universal Ventricular Bullseye Visualization: open-source MATLAB algorithms to visualize single-layer ventricular data in a standardized bullseye plot. Can be used for one or both ventricles.

Main script to use: UNISYS_Main.m. This script prepares your data for plotting and calls all other scripts, among which the most important one is plot_BulsEye_And_Hearts.m.
See UNISYS_Main.m and plot_BulsEye_And_Hearts.m for documentation.

Other scripts and files:
- Bullseye_define_base.m: define the basal nodes by clicking three times. These nodes will not be shown in UNISYS visualization.
- cmap_uyen.mat: colormap as used in Durrer 1976. 
- uyen_colourmap.m: create cmap_uyen.mat.
- define_XY_grid_dense.m: defines the circular grid to plot data on (default in UNISYS=100*360).
- durrermap.m: Define a colormap as used in Durrer 1976.
- IsoLine.m: plot isolines on heart in between different colors.
- make_axis.m: define the septum and translate and rotate the ventricles in an upright position.
- subtightplot.m: custom subplots with less space in between them than the default matlab subplot.

- UNISYS_Logo.png: logo.
