% Extract the M2 data from XTIDE's harmonics.txt file

% Step 1. extract the M2 component info from harmonics.txt (this program)
% Step 2. edit the resulting file to make it a matlab script.  See the
%         example file "xtide_m2.m" to see what you want to end up with

fid=fopen('harmonics.txt');
fid2=fopen('m2.txt','w');

while 1
  c=fgetl(fid);
  if ~ischar(c),break,end
  if ~isempty(findstr(c,'!units:'))
      fprintf(fid2,'%s\n',c);
  end
  if ~isempty(findstr(c,'!longitude:'));
      fprintf(fid2,'%s\n',c);
  end
  if ~isempty(findstr(c,'!latitude:'));
      fprintf(fid2,'%s\n',c);
  end
  a=findstr(c,'M2 ');
  if ~isempty(a),
     if (a==1),
       fprintf(fid2,'%s\n',c);
     end
  end
end
fclose(fid)
fclose(fid2);
