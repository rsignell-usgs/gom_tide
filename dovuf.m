% load the boston harbor open boundary points
load \rps\bh\bh_obc.mat

% Find tidal amp & phase by interpolating consituents from ADCIRC 
% Z0, O1, K1, N2, M2, S2, M4, M6  (constituents 1:8)

[zamp,zpha]=adcirc_tide_interp_z(lon_obc,lat_obc,1:8);    % interpolate to OBC points

% start of model run
start=[2001 12 4 13 4 0];  % UTC time: yyyy, mm, da, hr, mi, sc

% get T_TIDE tidal constants
a=t_getconsts;
iconst=[1 13 21 42 48 57 82 106];   % Z0, O1, K1, N2, M2, S2, M4, M6
omega=2*pi.*a.freq(iconst);   %tidal frequencies in radians/hour


% find the V+U,F factors for these constituents
rlat=55.;
jdstart=datenum(start(1),start(2),start(3),start(4),start(5),start(6));
[v,u,f]=t_vuf(jdstart,iconst,rlat);

v=v*2*pi;  % convert v to phase in radians
u=u*2*pi;  % convert u to phase in radians

% Calculate the tide!

tide=zamp(:,1);   % start with the steady part

% add in all the other constituents 

jd=jdstart; % time after start 
thours=(jd-jdstart)*24;
ncon=length(iconst);
for i=2:ncon;
  tide=tide+f(i).*zamp(:,i).*cos(v(i)+thours(:)*omega(i)+u(i)-zpha(:,i)*pi/180);
end