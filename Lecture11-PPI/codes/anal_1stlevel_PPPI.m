addpath('/Volumes/JetDrive/workshops/Neuroimaging/Lecture11-PPI/codes');
addpath(genpath('/Users/skyeong/matlabwork/spm12/toolbox/PPPI/'));

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');



% Change working directory (if you moved working directory)
%--------------------------------------------------------------------------
if 0,
    old_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture11-PPI';
    new_path = '/Users/skyeong/Desktop/Lecture11-PPI';
    fn_MAT = fullfile(proj_path,'Analysis','attention_GLM','SPM.mat');
    spm_changepath(fn_MAT,old_path,new_path);  % SPM-built function
end


% Create volume of interest
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture11-PPI';
GLMdir = fullfile(proj_path,'Analysis','attention_GLM');
VOI = struct('name','V2','center',[15 -78 -9],'radius',6);
create_sphere_image(GLMdir,VOI); % this create VOI_V2_mask.nii



% Configure the PPPI Parameter structure
%--------------------------------------------------------------------------
clear P;
P.subject='gPPI';
P.directory=GLMdir;
P.VOI=fullfile(GLMdir, 'VOI_V2_mask.nii');
P.Estimate=1;
P.contrast=0;
P.extract='eig';
P.Tasks={'1'  'Stationary'  'No-Attention'  'Attention'};
P.Weights=[];
P.analysis='psy';
P.method='cond';
P.CompContrasts=1;
P.Weighted=0;
P.Contrasts(1).left={'Attention'};
P.Contrasts(1).right={'No-Attention'};
P.Contrasts(1).STAT='T';
P.Contrasts(1).Weighted=0;
P.Contrasts(1).MinEvents=5;
P.Contrasts(1).name='Attention_minus_No-Attention';
P.Contrasts(2).left={'No-Attention'};
P.Contrasts(2).right={'Attention'};
P.Contrasts(2).STAT='T';
P.Contrasts(2).Weighted=0;
P.Contrasts(2).MinEvents=5;
P.Contrasts(2).name='No-Attention_minus_Attention';
P.Contrasts(3).left={'Attention'};
P.Contrasts(3).right={'Stationary'};
P.Contrasts(3).STAT='T';
P.Contrasts(3).Weighted=0;
P.Contrasts(3).MinEvents=5;
P.Contrasts(3).name='Attention_minus_Stationary';


% Run PPPI with the command:
%--------------------------------------------------------------------------
PPPI(P);
