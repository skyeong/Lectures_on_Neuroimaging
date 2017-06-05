% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');


% Imaging Parameter
%--------------------------------------------------------------------------
TR = 3.22;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLM SPECIFICATION, ESTIMATION, INFERENCE, RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load factors
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture11-PPI';
data_path = fullfile(proj_path,'data','attention');
factors = load(fullfile(data_path,'factors.mat'));



% MODEL SPECIFICATION
%==========================================================================
clear matlabbatch;

% Directory
%--------------------------------------------------------------------------
outdir = fullfile(proj_path,'Analysis','attention_GLM'); mkdir(outdir);
matlabbatch{1}.spm.stats.fmri_spec.dir = {outdir};

% Timing
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;

% Session
%--------------------------------------------------------------------------
f = spm_select('FPList', fullfile(data_path,'functional'), '^snf.*\.nii$');
f = get_filepath(f);
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(f);
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Stationary';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = factors.stat;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 10;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'No-Attention';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = factors.natt;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 10;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'Attention';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = factors.att;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 10;

% Block effect to model the different sessions
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = 'Session 1';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = kron([1 0 0 0]',ones(90,1));
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Session 2';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = kron([0 1 0 0]',ones(90,1));
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Session 3';
matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = kron([0 0 1 0]',ones(90,1));

% High-pass filter
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 192;



% MODEL ESTIMATION
%==========================================================================
SPMmat = fullfile(outdir,'SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(SPMmat);



% INFERENCE
%==========================================================================
matlabbatch{3}.spm.stats.con.spmmat = cellstr(SPMmat);
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'Effects of interest';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [eye(3) zeros(3,4)];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Attention';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 -1 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Motion';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [-2 1 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.delete = 1;


spm_jobman('run',matlabbatch);