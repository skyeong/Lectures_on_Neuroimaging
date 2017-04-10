function firstlevel_parameter_est(LA)

clear jobs;
disp('RUNNING model estimation');
fn_mat = fullfile([LA.d_stats],'SPM.mat');
jobs{1}.stats{1}.fmri_est.spmmat = {fn_mat};
spm_jobman('run',jobs);