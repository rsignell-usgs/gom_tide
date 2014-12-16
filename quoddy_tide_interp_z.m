function [zamp,zpha,freq]=...
              quoddy_tide_interp_z(rlon,rlat,con_ids,bimonth);
%
% QUODDY_TIDE_INTERP_Z returns specified interpolated 
%                       contituents from Quoddy Run
%
% function [zamp,zpha]=quoddy_tide_interp_z(rlon,rlat,con_ids,bimonth);
%  Usage: [zamp,zpha]=quoddy_tide_interp_z(rlon,rlat,con_ids);
%      
%  Inputs:  rlon = longitudes of user locations
%           rlat = latitudes of user locations
%           con_ids = index vector of tidal contituents
%                     id:      1    2    3    4    5    6    7    8
%                     name:   Z0   O1   K1   N2   M2   S2   M4   M6
%           bimonth = index of bimonthly period to use:
%                  index:    1       2       3       4      5       6
%                   name: Jan-Feb Mar-Apr May-Jun Jul-Aug Sep-Oct Nov-Dec
%
%  Outputs: zamp,zamp = z amplitude and phase

if(nargin==3),
  bimonth=1;   % default to Jan-Feb if bimonthly period not specified
end
load('quoddy_n97.mat');


% There are only two contituents in our Quoddy file:
% residual and M2.  So if the user asks for consituent
% 1, 5 or constituents 1 and 5, everything is fine.  If they ask for
% anything else, the routine bombs.  A feature!  Better than
% giving misleasing predictions!

% mapping from contituent number requested ==>  index in .mat file
ifreq=[1 0 0 0 2 0 0 0];  % Constituent 5 is the 2nd index in the .mat file 

% load 8 adcirc frequencies since we forced to use these here
load adcirc_ec95d.mat freq
ncon=length(freq);
zi=zeros(length(rlon),ncon);
for i=con_ids;
  zi(:,i)=triterp(tri,lon,lat,elev(:,ifreq(i),bimonth),rlon,rlat);
end
zpha=angle(zi)*180/pi;   %phase in degrees
zamp=abs(zi);
