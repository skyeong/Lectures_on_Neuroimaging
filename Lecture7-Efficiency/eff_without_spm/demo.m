warning('off','all');
proj_path='/Volumes/JetDrive/workshops/Matlab/Lecture7-Efficiency/';
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
    
    filename=sprintf('ex1-%03d.par',cnt);
    T = read_parfile(fullfile(par_path,filename));
    
    clear C S;
    C{1}=T(strcmpi(T.name,'A'),:).onset/TR;
    C{2}=T(strcmpi(T.name,'B'),:).onset/TR;
    C{3}=T(strcmpi(T.name,'C'),:).onset/TR;
    C{4}=T(strcmpi(T.name,'NULL'),:).onset/TR;
    
    S=[];
    
    % Contrast Matrices
    S.CM{1} = [1 0 0 0];     % A
    S.CM{2} = [0 1 0 0];     % B
    S.CM{3} = [0 0 1 0];     % C
    S.CM{4} = [1 -1 0 0];    % A-B
    S.CM{5} = [1 0 -1 0];    % A-C
    S.CM{6} = [0 1 -1 0];    % B-C
    
    S.sots = C;     % onset times for each event-type in units of scans
    S.TR = TR;
    S.t0 = 1;       % initial transients to ignore (1: no dummy scans)
    S.Ns = nscan;   % Must be more than S.Ni*S.SOAmin/TR
    S.HC = 120;     % high frequency cut-off
    S.bf = 'hrf';   % convolution model
    
    eff(cnt,:) = fMRI_GLM_efficiency(S);  % call once to generate stimulus train
end
