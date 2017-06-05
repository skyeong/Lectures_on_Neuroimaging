function create_sphere_image(GLMdir,VOI)

% SEE RESULTS
%==========================================================================
clear matlabbatch;
matlabbatch{1}.spm.stats.results.spmmat = cellstr(fullfile(GLMdir,'SPM.mat'));
matlabbatch{1}.spm.stats.results.conspec.contrasts = 3;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.print = false;


% VOI: EXTRACTING TIME SERIES
%==========================================================================
matlabbatch{2}.spm.util.voi.spmmat = cellstr(fullfile(GLMdir,'SPM.mat'));
matlabbatch{2}.spm.util.voi.adjust = 1;
matlabbatch{2}.spm.util.voi.session = 1;
matlabbatch{2}.spm.util.voi.name = VOI.name;
matlabbatch{2}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{2}.spm.util.voi.roi{1}.spm.contrast = 3;
matlabbatch{2}.spm.util.voi.roi{1}.spm.threshdesc = 'FWE';
matlabbatch{2}.spm.util.voi.roi{1}.spm.thresh = 0.05;
matlabbatch{2}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{2}.spm.util.voi.roi{2}.sphere.centre = VOI.center;
matlabbatch{2}.spm.util.voi.roi{2}.sphere.radius = VOI.radius;
% matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.fixed = 1;
matlabbatch{2}.spm.util.voi.roi{2}.sphere.move.local.spm = 1;
matlabbatch{2}.spm.util.voi.expression = 'i1 & i2';

% spm_jobman('interactive',matlabbatch);
spm_jobman('run',matlabbatch);

