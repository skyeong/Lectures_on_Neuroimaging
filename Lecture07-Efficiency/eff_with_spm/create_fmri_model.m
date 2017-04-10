function LA = create_fmri_model(myHome,filename,modelname)
clear C LA;

% Scan Parameters
%--------------------------------------------------------------------------
nscan    = 240;
nslice   = 30;
refslice = 15;
TR       = 2;   % second


% Load output from optseq2
%--------------------------------------------------------------------------
T = read_parfile(filename);
C{1} = T(strcmpi(T.name,'A'),:).onset;
C{2} = T(strcmpi(T.name,'B'),:).onset;
C{3} = T(strcmpi(T.name,'C'),:).onset;
C{4} = T(strcmpi(T.name,'NULL'),:).onset;



% 1st-level design (specify your model)
%--------------------------------------------------------------------------
LA.c_names   = {'A', 'B', 'C', 'NULL'}; % Type of Events
LA.c_dur     = {2 4 6 0};               % 0 = event ; 1 = block


% Create Contrast Vector (T-contrast only!!)
%--------------------------------------------------------------------------
LA.con.del = 1; % Delete existing contrasts

% T-contrast 1
cn = 1;
LA.con(cn).name = 'Condition A';
LA.con(cn).c    = [1 0 0 0];
LA.con(cn).srep = 'repl'; % or 'none'
cn = cn+1;

% T-contrast 2
LA.con(cn).name = 'Condition B';
LA.con(cn).c    = [0 1 0 0];
LA.con(cn).srep = 'repl'; % or 'none'
cn = cn+1;

% T-contrast 3
LA.con(cn).name = 'Condition C';
LA.con(cn).c    = [0 0 1 0];
LA.con(cn).srep = 'repl'; % or 'none'
cn = cn+1;

% T-contrast 4
LA.con(cn).name = 'A>B';
LA.con(cn).c    = [1 -1 0 0];
LA.con(cn).srep = 'repl'; % or 'none'
cn = cn+1;

% T-contrast 5
LA.con(cn).name = 'A>C';
LA.con(cn).c    = [1 0 -1 0];
LA.con(cn).srep = 'repl'; % or 'none'
cn = cn+1;

% T-contrast 6
LA.con(cn).name = 'B>C';
LA.con(cn).c    = [0 1 -1 0];
LA.con(cn).srep = 'repl'; % or 'none'
cn = cn+1;




%% Do Not Change Below
% Directory structure
%--------------------------------------------------------------------------
LA.jobname   = modelname;
LA.jobdir    = fullfile(myHome,'log');
LA.d_stats   = fullfile(myHome,'stats', LA.jobname);
LA.d_data    = fullfile(myHome,'fake_data');

% Create output stat directory
%--------------------------------------------------------------------------
if exist(LA.d_stats,'dir') ~= 7
    mkdir(LA.d_stats);
    cd(LA.d_stats);
else
    cd(LA.d_stats);
end


%--------------------------------------------------------------------------
% 1st-level design (default setting)
%--------------------------------------------------------------------------
LA.nscan     = nscan;    % number of scans
LA.TU        = 'secs';   % 'secs' timing units
LA.fmri_t    = nslice;   % number of bins (slices)
LA.fmri_t0   = refslice; % reference bin
LA.TR        = TR;       % TR in seconds
LA.hpcutoff  = 128;      % high-pass filter cutoff seconds (ORIGINAL!!!)
LA.serial    = 'AR(1)';  % serial autocorrelation
LA.global    = 'None';   % proportional scaling
LA.volt      = 1;        % volterra kernel
LA.mask      = '';       % which mask for explicit masking?
LA.derivs    = [0 0];    % temporal and dispersion derivatives, set to 1 if want to be included


% insert onset time
%--------------------------------------------------------------------------
for i=1:length(LA.c_names),
    LA.c_ons{i} = C{i};
    LA.c_param{i} = struct( 'name',{},'param', {}, 'poly', {});  % no parametric modulation
end

LA.regress = struct( 'name',{},'val',[]);
LA.fact    = struct('name', {}, 'levels', {});

% for printing results
LA.corr      = 0;
LA.vthre     = 3;
LA.ethre     = 0;
LA.filename  = ['all_contrasts_' modelname '.ps'];
mkdir(LA.jobdir);
save(fullfile(LA.jobdir, ['LA_' modelname '.mat']),'LA');

