% Initialise SPM
%--------------------------------------------------------------------------
addpath('/Volumes/JetDrive/workshops/Neuroimaging/Lecture11-PPI/codes');
spm('Defaults','fMRI');
spm_jobman('initcfg');


% Imaging Parameter
%--------------------------------------------------------------------------
TR = 3.22;



% Load factors
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture11-PPI';
data_path = fullfile(proj_path,'data','attention');
factors = load(fullfile(data_path,'factors.mat'));


%% EXTRACT VOLUME OF INTEREST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GLMdir = fullfile(proj_path,'Analysis','attention_GLM');
VOI = struct('name','V2','center',[15 -78 -9],'radius',6);
create_sphere_image(GLMdir,VOI);


%% CREATE PPI VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear matlabbatch

% GENERATE PPI STRUCTURE
%==========================================================================
matlabbatch{1}.spm.stats.ppi.spmmat = cellstr(fullfile(GLMdir,'SPM.mat'));
matlabbatch{1}.spm.stats.ppi.type.ppi.voi = cellstr(fullfile(GLMdir,'VOI_V2_1.mat'));
matlabbatch{1}.spm.stats.ppi.type.ppi.u = [2 1 -1; 3 1 1];
matlabbatch{1}.spm.stats.ppi.name = 'V2x(Att-NoAtt)';
matlabbatch{1}.spm.stats.ppi.disp = 0;
spm_jobman('run',matlabbatch);


%% MODEL SPECIFICATION
%==========================================================================
clear matlabbatch

% Directory
%--------------------------------------------------------------------------
PPIdir = fullfile(proj_path,'Analysis','attention_sPPI'); mkdir(PPIdir);
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(PPIdir);

% Timing
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;

% Session
%--------------------------------------------------------------------------
f = spm_select('FPList', fullfile(data_path,'functional'), '^snf.*\.nii$');
f = get_filepath(f);
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(f);

% PPI-variables and Regressors
%--------------------------------------------------------------------------
fn_PPI = fullfile(GLMdir,'PPI_V2x(Att-NoAtt).mat'); load(fn_PPI);
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = 'PPI';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = PPI.ppi;
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Psychological condition';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.P;
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'BOLD signal';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = PPI.Y;

% Block effect to model the different sessions
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).name = 'Session 1';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(4).val = kron([1 0 0 0]',ones(90,1));
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(5).name = 'Session 2';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(5).val = kron([0 1 0 0]',ones(90,1));
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(6).name = 'Session 3';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(6).val = kron([0 0 1 0]',ones(90,1));

% High-pass filter
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 192;
% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);




%% MODEL ESTIMATION
%==========================================================================
clear matlabbatch;
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(fullfile(PPIdir,'SPM.mat'));
spm_jobman('run',matlabbatch);



%% INFERENCE
%==========================================================================
clear matlabbatch;
matlabbatch{1}.spm.stats.con.spmmat = cellstr(fullfile(PPIdir,'SPM.mat'));
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'PPI-Interaction';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0 0];
% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);

