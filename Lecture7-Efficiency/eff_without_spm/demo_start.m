warning('off','all');
proj_path='/Volumes/JetDrive/workshops/Neuroimaging/Lecture7-Efficiency/';
addpath(fullfile(proj_path,'utils'));

%--------------------------------------------------------
% Scan Parameter
%--------------------------------------------------------
TR    = 2;
nscan = 240;

% Load Table
par_path=fullfile(proj_path,'optseq2_output');
eff = zeros(10,6);
for cnt=1:10
    
    filename ;
    T = read_parfile();
    
    clear C S;
    C{1}=T(strcmpi(T.name,'A'),:).onset/TR;
    
    % Contrast Matrices
    S.CM{1} = [];  % contrast for evt A
    S.CM{1} = [];  % contrast for evt B
    S.CM{1} = [];  % contrast for evt C
    S.CM{1} = [];  % contrast for evt A - B
    S.CM{1} = [];  % contrast for evt A - C

    
    S.sots = C;     % onset times for each event-type in units of scans
    S.TR = TR;
    S.t0 = 1;       % initial transients to ignore (1: no dummy scans)
    S.Ns = nscan;   % Must be more than S.Ni*S.SOAmin/TR
    S.HC = 120;     % high frequency cut-off
    S.bf = 'hrf';   % convolution model
    
    eff(cnt,:) = fMRI_GLM_efficiency(S);  % call once to generate stimulus train
end
