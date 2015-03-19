% SCRIPT READS IN METADARA FROM WODB CSV OUTPUT FILE AND GENERATE A MAT FILE
% THE WODB CSV  FILENAME IS HARD CODED BELOW
% CODE BUGS WHEN IF LAST DEPLOYMENT OF A FILE HAS NO DATA: NEED TO RUN MANUALLY 

PATH2FILE = pwd;
inst ={'GLD';'APB';'GLD';'GLD2';'OSD';'PFL';'UOR';'MBT';'XBT'};
for ninst = 1 : length(inst)
    file =fullfile(PATH2FILE,['ocldb1421376410.6251.',char(inst{ninst}),'.csv']);
    fid = fopen(file); 
    k = 1; iter= 0;
    while ~feof(fid)
    fline = fgetl(fid);
        while fline(1)== '#' 
           iter =iter +1 ; %CAST COUNTER
           fline = fgetl(fid);
           j = 0;m = 0; % MISCELLENEOUS COUNTER
           while fline(1) ~= '#' && (~strcmp(fline(1:8),'METADATA')) 

               switch fline(1:3)
                        case {'CAS'} 
                             fsplitline = strtrim(strsplit(fline,','));
                             Cast{iter} = single(str2num(char(fsplitline(2))));              
                        case {'Lat'}
                            fsplitline = strtrim(strsplit(fline,','));
                             lat(iter) = single(str2num(char(fsplitline(2))));     
                        case {'Lon'}
                            fsplitline = strtrim(strsplit(fline,','));
                             lon(iter) = single(str2num(char(fsplitline(2))));
                        case {'Yea'}
                            fsplitline =strtrim(strsplit(fline,','));
                            if m==0
                              year(iter) = single(str2num(char(fsplitline(2))));
                              m = m+1;
                            end
                        case {'Mon'}
                            fsplitline = strtrim(strsplit(fline,','));
                             month(iter) = single(str2num(char(fsplitline(2))));
                        case {'Day'}
                            fsplitline = strtrim(strsplit(fline,','));
                            day(iter) = single(str2num(char(fsplitline(2))));
                        case{'Tim'}
                            fsplitline = strtrim(strsplit(fline,','));
                            time(iter) = single(str2num(char(fsplitline(2))));
                           
                        case {'NOD'}
                             fsplitline = strtrim(strsplit(fline,','));
                              NODC_ID{iter} = char(fsplitline(2));    
                        case {'Ori'}
                             fsplitline = strtrim(strsplit(fline,','));
                             if j==0
                                 originator_stationID{iter} =char(fsplitline(2)); 
                                   j = j+1;
                             elseif j==1
                                 originator_cruiseID{iter} = char(fsplitline(2)); 
                             end                   
                             
               end
                fline = fgetl(fid);
           end
           n=0;
          while fline(1) ~= '#' && (~strcmp(fline(1:9),'Prof-Flag'))        
                 n = n+1;
                fsplitline = strtrim(strsplit(fline,','));
                var{iter} = fsplitline(:); 
                Metadata{iter,n} = fsplitline(:);
                fline = fgetl(fid); 
          end
            i = 0;
          while fline(1) ~= '#' && (~strcmp(fline(1:3),'END')) %READING DATA NOW
              fline = fgetl(fid); 
              i = i+1;%               
           end
         end
    end
   fclose(fid); 
   outputMetadata = [char(inst{ninst}) '_metadata_1.mat'];

   save(outputMetadata,'file','Cast','Metadata');
       
%    clear Cast DATA time day month year lat lon NODC_ID originator_cruiseID originator_stationID var Metadata
end

% WOD_Mat2Table