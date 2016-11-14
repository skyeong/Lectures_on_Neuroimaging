DATApath = '/Volumes/JetDrive/workshops/Matlab/lecture1/data';

% Load Subject List
fn_subjlist = fullfile(DATApath,'subjlist_eprime.xlsx');
[a,b,xlsData] = xlsread(fn_subjlist);
subjlist = xlsData(2:end,1);
nsubj = length(subjlist);  % count the cell element in 'subject' variable

% Calculate average RT for each subject and condition
RT = struct();

for c=1:nsubj,
    
    subjname = subjlist{c};
    fprintf('analyzing data for %s.\n',subjname);
    
    % Load Eprime data for each subject
    filename = sprintf('%s-eprime.xls',subjname);
    fn_xls = fullfile(DATApath,'Eprime',subjname,filename);
    [a,b,xlsData] = xlsxread(fn_xls);
    
    % Spliting headers and data
    hdrs = xlsData(1,:);
    data = xlsData(2:end,:);
    
    % Get colnum IDs for RunTitle, RESP, RT, and StimType
    colnum_RT       = find_column_number(hdrs,'Probe.RT');
    colnum_evtType  = find_column_number(hdrs,'Stimulus1');
    
    % Get session information, RESP, RT, evtType
    Eprime = struct();
    Eprime.RT       = cell2mat(data(:,colnum_RT));
    Eprime.evtType  = data(:,colnum_evtType);
    
    % Catagorizing Eprime data for each condition
    RT_subj = compute_eprime_data(Eprime);
    evtTypes = fields(RT_subj);
    for i=1:length(evtTypes),
        evtType = evtTypes{i};
        if strcmpi(evtType,'l'), continue; end
        RT(c).(evtType)   = mean([RT_subj.(evtType)]);
    end
end


% Write results in a csv-file
fn_out = fullfile(DATApath,'anal_eprime.csv');
fid    = fopen(fn_out,'w+');
fprintf(fid,'subjname,RT.a,RT.b,RT.c,RT.d\n');
for c=1:nsubj,
    fprintf(fid,'%s,%.1f,%.1f,%.1f,%.1f\n',subjlist{c},RT(c).a,RT(c).b,RT(c).c,RT(c).d);
end
fclose(fid);
