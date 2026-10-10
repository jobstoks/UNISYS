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

Main script to use
- ventricle_2D3D.m: generate 2D (bullseye for whole ventircle, full square plot)and 3D bowl-shaped representation.
- torso_2D3D.m: generate full square plot and elliptical cylinder representation.
- ventricle_2D3D_sensitivity.m: generate new standardized ventricles via Monte Carlo perturbation of all four landmarks.

Other scripts:
- rotate_xyz1.m: achieve standardized position and orientation for torso
- newindex.m: generate new vertices and faces based on new indices
- krigingWeights.m: compute the kridging weights
- krigingInterpolation.m: kriging interpolation based on the kriging weights
- TSP3D: thin plate spline interpolation
- fun_x1.m, fun_y1.m, fun_zx.m: used in rotate_xyz1.m
- findOpeningTrodeSaveFaces.m: find the opening line for the torso, generate the coordinates for unfolded torso surface.
- boundaryVerticesAndallLines.m: generate the lines and boundary based on faces
- boundaryOrder.m: generate the ordered boundary lines and vertices
- anticlock.m: checks whether a polygon's vertices are ordered counter-clockwise or clockwise and returns 1 or 2
- area_defined.m: compute the triangle area
- newB.m: redistributes a set of vertices along a specific axis based on their relative distances
- perturb_ventricle_landmarks.m: randomly resamples ventricle landmarks within a physical distance radius
- TEM.m: tutte embedding method process 
- results.jpg: visualization of 2D/3D torso and ventricle generated using the data from the following Quickstart


- The S-TVMs tool is available a https://112.124.26.17:7013/visual2D3D

# Quickstart (S-TVMs)
## step 1: Data Preparation

Download the dog torso and ventricle dataset from the EDGAR database:

https://edgar.sci.utah.edu/2025/07/09/dog-torso-and-epicardial-recordings-w-pacing-maastricht-15-09-06/

Save the downloaded data to your MATLAB working directory before running the script.


## step 2: Construct and save the GeomBeats structure

GeomBeats=struct;

GeomBeats.geom.Heart.vertices = hart.node;

GeomBeats.geom.Heart.faces = hart.face;

GeomBeats.beats.potsTikhonov = hartpots;

GeomBeats.geom.Body.vertices = lichaam.node;

GeomBeats.geom.Body.faces =  lichaam.face;

GeomBeats.beats.bodyPots = lichaampots;

save(mypath,'GeomBeats')


## Step 3: Generate 2D/3D ventricle representation

ventricle_2D3D(mypath,1,50,[540, 790,1139,873], 'potsTikhonov',jet)


## Step 4: Generate 2D/3D torso representation

torso_2D3D(mypath, 1,50,[122,12,81,132],'kriging',60,60,70)


## Step 3: Generate new ventricle representations based on perturbed landmarks

ventricle_2D3D_sensitivity(mypath,1,50,[540, 790,1139,873], 'potsTikhonov',1,20)
