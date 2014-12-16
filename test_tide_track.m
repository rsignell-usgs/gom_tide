% cape porpoise
lond=-70.2833;
latd=43.2167;
start=[2005 1 14 5 0 0];
stop=[2005 1 15 5 0 0];
jd=julian(start):1/48:julian(stop);
g=gregorian(jd);
nt=length(jd);
track=[g ones(nt,1)*lond ones(nt,1)*latd];
[zamp,zpha,freq]=quoddy_tide_interp_z(track(:,7),track(:,8),[1:2],2);
[z]=tide_track_z(track,zamp,zpha,freq);
timeplt(jd-5/24,(z-min(z))/.3048-.98);grid