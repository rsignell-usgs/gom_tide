% This directory contains routines for plotting tidal model results
% in the Gulf of Maine, interpolating tidal model elevations or
% velocities to shiptracks, predicting the tide in the Gulf of Maine
% and more.
%
% Rich Signell  (signell@saclantc.nato.int, rsignell@usgs.gov, rsignell@umich.edu)
%
% 25-Jun-2001
%
% Demo:
% tide_demo		        
% 
% Main Routines:
%
% tide_track_z		Simulated tide heights along a shiptrack 
% tide_track_uv 	Find simulated tidal currents along a shiptrack 
% gom_tide_z     	Plots simulated tidal elevations in the Gulf of Maine
% gom_tide_uv		Plots simulated tidal currents in the Gulf of Maine
% 
% Auxiliary Routines: 
%
% view_adcirc_mesh		View the ADCIRC tidal model mesh
% view_quoddy_mesh 		View the QUODDY tidal model mesh
% adcirc_tide_interp_uv	Interpolate U,V tide constituents from ADCIRC
% adcirc_tide_interp_z	Interpolate tide constituents from ADCIRC
% quoddy_tide_interp_uv Interpolate U,V tide constituents from QUODDY
% quoddy_tide_interp_z	Interpolate tide constituents from QUODDY 
%
% Data Files:
%
% adcirc_ec95d.mat	8 Constituents from ADCIRC (East and Gulf Coast)
% gom60.mat		Coarse resolution (1 minute) Gulf of Maine Bathy
% quoddy_n97.mat	2 Constituents from 6 bimonthly periods from QUODDY
% my_gom_points.mat	Points to interpolate onto for nice looking map
%
% harmonics.txt  	Harmonic constants for XTIDE, obtained 24-Jun-2001
