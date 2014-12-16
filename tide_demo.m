% Tide Demo
% add paths to required toolboxes

%addpath tri
%addpath t_tide
%addpath m_map

% Demo 1: Plot Tidal Vectors from Quoddy at a Specified Time
clf;

disp('Calculating Tidal Vectors predicted by QUODDY.');
disp('Please wait...');
[wtide,xi,yi]=gom_tide_uv('25-Jun-2001 09:14:29','QUODDY');
disp('Hit <return> to continue');
pause

% Demo 2: Plot Tidal Elevations from ADCIRC at a Specified Time
clf;
disp('Tidal Elevations predicted by ADCIRC.');
disp('Please wait...');
 [tide,xi,yi]=gom_tide_z([2001 6 25 0 14 0],'ADCIRC');
disp('Hit <return> to continue');
pause

% Demo 3: Plot the Quoddy Finite Element Grid
clf;
disp('Plotting Quoddy Finite Element Grid...');
view_quoddy_mesh
disp('Hit <return> to continue');
pause; 

% Demo 4: Plot the ADCIRC Finite Element Grid
clf;
disp('Plotting ADCIRC Finite Element Grid...');
view_adcirc_mesh
disp('Hit <return> to continue');
pause

% Demo 5: Find Tidal Velocities and Tide Heights along ship track
clf;disp('Plotting Tidal Velocities and Tide Heights along track ...');
do_track15
disp('Hit <return> to continue');
pause

% Demo 6: Predicting Tide Heights at Boston
clf;disp('Plotting Tide Heights at Boston...');
bostide
