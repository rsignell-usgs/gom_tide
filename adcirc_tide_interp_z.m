function [zamp,zpha,freq,names]=adcirc_tide_interp_z(rlon,rlat,con_ids);
%
% ADCIRC_TIDE_INTERP_Z returns specified interpolated contituents 
%      from the ADCIRC ec95d Run
%
%  Usage: [zamp,zpha,freq,names]=adcirc_tide_interp_z(rlon,rlat,con_ids);
%      
%  Inputs:  rlon = longitude of desired locations
%           rlat = latitude of desired locations
%           con_ids = vector if tidal contituent ids
%                     id:      1    2    3    4    5    6    7    8
%                     name:   Z0   O1   K1   N2   M2   S2   M4   M6
%                   
%  Outputs: zamp,zpha = elevation amplitudes and phases
adc=load('adcirc_ec95d.mat');
rlon=rlon(:);
rlat=rlat(:);
ncon=length(adc.freq);   % ncon better be 8 !
zi=zeros(length(rlon),ncon);
for i=con_ids;
  zi(:,i)=triterp(adc.tri,adc.lon,adc.lat,adc.elev(:,i),rlon,rlat);
end
zpha=angle(zi)*180/pi;   %phase in radians
zamp=abs(zi);
freq=adc.freq;
names=adc.names;
