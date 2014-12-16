   toffset=4;   % EDT + 4 = UTC
   load ltms_tide
   local=now-6/24+[0:.25:24]/24;   % start 6 hours before now, go for 24 hours
   utc=local+toffset/24;
   pout=t_predic(utc,name,fr,tidecon,lat);
   pout=pout/100;  % m (actually decibars)
   plot(local,pout);
   datetick
   grid
   znow=interp1(local,pout,now);line(now,znow,'marker','o','color','red');
   ylabel('m');
   title('Current Tide Level in Boston');
