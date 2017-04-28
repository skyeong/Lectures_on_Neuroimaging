% Directory containing Cross-language data
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal';
fn_xls    = fullfile(proj_path,'subjlist.xlsx');

T = readtable(fn_xls);
subjlist = T.subjname;
nsubj = length(subjlist);


% Specify Model
%--------------------------------------------------------------------------
clear matlabbatch;
out_dir = fullfile(proj_path,'Analysis','SecondLevel','Factorial'); mkdir(out_dir);
con1files = cell(0);
con2files = cell(0);
con3files = cell(0);
con4files = cell(0);

for c=1:nsubj,
    con1files{c} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0001.nii');
    con2files{c} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0002.nii');
    con3files{c} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0003.nii');
    con4files{c} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0004.nii');
end

matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'Condition';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).name = 'Repetition';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = [1 1];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans = [con1files'];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = [1 2];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans = [con2files'];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).levels = [2 1];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).scans = [con3files'];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).levels = [2 2];
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).scans = [con4files'];
matlabbatch{1}.spm.stats.factorial_design.des.fd.contrasts = 1;


% Parameter Estimation
%--------------------------------------------------------------------------
SPM_mat = fullfile(out_dir,'SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat = {SPM_mat};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);
