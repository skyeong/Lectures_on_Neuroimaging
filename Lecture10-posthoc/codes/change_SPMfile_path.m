function change_SPMfile_path(SPMfile,swa_path)

% CHANGE MAIN PATH
% ---------------------------------
load(SPMfile);
SPM.swd = targetdir;

nfile = length(SPM.xY.VY);
for j=1:nfile,
    [p1, f1, e1]=fileparts(SPM.xY.VY(j).fname);
    SPM.xY.VY(j).fname=fullfile(swa_path, [f1, e1]);
end
save(SPMfile,'SPM');
% ---------------------------------
