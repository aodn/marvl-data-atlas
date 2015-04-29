
% THIS SCRIPT GENERATE THE OUTPUT DATAFILE. 
% IN ADDITION THE SCRIPT:
%  - STANDARDISES THE TABLE IN OUTPUT BY REORGANIZING THE PARAMETER COLUMN REGARDLESS OF THE NUMBER OF PARAMETER SAMPLED IN A CAST  
%  - REMOVES ALL THE QC FLAG COLUMNS IN ORDER TO SAVE SPACE.THE QC FLAGS ARE ALL SET TO 0.  
%  - CONVERTS OUTPUT TIME AS DATE INSTEAD OF JULIAN DAY FOR TRAJECTORY DATASET(GLD AND SUR) 
% 
% RUN THIS ROOUTINE AFTER WOD_CSV2MAT AND WOD_MAT2TABLE
clear all
inst = {'GLD';'GLD2';'SUR';'MBT';'XBT'};'APB';'CTD';'OSD';'PFL';'UOR'};
PATH2FILE = pwd;
for ni = 1: 1:length(inst)
    output_data_name = fullfile(PATH2FILE,'text_datafiles',[char(inst{ni}) '_data.txt']);
    load(inst{ni});
    ndata = size(DATA,2);

    fid = fopen(output_data_name,'w');
   
    for nd = 1:ndata
        nval = size(DATA{nd},1);nvar= size(DATA{nd},2);
% REMOVE FLAG VALUES FROM DATASET (THEY'RE ALL ZEROS)
       tempo_data = DATA{nd};
       
       if nval == 1 
          [ii,jj] = find(tempo_data==0);
           tempo_data(jj(2:end)) = [];
       else
           tempo_data(:,~any(tempo_data)) = [];
       end
       
% CREATE COLUMN OF CAST_ID VALUES
        C = ones(nval,1) * Cast{nd};
        
% CHECK PARAMETERS NAME IN ORDER TO POSITION EACH PARAMETER COLUMN AT RIGHT PLACE
        switch inst{ni}
            
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case {'APB','CTD','OSD','PFL','UOR'}
                if ismember('Temperatur',var{nd}) && ismember('Salinity',var{nd})
                    %NO MISSING VARIABLE
                    M = [C,tempo_data];

                elseif ismember('Temperatur',var{nd}) && ~ismember('Salinity',var{nd})
% SALINITY MISSING
% FILL UP THE MATRICE WITH COLUMN OF MISSING VALUE

                    M = ones(nval,5) * 999999;
                    M(:,1) = C;
                    M(:,2:4) = tempo_data ;

                 elseif ~ismember('Temperatur',var{nd}) && ismember('Salinity',var{nd})

  % TEMPERATURE MISSING
  % FILL UP THE MATRICE WITH COLUMN OF MISSING VALUE

                    M = ones(nval,5) * 999999;
                    M(:,1) = C;
                    M(:,2:3) = tempo_data(:,1:2);
                    M(:,5)   = tempo_data(:,3);
                elseif  ~ismember('Temperatur',var{nd}) && ~ismember('Salinity',var{nd}) 
                    disp(['warning :No Tor Sal values:',inst{ni},num2str(nd)])
                    clear M C tempo_data
                    continue
                    
                end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            case {'XBT','MBT'}
%TEMPERATURE IS THE ONLY MEASURED PARAMETER
                 M = [C,tempo_data];
                 if ~ismember('Temperatur',var{nd})
                     disp(['warning :No T values:',inst{ni},num2str(nd)])
                   
                     clear M C tempo_data
                     continue
                   
                 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                 case {'SUR'}
                       
% CREATE COLUMN OF CAST_ID VALUES
                     S = zeros(nval,1);
%ONLY SURFACE DATA. KEEP COLUMN DEPTH=0
                     if ismember('Temperatur',var{nd}) && ismember('Salinity',var{nd})
%NO MISSING VARIABLE
                        [yr, mth, d, hr, m, s] = jd2jdate(tempo_data(:,end));
                         yr = year(nd)*(yr./yr);
                        t = datestr(datetime(double([yr, mth,d,hr,m,s])),'yyyy-mm-ddTHH:MM:SSZ');
                        M = [C,tempo_data(:,1),S,tempo_data(:,2:end-1)];
                        
                    elseif ismember('Temperatur',var{nd}) && ~ismember('Salinity',var{nd})
% SALINITY MISSING
% FILL UP THE MATRICE WITH COLUMN OF MISSING VALUE

                        M = ones(nval,7)*999999;
                        M(:,1) = C;
                        M(:,2) = tempo_data(:,1);
                        M(:,3) = S;
                        M(:,4) = tempo_data(:,2) ;
                        M(:,6:7) = tempo_data(:,3:4) ;
                        [yr, mth, d, hr, m, s] = jd2jdate(tempo_data(:,end));
                        yr = year(nd)*(yr./yr);
                    t = datestr(datetime(double([yr, mth,d,hr,m,s])),'yyyy-mm-ddTHH:MM:SSZ');
                    elseif ~ismember('Temperatur',var{nd}) && ismember('Salinity',var{nd})

% TEMPERATURE MISSING
% FILL UP THE MATRICE WITH COLUMN OF MISSING VALUE

                        M = ones(nval,7)*999999;
                        M(:,1) = C;
                        M(:,2) = tempo_data(:,1);
                        M(:,3) = S;
                        M(:,5:7) = tempo_data(:,2:4) ;
                        [yr, mth, d, hr, m, s] = jd2jdate(tempo_data(:,end));
                          yr = year(nd)*(yr./yr);
                   t = datestr(datetime(double([yr, mth,d,hr,m,s])),'yyyy-mm-ddTHH:MM:SSZ');
                        
                    elseif  ~ismember('Temperatur',var{nd}) && ~ismember('Salinity',var{nd}) 
                        disp(['warning :No Tor Sal values:',inst{ni},num2str(nd)]) 
                         clear M C tempo_data 
                        continue
                     end  
                for nn= 1:nval
                    fprintf(fid,'%8.4f,%8.4f,%8.4f,%8.4f,%8.4f,%8.4f,%8.4f,%s\n',M(nval,1)',M(nval,2)',M(nval,3)',M(nval,4)',M(nval,5)',M(nval,6)',M(nval,7)',t(nval,:)');
                end
                
                    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
            case {'GLD','GLD2'}
               
%NEED EXTRA TEST CAUSE SOME CAST DON'T CONTAIN TRAJECTORY INFO(LAT,LON,TIME)
%USE METADATA INFO TO  FILL UP GAPS
 
                if ~ismember('Latitude',var{nd}) && ~ismember('JulianDay',var{nd}) && ~ismember('Temperatur',var{nd})
% LAT LON DATE AND TEMPERATURE ARE MISSING
                    
                    Lat = ones(nval,1) * lat(nd);
                    Lon = ones(nval,1) * lon(nd);
                    
                    m_minutes =  double(mod(time(nd),1)*60);
                    s_seconds = double(round(mod(m_minutes,1)*60));
                    tt =  datestr(datetime(double([year(nd) month(nd) day(nd) floor(time(nd)) floor(m_minutes) s_seconds])),'yyyy-mm-ddTHH:MM:SSZ');
                    t = repmat (tt,nval,1);    
                    M = ones(nval,8)*999999;
                    M(:,1) = C;
                    M(:,2:3) = tempo_data(:,1:2) ;
                    M(:,5) = tempo_data(:,3) ;
                    M(:,6) = Lat;
                    M(:,7) = Lon;
                    
                 elseif ~ismember('Latitude',var{nd}) && ~ismember('JulianDay',var{nd}) && ~ismember('Salinity',var{nd})
  % LAT LON DATE AND SALINITY ARE MISSING
                    
                    Lat = ones(nval,1) * lat(nd);
                    Lon = ones(nval,1) * lon(nd);
                    
                    m_minutes =  double(mod(time(nd),1)*60);
                    s_seconds = double(round(mod(m_minutes,1)*60));
                    tt =  datestr(datetime(double([year(nd) month(nd) day(nd) floor(time(nd)) floor(m_minutes) s_seconds])),'yyyy-mm-ddTHH:MM:SSZ');
                    t = repmat (tt,nval,1);    
                    M = ones(nval,7)*999999;
                    M(:,1) = C;
                    M(:,2:4) = tempo_data(:,1:3) ;          
                    M(:,6) = Lat;
                    M(:,7) = Lon;
                elseif ~ismember('Latitude',var{nd}) && ismember('Salinity',var{nd}) && ismember('Temperatur',var{nd})
                    

                    Lat = ones(nval,1) * lat(nd);
                    Lon = ones(nval,1) * lon(nd);
                    m_minutes =  double(mod(time(nd),1)*60);
                    s_seconds = double(round(mod(m_minutes,1)*60));
                    tt =  datestr(datetime(double([year(nd) month(nd) day(nd) floor(time(nd)) floor(m_minutes) s_seconds])),'yyyy-mm-ddTHH:MM:SSZ');
                    t = repmat (tt,nval,1); 
 
                    M = ones(nval,7)*999999;
                    M(:,1) = C;
                    M(:,2:5) = tempo_data(:,1:4) ;          
                    M(:,6) = Lat;
                    M(:,7) = Lon; 
                                       
                elseif ismember('Temperatur',var{nd}) && ismember('Salinity',var{nd}) && ismember('Latitude',var{nd})
%NO MISSING VARIABLE
                    
                     [yr, mth, d, hr, m, s] = jd2jdate(tempo_data(:,end));
                     yr = year(nd)*(yr./yr);
                     t = datestr(datetime(double([yr, mth,d,hr,m,s])),'yyyy-mm-ddTHH:MM:SSZ');
                     M = [C,tempo_data(:,1:end-1)];
                    
                    
                elseif ismember('Temperatur',var{nd}) && ~ismember('Salinity',var{nd})&& ismember('Latitude',var{nd})
  % SALINITY MISSING
  % FILL UP THE MATRICE WITH COLUMN OF MISSING VALUE

                    M = ones(nval,7)*999999;
                    M(:,1) = C;
                    M(:,2:4) = tempo_data(:,1:3) ;
                    M(:,6:7) = tempo_data(:,4:5) ;
                    
                    [yr, mth, d, hr, m, s] = jd2jdate(tempo_data(:,end));
                    yr = year(nd)*(yr./yr);
                    t = datestr(datetime(double([yr, mth,d,hr,m,s])),'yyyy-mm-ddTHH:MM:SSZ');
                    
                elseif ~ismember('Temperatur',var{nd}) && ismember('Salinity',var{nd})
                   
  % TEMPERATURE MISSING
  % FILL UP THE MATRICE WITH COLUMN OF MISSING VALUE
                    
                    M = ones(nval,7)*999999;
                    M(:,1) = C;
                    M(:,2:3) = tempo_data(:,1:2) ;
                    M(:,5:7) = tempo_data(:,3:5) ;
                
                    [yr, mth, d, hr, m, s] = jd2jdate(tempo_data(:,end));
                    yr = year(nd)*(yr./yr);
                    t = datestr(datetime(double([yr, mth,d,hr,m,s])),'yyyy-mm-ddTHH:MM:SSZ');
                    
               elseif  ~ismember('Temperatur',var{nd}) && ~ismember('Salinity',var{nd}) 
                    disp(['warning :No Tor Sal values:',inst{ni},num2str(nd)])  
                    
                    clear M C tempo_data
                    continue
                  
                end  
                      
                for nn= 1:nval
                    fprintf(fid,'%8.4f,%8.4f,%8.4f,%8.4f,%8.4f,%8.4f,%8.4f,%s\n',M(nval,1)',M(nval,2)',M(nval,3)',M(nval,4)',M(nval,5)',M(nval,6)',M(nval,7)',t(nval,:)');
                end
 
        end                           
     if ~ismember(inst{ni},{'SUR','GLD','GLD2'})
         dlmwrite(output_data_name,M,'-append','newline','unix','precision','%8.4f');
     end
   end
     clear M C tempo_data DATA var Cast
end 
fclose(fid);