function [wi,xi,yi]=gom_tide_vec(time_utc,tidal_model) 
% GOM_TIDE_VEC function to plot the predicted tidal currents
% in the Gulf of Maine at a specified time.
%
% Usage: [wtide,xi,yi]=gom_tide_vec([time_utc],[tidal_model]);
%  Example   gom_tide_vec;  % plots the tide right now 
%       Outputs: xi = matrix of longitudes (decimal degrees, W-)
%                yi = matrix of latitudes  (decimal degrees, S-)
%                wi = predicted tide at the (xi,yi) points 
%                     (complex: u+i*v)   (m/s)
%
%       Inputs:  time_utc = a single time value.  Time must be in an
%                   an acceptable format for DATENUM (e.g. 
%                   '01-Mar-2000 15:45:17' or [2000 3 1 15 45 17]).
%                    [Defaults to the current time as determined by 
%                    the Matlab "now" command + 4 hours, assuming that
%                    the computer is in Eastern Daylight Time]
%
%                tidal_model = 'QUODDY' (default) or 'ADCIRC'
%
%                   QUODDY is the N97 model from Chris Naimie
%                   (Christopher.E.Naimie@dartmouth.edu), updated version 
%                   of model described in:  "Naimie, C.E., J.W. Loder, and 
%                   D.R. Lynch. 1994. Seasonal variation of the three-dimensional 
%                   residual circulation on Georges Bank. J. Geophys. Res., 99, 
%                   15967-15989."    Two components (Z0, M2) for each of six bimonthly
%                   periods for the Gulf of Maine and Scotian Shelf.
%
%                   ADCIRC is the ec95b model from Rick Luettich
%                   (Rick_Luettich@unc.edu), the basic model is described
%                   in "Grenier, R. R., Jr., R. A. Luettich, Jr., and J. J. Westerink, 
%                   A comparison of the frictional characteristics of two-dimensional 
%                   and three-dimensional tidal models, Journal of Geophysical Research,
%                   100(C), 13,719-13,735, 1995."  Eight components 
%                   (Z0, O1, K1, N2, M2, S2, M4, M6) for the entire East and Gulf coasts  

% At each track point (lon,lat point) the depth-averaged U and V
% tidal constituents are interpolated from either
% 1) ADCIRC (8 consituents, covers entire East & Gulf Coast)
% 2) QUODDY (M2 only + tide-induced residual only, Gulf of Maine)
% then evaluated at the dates and times provided to predict
% the tidal currents.  Specify the points where we want to 
% predict the tidal currents.

% Rich Signell

toffset=4;  % offset from GMT:  EDT = GMT-4
toffstr='EDT';
velfac=2;   % velocity scale factor (2 m/s = 1 deg lat)
vsub=3;     % subsampling of arrows for display
cmin=0;   % min limit on plot for tidal speed (m/s)
cmax=1.0; % max limit on plot for tidal speed (m/s)

if (nargin<2), 
  tidal_model='ADCIRC';   
  %tidal_model='QUODDY';   %default if unspecified is QUODDY
end
tidal_model=upper(tidal_model);
if (nargin<1),
  utc=datenum(now)+toffset/24;  % assume that NOW is in EDT  
else
  utc=datenum(time_utc);
end
if (nargin==2),
  if  ~strcmp(tidal_model,'QUODDY') & ~strcmp(tidal_model,'ADCIRC'),
     disp('Please specify model as either ''quoddy'' or ''adcirc''');
     return
  end
end
% here I load a grid of predefined points that gives
% the kind of resolution I want in the Gulf of Maine
% and is arranged in a grid so I can use m_contourf, 
% but you could use anything really...

load my_gom_points.mat xi yi mask

[m2,n2]=size(mask);
igood=find(mask==1);

% initialize tide array to be same size as input grid
wtide=xi*nan;

g=datevec(utc);
nt=length(igood(:));

% define a track containing time, lon and lat information 
% in 8 columns:
% 
%       YYYY MM DA HR MI SC       LON     LAT
% e.g. [1998 12  4 23 15  0  -70.5143 43.1243]
%   
%   
track=[ones(nt,1)*g xi(igood) yi(igood)];

switch tidal_model

case {'QUODDY'}
  bimonth=ceil(g(2)/2);   % use the appropriate bimonthly period  
  con_ids=[1 5]; % use Z0 (mean) and M2 for prediction 
                 % (only Z0 & M2 are available!)
  [uamp,upha,vamp,vpha,freq]=...
       quoddy_tide_interp_uv(xi(igood),yi(igood),con_ids,bimonth);

case {'ADCIRC'}
  con_ids=[1:8]; % use Z0, O1, K1, N2, M2, S2, M4, M6 
  [uamp,upha,vamp,vpha,freq]=...
        adcirc_tide_interp_uv(xi(igood),yi(igood),con_ids);
otherwise
  disp('Unknown tidal model');return
end

% Calculate the tide at the specified times 
% (or on the grid of points, in this case)

wi=tide_track_uv(track,uamp,upha,vamp,vpha,freq);

wtide(igood)=wi;

clf

% Set up m_map
set(gcf,'color','white');
set(gcf,'pos',[10 10 670 670]);
m_proj('UTM','long',[-71.5 -64],'lat',[40.0 46]);

% Color contour fill the tidal speed

m_contourf(xi,yi,abs(wtide),[0:.1:1]);
caxis([cmin cmax]);
hold on

% Take the heart out of jet

c=jet(128);
colormap(c(30:90,:));

% Draw a few bathymetry lines using m_contour

load gom60 xb yb zb 
[cx,h]=m_contour(xb,yb,zb,[-200 -100 -60],'k-');
set(h,'color',[.7 .7 .7],'linewidth',2);

% Subsample them arrows!

xp=xi(1:vsub:end); yp=yi(1:vsub:end); wp=wtide(1:vsub:end);
ind=find(~isnan(wp));

% Plot up the arrows!
[hp,ht]=m_vec(velfac,xp(ind),yp(ind),real(wp(ind)),imag(wp(ind)));


% Draw a filled coast

m_usercoast('gom_coast_i.mat','patch',[.9 .9 .9]);

% Tell what time it is
time_text{1}=['  ' toffstr ': '  datestr(utc-4/24)];
time_text{2}=['  UTC: '  datestr(utc)];
m_text(-71,45.2,time_text,'fontweight','bold','fontsize',12);


% The title
title(['Depth-Averaged Tidal Currents from ' tidal_model],...
 'fontweight','bold','fontsize',12);

% Put a nice grid on
m_grid('box','fancy','tickdir','out');
set(findobj('tag','m_grid_color'),'facecolor','none');

% Put on a small colorbar
pclegend([cmin cmax],[.17 .70 .2 .03],gcf,'m/s')

hold off
