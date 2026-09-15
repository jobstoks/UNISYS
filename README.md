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

# Standardized 2D Torso and Ventricle Maps (S-TVMs)
Transform subject-specific 3D torso and ventricle geometries into standardized 2D/3D representations.

Main script to use: ventricle_2D3D.m. generate 2D (bullseye for whole ventircle, full square plot)and 3D bowl-shaped representation.
                    torso_2D3D.m. generate full square plot and elliptical cylinder representation.

Other scripts:
- rotate_xyz1.m: achieve standardized position and orientation for torso
- newindex.m: generate new vertices and faces based on new indices
- krigingWeights.m: compute the kridging weights
- krigingInterpolation.m: kriging interpolation based on the kriging weights
- fun_x1.m, fun_y1.m, fun_zx.m: used in rotate_xyz1.m
- findOpeningTrodeSaveFaces.m: find the opening line for the torso, generate the coordinates for unfolded torso surface.
- boundaryVerticesAndallLines.m: generate the lines and boundary based on faces
- boundaryOrder.m: generate the ordered boundary lines and vertices

- The S-TVMs tool is available a https://112.124.26.17:7013/visual2D3D
