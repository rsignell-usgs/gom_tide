% VIEW_ADCIRC_MESH
% view the mesh and bathymetry of the ADCIRC model

load adcirc_ec95d.mat
trisurf(tri(1:ntri,:),lon(1:ngood),lat(1:ngood),-depth(1:ngood));
c=jet(128);
colormap(c(30:100,:));
view(2);colorbar

% set map aspect ratio 
lat=30;
xfac=cos(lat*pi/180);
set (gca, 'DataAspectRatio', [1 xfac 1] );
title(' EC95b ADCIRC Model Grid: From Rick.Luettich@unc.edu') ;
ylabel('Longitude');
xlabel('Latitude');
