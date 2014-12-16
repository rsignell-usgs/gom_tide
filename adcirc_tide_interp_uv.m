function [uamp,upha,vamp,vpha,freq]=adcirc_tide_interp_uv(rlon,rlat,con_ids);
%
% ADCIRC_TIDE_INTERP_UV returns specified interpolated contituents from ADCIRC Run
%
%  Usage: [uamp,upha,vamp,vpha]=adcirc_tide_interp_uv(rlon,rlat,con_ids);
%      
%  Inputs:  rlon = longitude of desired locations
%           rlat = latitude of desired locations
%           con_ids = vector if tidal contituent ids
%                     id:      1    2    3    4    5    6    7    8
%                     name:   Z0   O1   K1   N2   M2   S2   M4   M6
%                   
%  Outputs: uamp,vamp = u and v tidal current amplitudes 
%           upha,vpha = u and v tidal current phases (in degrees)
load('adcirc_ec95d.mat');
ncon=length(freq);   % ncon better be 8 !
ui=zeros(length(rlon),ncon);
vi=zeros(length(rlon),ncon);
for i=con_ids;
  ui(:,i)=triterp(tri,lon,lat,u(:,i),rlon,rlat);
  vi(:,i)=triterp(tri,lon,lat,v(:,i),rlon,rlat);
end
upha=angle(ui)*180/pi;   %phase in radians
uamp=abs(ui);
vpha=angle(vi)*180/pi;   %phase in radians
vamp=abs(vi);
