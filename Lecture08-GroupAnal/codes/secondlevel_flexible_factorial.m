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
out_dir = fullfile(proj_path,'Analysis','SecondLevel','Flexible'); mkdir(out_dir);

matlabbatch{1}.spm.stats.factorial_design.dir = {out_dir};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'condition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).name = 'repetition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).variance = 1;


for c=1:nsubj,
    confiles = cell(0);
    confiles{1} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0001.nii');
    confiles{2} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0002.nii');
    confiles{3} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0003.nii');
    confiles{4} = fullfile( proj_path,'Analysis','FirstLevel',subjlist{c},'con_0004.nii');
    
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(c).scans = [confiles'];
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(c).conds = [1 1; 1 2; 2 1; 2 2];

end
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 3;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [2 3];


% Parameter Estimation
%--------------------------------------------------------------------------
SPM_mat = fullfile(out_dir,'SPM.mat');
matlabbatch{2}.spm.stats.fmri_est.spmmat = {SPM_mat};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


% Create Contrasts
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.con.spmmat = {SPM_mat};
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'Main effect of condition';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [1 -1 0 0 0.5 0.5 -0.5 -0.5];
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.name = 'Main effect of repetition';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.weights = [0 0 1 -1 0.5 -0.5 0.5 -0.5];
matlabbatch{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.name = 'Interaction';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.weights = [0 0 0 0 1 -1 -1 1];
matlabbatch{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 1;


% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);
