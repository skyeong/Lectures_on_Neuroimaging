% Directory containing Cross-language data
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal';
fn_xls    = fullfile(proj_path,'subjlist.xlsx');

T = readtable(fn_xls);
subjlist = T.subjname;
nsubj = length(subjlist);

dir_name = 'Concrete';
con_novel = 'con_0003.nii';
con_repeat = 'con_0004.nii';


% Specify Model
%--------------------------------------------------------------------------
clear matlabbatch;
out_dir = fullfile(proj_path,'Analysis','SecondLevel','Paired t-test',dir_name); mkdir(out_dir);
matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};
for c=1:nsubj,
    paired_confiles = cell(0);
    paired_confiles{1} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},con_novel);
    paired_confiles{2} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},con_repeat);
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(c).scans = [paired_confiles'];
end


% Parameter Estimation
%--------------------------------------------------------------------------
SPM_mat = fullfile(out_dir,'SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat = {SPM_mat};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


% Create Contrasts
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.con.spmmat = {SPM_mat};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Novel > Repeat';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Novel < Repeat';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 1;
% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);