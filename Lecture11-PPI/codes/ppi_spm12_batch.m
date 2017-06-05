% This batch script analyses the Attention to Visual Motion fMRI dataset
% available from the SPM website using PPI:
%   http://www.fil.ion.ucl.ac.uk/spm/data/attention/
% as described in the SPM manual:
%   http://www.fil.ion.ucl.ac.uk/spm/doc/manual.pdf#Chap:data:ppi
%__________________________________________________________________________
% Copyright (C) 2014 Wellcome Trust Centre for Neuroimaging

% Guillaume Flandin & Darren Gitelman
% $Id: ppi_spm12_batch.m 11 2014-09-29 18:54:09Z guillaume $

% Directory containing the Attention data
%--------------------------------------------------------------------------
data_path = fileparts(mfilename('fullpath'));
if isempty(data_path), data_path = pwd; end
fprintf('%-40s:', 'Downloading Attention dataset...');
urlwrite('http://www.fil.ion.ucl.ac.uk/spm/download/data/attention/attention.zip','attention.zip');
unzip(fullfile(data_path,'attention.zip'));
data_path = fullfile(data_path,'attention');
fprintf(' %30s\n', '...done');

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
% spm_get_defaults('cmdline',true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLM SPECIFICATION, ESTIMATION, INFERENCE, RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load factors
%--------------------------------------------------------------------------
factors = load(fullfile(data_path,'factors.mat'));

clear matlabbatch

% OUTPUT DIRECTORY
%==========================================================================
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(data_path);
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'GLM';

% MODEL SPECIFICATION
%==========================================================================

% Directory
%--------------------------------------------------------------------------
matlabbatch{2}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,'GLM'));

% Timing
%--------------------------------------------------------------------------
matlabbatch{2}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{2}.spm.stats.fmri_spec.timing.RT = 3.22;

% Session
%--------------------------------------------------------------------------
f = spm_select('FPList', fullfile(data_path,'functional'), '^snf.*\.img$');
matlabbatch{2}.spm.stats.fmri_spec.sess.scans = cellstr(f);
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).name = 'Stationary';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).onset = factors.stat;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(1).duration = 10;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).name = 'No-Attention';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).onset = factors.natt;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(2).duration = 10;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).name = 'Attention';
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).onset = factors.att;
matlabbatch{2}.spm.stats.fmri_spec.sess.cond(3).duration = 10;

% Block effect to model the different sessions
%--------------------------------------------------------------------------
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).name = 'Session 1';
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(1).val = kron([1 0 0 0]',ones(90,1));
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(2).name = 'Session 2';
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(2).val = kron([0 1 0 0]',ones(90,1));
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(3).name = 'Session 3';
matlabbatch{2}.spm.stats.fmri_spec.sess.regress(3).val = kron([0 0 1 0]',ones(90,1));

% High-pass filter
%--------------------------------------------------------------------------
matlabbatch{2}.spm.stats.fmri_spec.sess.hpf = 192;

% MODEL ESTIMATION
%==========================================================================
matlabbatch{3}.spm.stats.fmri_est.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));

% INFERENCE
%==========================================================================
matlabbatch{4}.spm.stats.con.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{4}.spm.stats.con.consess{1}.fcon.name = 'Effects of interest';
matlabbatch{4}.spm.stats.con.consess{1}.fcon.weights = [eye(3) zeros(3,4)];
matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'Attention';
matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [0 -1 1 0 0 0 0];
matlabbatch{4}.spm.stats.con.consess{3}.tcon.name = 'Motion';
matlabbatch{4}.spm.stats.con.consess{3}.tcon.weights = [-2 1 1 0 0 0 0];

% RESULTS
%==========================================================================
%matlabbatch{5}.spm.stats.results.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
%matlabbatch{5}.spm.stats.results.conspec.contrasts = 3;
%matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'FWE';
%matlabbatch{5}.spm.stats.results.conspec.thresh = 0.05;
%matlabbatch{5}.spm.stats.results.conspec.extent = 0;
%matlabbatch{5}.spm.stats.results.print = false;

% VOI: EXTRACTING TIME SERIES: V2 [15 -78 -9]
%==========================================================================
matlabbatch{5}.spm.util.voi.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{5}.spm.util.voi.adjust = 1;
matlabbatch{5}.spm.util.voi.session = 1;
matlabbatch{5}.spm.util.voi.name = 'V2';
matlabbatch{5}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{5}.spm.util.voi.roi{1}.spm.contrast = 3;
matlabbatch{5}.spm.util.voi.roi{1}.spm.threshdesc = 'FWE';
matlabbatch{5}.spm.util.voi.roi{1}.spm.thresh = 0.05;
matlabbatch{5}.spm.util.voi.roi{1}.spm.extent = 0;
matlabbatch{5}.spm.util.voi.roi{2}.sphere.centre = [15 -78 -9];
matlabbatch{5}.spm.util.voi.roi{2}.sphere.radius = 6;
matlabbatch{5}.spm.util.voi.roi{2}.sphere.move.local.spm = 1;
matlabbatch{5}.spm.util.voi.expression = 'i1 & i2';

spm_jobman('run',matlabbatch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSYCHO-PHYSIOLOGIC INTERACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear matlabbatch

% GENERATE PPI STRUCTURE
%==========================================================================
matlabbatch{1}.spm.stats.ppi.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{1}.spm.stats.ppi.type.ppi.voi = cellstr(fullfile(data_path,'GLM','VOI_V2_1.mat'));
matlabbatch{1}.spm.stats.ppi.type.ppi.u = [2 1 -1; 3 1 1];
matlabbatch{1}.spm.stats.ppi.name = 'V2x(Att-NoAtt)';
matlabbatch{1}.spm.stats.ppi.disp = 0;

% OUTPUT DIRECTORY
%==========================================================================
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(data_path);
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'PPI';

% MODEL SPECIFICATION
%==========================================================================

% Directory
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,'PPI'));

% Timing
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{3}.spm.stats.fmri_spec.timing.RT = 3.22;

% Session
%--------------------------------------------------------------------------
f = spm_select('FPList', fullfile(data_path,'functional'), '^snf.*\.img$');
matlabbatch{3}.spm.stats.fmri_spec.sess.scans = cellstr(f);

% Regressors
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.fmri_spec.sess.multi_reg = {...
    fullfile(data_path,'GLM','PPI_V2x(Att-NoAtt).mat');...
    fullfile(data_path,'multi_block_regressors.mat')};

% High-pass filter
%--------------------------------------------------------------------------
matlabbatch{3}.spm.stats.fmri_spec.sess.hpf = 192;

% MODEL ESTIMATION
%==========================================================================
matlabbatch{4}.spm.stats.fmri_est.spmmat = cellstr(fullfile(data_path,'PPI','SPM.mat'));

% INFERENCE
%==========================================================================
matlabbatch{5}.spm.stats.con.spmmat = cellstr(fullfile(data_path,'PPI','SPM.mat'));
matlabbatch{5}.spm.stats.con.consess{1}.tcon.name = 'PPI-Interaction';
matlabbatch{5}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0 0];

% RESULTS
%==========================================================================
matlabbatch{6}.spm.stats.results.spmmat = cellstr(fullfile(data_path,'PPI','SPM.mat'));
matlabbatch{6}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{6}.spm.stats.results.conspec.threshdesc = 'none';
matlabbatch{6}.spm.stats.results.conspec.thresh = 0.01;
matlabbatch{6}.spm.stats.results.conspec.extent = 3;
matlabbatch{6}.spm.stats.results.print = false;

spm_jobman('run',matlabbatch);

% JUMP TO V5 AND OVERLAY ON A STRUCTURAL IMAGE
%--------------------------------------------------------------------------
spm_mip_ui('SetCoords',[39 -72 0]);
spm_sections(xSPM,findobj(spm_figure('FindWin','Interactive'),'Tag','hReg'),...
    fullfile(data_path,'structural','nsM00587_0002.img'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSYCHO-PHYSIOLOGIC INTERACTION GRAPH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear matlabbatch

% VOI: EXTRACTING TIME SERIES: V5 [39 -72 0]
%==========================================================================
matlabbatch{1}.spm.util.voi.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{1}.spm.util.voi.adjust = 1;
matlabbatch{1}.spm.util.voi.session = 1;
matlabbatch{1}.spm.util.voi.name = 'V5';
matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = 3;
matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'FWE';
matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.001;
matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 3;
matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = [39 -72 0];
matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 6;
matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.local.spm = 1;
matlabbatch{1}.spm.util.voi.expression = 'i1 & i2';

% GENERATE PPI STRUCTURE: V2xNoAtt
%==========================================================================
matlabbatch{2}.spm.stats.ppi.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{2}.spm.stats.ppi.type.ppi.voi = cellstr(fullfile(data_path,'GLM','VOI_V2_1.mat'));
matlabbatch{2}.spm.stats.ppi.type.ppi.u = [2 1 1];
matlabbatch{2}.spm.stats.ppi.name = 'V2xNoAtt';
matlabbatch{2}.spm.stats.ppi.disp = 0;

% GENERATE PPI STRUCTURE: V2xAtt
%==========================================================================
matlabbatch{3}.spm.stats.ppi.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{3}.spm.stats.ppi.type.ppi.voi = cellstr(fullfile(data_path,'GLM','VOI_V2_1.mat'));
matlabbatch{3}.spm.stats.ppi.type.ppi.u = [3 1 1];
matlabbatch{3}.spm.stats.ppi.name = 'V2xAtt';
matlabbatch{3}.spm.stats.ppi.disp = 0;

% GENERATE PPI STRUCTURE: V5xNoAtt
%==========================================================================
matlabbatch{4}.spm.stats.ppi.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{4}.spm.stats.ppi.type.ppi.voi = cellstr(fullfile(data_path,'GLM','VOI_V5_1.mat'));
matlabbatch{4}.spm.stats.ppi.type.ppi.u = [2 1 1];
matlabbatch{4}.spm.stats.ppi.name = 'V5xNoAtt';
matlabbatch{4}.spm.stats.ppi.disp = 0;

% GENERATE PPI STRUCTURE: V5xAtt
%==========================================================================
matlabbatch{5}.spm.stats.ppi.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
matlabbatch{5}.spm.stats.ppi.type.ppi.voi = cellstr(fullfile(data_path,'GLM','VOI_V5_1.mat'));
matlabbatch{5}.spm.stats.ppi.type.ppi.u = [3 1 1];
matlabbatch{5}.spm.stats.ppi.name = 'V5xAtt';
matlabbatch{5}.spm.stats.ppi.disp = 0;

spm_jobman('run',matlabbatch);

% PLOT THE PPI INTERACTION VECTORS UNDER EACH ATTENTIONAL CONDITION
%==========================================================================
load('PPI_V2xNoAtt.mat'); PPI2NATT = PPI;
load('PPI_V2xAtt.mat');   PPI2ATT  = PPI;
load('PPI_V5xNoAtt.mat'); PPI5NATT = PPI;
load('PPI_V5xAtt.mat');   PPI5ATT  = PPI;

figure;
plot(PPI2NATT.ppi,PPI5NATT.ppi,'k.');
hold on
plot(PPI2ATT.ppi,PPI5ATT.ppi,'r.');

% BEST FIT LINES: NO ATTENTION
%--------------------------------------------------------------------------
x = PPI2NATT.ppi(:);
x = [x, ones(size(x))];
y = PPI5NATT.ppi(:);
B = x\y;
y1 = B(1)*x(:,1)+B(2);
plot(x(:,1),y1,'k-');

% BEST FIT LINES: ATTENTION
%--------------------------------------------------------------------------
x = PPI2ATT.ppi(:);
x = [x, ones(size(x))];
y = PPI5ATT.ppi(:);
B = x\y;
y1 = B(1)*x(:,1)+B(2);
plot(x(:,1),y1,'r-');

legend('No Attention','Attention')
xlabel('V2 activity')
ylabel('V5 response')
title('Psychophysiologic Interaction')
