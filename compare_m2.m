% Compare observed and model M2 amplitude and phase
% using the (harmonics.txt) file used with 
% David Flater's XTIDE program  (search for "xtide" on the web)

xtide_m2

% find only the Gulf of Maine data
ii=find(lon>-71.5000 & lon< -63.0000 & lat>  39.5000 & lat<  46.0000 & m2amp<4.5);

load gom60.mat xb yb zb
figure(1)
contour(xb,yb,zb,[-1000 -200 -100 -60 0]);dasp(43);
cdot(lon(ii),lat(ii),m2amp(ii),jet,20,1,[0 4]);
title('Observed M2 Tidal Amplitudes in the Gulf of Maine (m)');


a=load('adcirc_ec95d.mat'); 
zi=griddata(a.lon(1:a.ngood),a.lat(1:a.ngood),a.elev(1:a.ngood,5),...
      lon(ii),lat(ii));
clear a
zamp=abs(zi);
zpha=angle(zi)*180/pi;

a=load('quoddy_n97.mat'); 
zi=griddata(a.lon(1:a.ngood),a.lat(1:a.ngood),a.elev(1:a.ngood,2,1),...
      lon(ii),lat(ii));
clear a
zamp2=abs(zi);
zpha2=angle(zi)*180/pi;


axis('square');
% I don't understand how Xtide's phase info relates to the standard
% Greenwich phase.  So here I just take the mean difference in phase
% over the gulf and use that as the conversion to Greenwich phase

m2pha=m2pha-240;    % empirically convert Xtide phase to Greenwich 

ind=find(m2pha>180);
% 
m2pha(ind)=m2pha(ind)-360;

ind=find(zpha2>180);
zpha2(ind)=zpha2(ind)-360;

ind=find(zpha>180);
zpha(ind)=zpha(ind)-360;

figure(2)
contour(xb,yb,zb,[-1000 -200 -100 -60 0]);dasp(43);
cdot(lon(ii),lat(ii),m2pha(ii),jet,20,1,[-50 150]);
title('Observed M2 Tidal Phases in the Gulf of Maine (m)');

figure(3)
contour(xb,yb,zb,[-1000 -200 -100 -60 0]);dasp(43);
cdot(lon(ii),lat(ii),zpha,jet,20,1,[-50 150]);
title('ADCIRC M2 Tidal Phases in the Gulf of Maine (m)');

figure(4)
contour(xb,yb,zb,[-1000 -200 -100 -60 0]);dasp(43);
cdot(lon(ii),lat(ii),zpha2,jet,20,1,[-50 150]);
title('QUODDY M2 Tidal Phases in the Gulf of Maine (m)');

figure(5);
plot(m2amp(ii),zamp,'r.',m2amp(ii),zamp2,'b.');
xlabel('DATA');
ylabel('MODEL');legend('ADCIRC','QUODDY');
title('MODEL/DATA Comparison of M2 amplitude');
grid;

figure(6);
plot(m2pha(ii),zpha,'r.',m2pha(ii),zpha2,'b.');
xlabel('DATA');
ylabel('MODEL');legend('ADCIRC','QUODDY');
title('MODEL/DATA Comparison of M2 phase');
axis([-30 150 -30 150])
grid

figure(7)
contour(xb,yb,zb,[-1000 -200 -100 -60 0]);dasp(43);
cdot(lon(ii),lat(ii),zamp./m2amp(ii),jet,20,1,[.5 2]);
title('Ratio of Modeled/Data M2 elevation amplitude: ADCIRC');

figure(8)
contour(xb,yb,zb,[-1000 -200 -100 -60 0]);dasp(43);
cdot(lon(ii),lat(ii),zamp2./m2amp(ii),jet,20,1,[.5 2]);
title('Ratio of Modeled/Data M2 elevation amplitude: QUODDY');
