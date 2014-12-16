%view_m2
load adcirc_ec95d
var=abs(elev(1:ngood,5));  %m2 amp
trisurf(tri(1:ntri,:),lon(1:ngood),lat(1:ngood),var);...
   view(2);shading flat;dasp(43);colorbar

