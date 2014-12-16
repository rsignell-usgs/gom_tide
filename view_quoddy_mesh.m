% VIEW_QUODDY_MESH
% view the mesh and bathymetry of the QUODDY model

load quoddy_n97.mat
trisurf(tri(1:ntri,:),lon(1:ngood),lat(1:ngood),-depth(1:ngood));
c=jet(128);
colormap(c(30:100,:));
view(2);colorbar

% set map aspect ratio 
lat=44;
xfac=cos(lat*pi/180);
set (gca, 'DataAspectRatio', [1 xfac 1] );
title(' QUODDY N97 Model Grid: From Christopher.E.Naimie@dartmouth.edu');
ylabel('Longitude');
xlabel('Latitude');
