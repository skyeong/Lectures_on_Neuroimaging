function firstlevel_create_contrast(LA)

clear jobs;
disp('RUNNING contrast specification');
fn_mat = fullfile([LA.d_stats],'SPM.mat');
jobs{1}.stats{1}.con.spmmat = {fn_mat};

%--------------------------------------------------------------------------
% T-contrast
%--------------------------------------------------------------------------
for cn = 1:length(LA.con)
    jobs{1}.stats{1}.con.consess{cn}.tcon.name      = LA.con(cn).name;
    jobs{1}.stats{1}.con.consess{cn}.tcon.convec    = LA.con(cn).c;
    jobs{1}.stats{1}.con.consess{cn}.tcon.sessrep   = LA.con(cn).srep;
end

jobs{1}.stats{1}.con.delete    = LA.con.del;
spm_jobman('run',jobs);
