
addpath('/Users/skyeong/connectome/HRV/');
addpath('/Users/skyeong/connectome/HRV/utils/');



% Load Study Infomation
proj_path = '/Users/skyeong/Desktop/Data/';
fn_xls = '/Users/skyeong/Desktop/Data/subjlist.xlsx';
T = readtable(fn_xls);
subjlist = T.subjname;
nsubj = length(subjlist);

Fs = 50;



stimType = {'ATT1','ATT2'};
times = [0:10:241];

ATT1 = struct();
ATT2 = struct();

for c=1:nsubj,
    subjname = subjlist{c};
    fprintf('   %s, HRV computing ... \n',subjname);
    
    %------------------------------------------------------------------
    %   Attention 1
    %------------------------------------------------------------------
    fn_PPG = fullfile(proj_path,'PPG',[subjname '_ATT1.csv']);
    if ~exist(fn_PPG,'file'),
        continue;
    end
    
    PPG = dlmread(fn_PPG);
    time = PPG(:,1)-PPG(1,1); t_max = time(end);
    X = PPG(:,2);
    
    HR = zeros(length(times),1);
    for t=1:length(times),
        st = times(t);
        ed = times(t) + 60-1;
        HR(t) = calc_HRV_window(time,X,Fs,st,ed);
        
    end
    ATT1(c).HR = HR;
    
    %------------------------------------------------------------------
    %   Attention 2
    %------------------------------------------------------------------
    fn_PPG = fullfile(proj_path,'PPG',[subjname '_ATT2.csv']);
    if ~exist(fn_PPG,'file'),  continue;  end
    
    PPG = dlmread(fn_PPG);
    time = PPG(:,1)-PPG(1,1); t_max = time(end);
    X = PPG(:,2);
    
    HR = zeros(length(times),1);
    for t=1:length(times),
        st = times(t);
        ed = times(t) + 60-1;
        HR(t) = calc_HRV_window(time,X,Fs,st,ed);
    end
    ATT2(c).HR = HR;
end

HRp = [ATT1.HR];
HRn = [ATT2.HR];
figure;
plot(times+30,mean(HRp,2),'ro-'); hold on
plot(times+30,mean(HRn,2),'bo-')
title('Heart Rate');


return;
% [1] G. D. Clifford's Ph.D. Thesis (Citeseer, 2002)
%     Signal processing methods for heart rate variability

