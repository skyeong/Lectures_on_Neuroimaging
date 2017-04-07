DATApath = '/Volumes/JetDrive/workshops/Matlab/lecture1/data';

% Load Excel data
fn_xls = fullfile(DATApath,'subjlist.xlsx');
[a,b,xlsData] = xlsread(fn_xls);


% Separate header and data
hdrs = xlsData(1,:);
data = xlsData(2:end,:);


% Get list of subjname
col_subjname = find_column_number(hdrs,'subjname');
list_subject = data(:,col_subjname);


% Get list of position
col_position = find_column_number(hdrs,'position');
list_position = data(:,col_position);


% Get list of age
col_age = find_column_number(hdrs,'age');
list_age = data(:,col_age);
list_age = cell2mat(list_age);


% Get list of sex
col_sex = find_column_number(hdrs,'sex');
list_sex = cell2mat(data(:,col_sex));



