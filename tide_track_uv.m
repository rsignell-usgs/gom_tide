function [w]=tide_track_uv(track,uamp,upha,vamp,vpha,freq);
% TIDE_TRACK_UV determines tidal currents along tracklines
% defined by rows containing time,lon and lat.   Uses the
% ADCIRC model by default 
%
% Usage: w = tide_track_uv(track,uamp,upha,vamp,vpha,freq)
%          or
%        w = tide_track_uv(track)
%          or
%        w = tide_track_uv(track,'QUODDY')  ;% to use QUODDY instead
%  
%    Input: track = matrix with (time, lon, lat) in 8 columns: 
%             [yyyy mo da hr mi sc lon lat]  % West + South negative
%
%           [uamp,upha,vamp,vpha,freq] = returned from tide_interp
%    Output: 
%           w = tidal velocity (u + i* v)
%
% Example: Calculate the tidal currents at the 
%          NOAA Met buoy 44007 at  4-May-2001 10:45 UTC
%     and  NOAA Met Buoy 44005 at 20-Jun-2003 21:15 UTC
%     
%    track=[2001 5  4 10 45 0 -70.14 43.53      % 44007 Portland
%           2003 6 20 21 15 0 -66.58 41.09] ;   % 44005 Gulf of Maine
%
%        w=tide_track_uv(track);   % predict tidal currents

% Rich Signell  (rsignell@usgs.gov) June 14, 2001

% Step 1. Load shiptrack ASCII file with 9 columns:
%              Gregorian time 
%         [ yyyy,  mo, da, hr, mi, sc, lon,lat]

%Example:  (2 point shiptrack file)

lon=track(:,7);
lat=track(:,8);
g=track(:,[1:6]);

jd=datenum(g(:,1),g(:,2),g(:,3),g(:,4),g(:,5),g(:,6));

% if only track is given, calculate constituents 
if(nargin<3),
  if (nargin==1),
    tidal_model='ADCIRC';
  else
    tidal_model=uamp;
  end
  if strcmp(tidal_model,'QUODDY'),
    con_ids=[1 5];
    bimonth=ceil(mean(g(:,2))/2);
    [uamp,upha,vamp,vpha,freq]=...
        quoddy_tide_interp_uv(lon,lat,con_ids,bimonth);
  else
    con_ids=[1:8];
    [uamp,upha,vamp,vpha,freq]=...
       adcirc_tide_interp_uv(lon,lat,con_ids);
  end
end  

[npoints,ncols]=size(track);

start_year=g(1,1);
start_month=g(1,2);
start_day=g(1,3);
jd_start=datenum(start_year, start_month, start_day);

% Calculate V,U,F arguments using Rich P's T_Tide.  
% These are the astronomical offsets
% that allow you to go from  amplitude and Greenwich phase to 
% real tidal predictions for a certain time period.  See the
% T_TIDE toolkit and the T_VUF.M program for more info.

a=t_getconsts;
iconst=[1 13 21 42 48 57 82 106];   % Z0, O1, K1, N2, M2, S2, M4, M6
omega=2*pi*a.freq(iconst);
rlat=55;  %reference latitude for 3rd order satellites (degrees)
[v,u,f]=t_vuf(jd_start,iconst,rlat);
v=v*2*pi;  % convert v to phase in radians
u=u*2*pi;  % convert u to phase in radians


% Calculate the tide!

U=uamp(:,1);   % start with the steady part
V=vamp(:,1);   % start with the steady part

% add in all the other constituents 

thours=(jd-jd_start)*24;
ncon=length(freq);
for i=2:ncon;
   U=U+f(i).*uamp(:,i).*cos(v(i)+thours(:)*omega(i)+u(i)-upha(:,i)*pi/180);
   V=V+f(i).*vamp(:,i).*cos(v(i)+thours(:)*omega(i)+u(i)-vpha(:,i)*pi/180);
end
w=U+sqrt(-1)*V;
