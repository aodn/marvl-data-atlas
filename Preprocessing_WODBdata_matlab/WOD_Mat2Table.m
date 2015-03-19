
% THIS SCRIPT PRINTS OUT A FILE CONTAINING CAST CORE METADATA INFO
clear all
inst = {'APB';'CTD';'OSD';'PFL';'UOR';'MBT';'XBT';'GLD';'GLD2';'SUR'}; 
PATH2FILE = pwd;
for ni = 1:length(inst)
    outputname = [char(inst{ni}) '.txt'];   
    fid=fopen(fullfile(PATH2FILE,outputname),'w');
    load(inst{ni});
    ndata = size(DATA,2);
    fprintf(fid,'SOURCE, CAST_ID,NODC_CRUISE_ID, ORIGINATOR_CRUISE_ID, ORIGINATOR_STATION_ID, LATITUDE,LONGITUDE,TIME,DATASET,DEPTH_MIN,DEPTH_MAX, TEMPERATURE_BOOL, SALINITY_BOOL \n');
    for nd = 1:ndata
% CONVERT DECIMAL TIME TO  STRING IN UTC
        m_minutes =  double(mod(time(nd),1)*60);
        s_seconds = double(round(mod(m_minutes,1)*60));
% USE DATETIME INSTEAD OF DATENUM  CAUSE OF PRECISION ISSUES 
        tt = datetime(double([year(nd) month(nd) day(nd) floor(time(nd)) floor(m_minutes) s_seconds]));      
        t =  datestr(tt,'yyyy-mm-ddTHH:MM:SSZ');
        fprintf(fid,'%s,%d,%s,%s,%s,%9.4f,%9.4f,%s,WOD2013,%d,%d,%d,%d\n',...
        char(inst{ni}),Cast{nd},NODC_ID{nd},originator_cruiseID{nd},originator_stationID{nd},lat(nd),lon(nd),t,min(DATA{nd}(:,2)),max(DATA{nd}(:,2)), any(cell2mat(strfind(var{1},'Temper'))),any(cell2mat(strfind(var{1},'Sali'))));
    end
    fclose(fid);
end

