addpath('/Users/skyeong/matlabscripts/Couple_fmri/utils');


% Directory containing Cross-language data
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal';
fn_xls    = fullfile(proj_path,'subjlist.xlsx');

T = readtable(fn_xls);
subjlist = T.subjname;
nsubj = length(subjlist);

dir_name = 'Abstract-Novel';
con_name = 'con_0001.nii';


% Specify Model
%--------------------------------------------------------------------------
clear matlabbatch;
out_dir = fullfile(proj_path,'Analysis','SecondLevel','One sample',dir_name); mkdir(out_dir);
confiles = cell(0);
for c=1:nsubj,
    confiles{c} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},con_name);
end
matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = [confiles'];
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;


% Parameter Estimation
%--------------------------------------------------------------------------
SPM_mat = fullfile(out_dir,'SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat = {SPM_mat};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


% Create Contrasts
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.con.spmmat = {SPM_mat};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Activation';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Deactivation';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = -1;
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 1;
% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);