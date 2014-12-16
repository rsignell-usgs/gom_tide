% Show predicted tidal currents and tide heights 
% along cruise track

N=1; W=-1;

track=[
   42 31.40 N    70 30.42 W   239.3    4.57
   42 29.07 N    70 35.75 W   187.2    4.68
   42 24.43 N    70 36.54 W   118.7   11.19
   42 19.06 N    70 23.25 W   191.2    6.09
   42 13.09 N    70 24.85 W   153.7    6.50
   42  7.26 N    70 20.97 W   126.8    3.41
   42  5.22 N    70 17.29 W   238.6    2.34
   42  4.00 N    70 19.98 W   303.4    3.56
   42  5.96 N    70 23.99 W   338.8   11.55
   42 16.73 N    70 29.63 W   312.2    9.20
   42 22.91 N    70 38.85 W   352.7    7.14
   42 29.99 N    70 40.08 W   269.3    2.45
   42 29.96 N    70 43.40 W   233.4    3.15
   42 28.08 N    70 46.83 W   141.7   17.83
   42 14.09 N    70 31.88 W   164.6   13.43
   42  1.14 N    70 27.06 W   105.6    7.91
   41 59.01 N    70 16.81 W   240.3    7.94
   41 55.08 N    70 26.08 W   161.1    1.45
   41 53.71 N    70 25.45 W    73.8    7.95
   41 55.93 N    70 15.19 W    31.5    4.17
   41 59.48 N    70 12.26 W    64.9    3.23
   42  0.85 N    70  8.33 W   177.2    3.66
   41 57.19 N    70  8.09 W   202.7    4.27
   41 53.25 N    70 10.30 W   227.1    7.01
   41 48.48 N    70 17.19 W   240.1    4.11
   41 46.43 N    70 21.97 W   283.6    2.38
   41 46.99 N    70 25.07 W   338.7   18.19
   42  3.93 N    70 33.96 W   357.2    5.90
   42  9.82 N    70 34.35 W   322.0    7.85
   42 16.00 N    70 40.88 W   314.2   10.28
   42 23.17 N    70 50.84 W   332.8    2.77
   42 25.63 N    70 52.55 W     0.0    0.00];

lon=(track(:,4)+track(:,5)/60).*track(:,6);
lat=(track(:,1)+track(:,2)/60).*track(:,3);

dnm=sw_dist(lat,lon,'nm');  %distance in nautical miles

% start time UTC for chain tow
jdn0=datenum(2001,6,24,18,0,0);
sspeed=5.2;  % speed in knots

% cumulative ship track distance
sumdn=[0; cumsum(dnm)];

% datenum for cruise track
jdn=jdn0+(sumdn./sspeed)/24;

% interpolate to every nautical mile along track
disti=[0:2:sumdn(end)];

loni=interp1(sumdn,lon,disti);
lati=interp1(sumdn,lat,disti);
jdi=interp1(sumdn,jdn,disti);


% ship track format: [yyyy mo da hr min sc lon lat]
track=[datevec(jdi) loni(:) lati(:)];


% calculate tide along ship track from ADCIRC
z=tide_track_z(track,'ADCIRC');

% calculate tidal vectors along ship track from QUODDY
w=tide_track_uv(track,'QUODDY');

velfac=1;

figure(1)
colordef white
m_proj('Mercator','long',[-71.1 -69.8],'lat',[41.6 42.8]);
load gom60.mat xb yb zb
[cx,h]=m_contour(xb,yb,zb,[-60 -40 -20],'b-');
m_usercoast('gom_h.mat','patch',[.9 .9 .9]);
m_grid('box','fancy','tickdir','out');
[hp,ht]=m_vec(velfac,loni,lati,real(w),imag(w));
ht=m_line(lon,lat,'color','red');
title('Tidal currents along ship track')

figure(2);
plot(jdi,z);datetick
title('Tidal elevations along ship track')
ylabel('m');
xlabel('time of day')
grid
