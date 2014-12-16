function [z,lon,lat,jd]=tide_track(track)
% TIDE_TRACK  interpolates tide from ADCIRC model onto shiptrack
% to find the tidal constituents along the shiptrack, and then
% calculate the tidal elevations along the shiptrack.

% Rich Signell  December 6, 2000

% Step 1. Load shiptrack ASCII file with 8 columns:
%              Gregorian time 
%              yyyy,  mo, da, hr, mi, sc, lat, lon 

%load track.ll

%Example:  (2 point shiptrack file)
%track=[ 2000 11 1 0 0 0  -73.8333  40.4667     % ambrose
%        2000 11 2 0 0 0  -74.0167  40.4667];  % sandyhook

[npoints,ncols]=size(track);

g=track(:,[1:6]);
jd=julian(g);   % signell's julian day notation
lon=track(:,7);
lat=track(:,8);

start_year=g(1,1);
start_month=g(1,2);
start_day=g(1,3);
jd_start=julian([start_year start_month start_day 0 0 0]);

% interpolate complex tidal coefficients from ADCIRC to 
% find tidal coefficients at locations along the cruise track

adcirc=load('adcirc_ec95d.mat');  
freq=adcirc.freq;
ncon=length(freq);
for icon=1:ncon,
  ei(:,icon)=triterp(adcirc.tri,adcirc.lon,adcirc.lat,adcirc.elev(:,icon),lon,lat);
end

% convert complex interpolated constituents back to amplitude and phase

pha=angle(ei);   %phase in radians
amp=abs(ei);   

% Calculate V,U,F arguments.  These are the astronomical offsets
% that allow you to go from  amplitude and Greenwich phase to 
% real tidal predictions for a certain time period.  See the
% T_TIDE toolkit and the T_VUF.M program for more info.
a=t_getconsts;
iconst=      [1 13 21 42 48 57 82 106];   % Z0, O1, K1, N2, M2, S2, M4, M6
periods=1./a.freq(iconst);    %periods in hours
omega=2*pi./periods;   %tidal frequencies in radians/hour
rlat=55;  %reference latitude for 3rd order satellites (degrees)
[v,u,f]=t_vuf(datenum(start_year,start_month,start_day),iconst,rlat);
v=v*2*pi;  % convert v to phase in radians
u=u*2*pi;  % convert u to phase in radians


% Calculate the tide!

z=amp(:,1);   % start with the steady part

% add in all the other constituents 

thours=(jd-jd_start)*24;
for i=2:ncon;
    z=z+f(i).*amp(:,i).*cos(v(i)+thours(:)*omega(i)+u(i)-pha(:,i));
end
