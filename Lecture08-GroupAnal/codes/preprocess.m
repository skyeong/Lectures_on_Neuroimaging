warning('off','all');
addpath('/Users/skyeong/matlabwork/spm12');


% fMRI parameter
%--------------------------------------------------------------------------
nslices  = 21;
TR       = 2;
if rem(nslices,2)
    sliceOrd = [1:2:nslices 2:2:nslices];
else
    sliceOrd = [2:2:nslices 1:2:nslices];
end
refslice = round(nslices/2);


% Directory containing Face data
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal/';
addpath(fullfile(proj_path,'utils'));
fn_xls    = fullfile(proj_path,'subjlist.xlsx');
T = readtable(fn_xls);

data_path = fullfile(proj_path,'preprocessed');
subjlist = T.subjname;
nsubj = length(subjlist);


% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');

% fmriName = ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPATIAL PREPROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for c=1:nsubj,
    subjname = subjlist{c};
    clear matlabbatch
    
    % Select functional and structural scans
    %--------------------------------------------------------------------------
    f = spm_select('FPList', fullfile(data_path,subjname,fmriName), '^fmri.nii');
    a = spm_select('FPList', fullfile(data_path,subjname,'anat'), '^hires.nii');
    f = get_filepath(f);
    
    
    % Realign
    %--------------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.realign.estwrite.data{1} = cellstr(f);
    
    
    % Slice Timing Correction
    %--------------------------------------------------------------------------
    matlabbatch{2}.spm.temporal.st.scans{1} = cellstr(spm_file(f,'prefix','r'));
    matlabbatch{2}.spm.temporal.st.nslices = nslices;
    matlabbatch{2}.spm.temporal.st.tr = TR;
    matlabbatch{2}.spm.temporal.st.ta = TR-TR/nslices;
    matlabbatch{2}.spm.temporal.st.so = sliceOrd;
    matlabbatch{2}.spm.temporal.st.refslice = refslice;
    
    
    % Coregister
    %--------------------------------------------------------------------------
    matlabbatch{3}.spm.spatial.coreg.estimate.ref    = cellstr(spm_file(f(1,:),'prefix','mean'));
    matlabbatch{3}.spm.spatial.coreg.estimate.source = cellstr(a);
    
    
    % Normalise: Estimate and Write
    %--------------------------------------------------------------------------
    matlabbatch{4}.spm.spatial.normalise.estwrite.subj.vol = cellstr(a);
    matlabbatch{4}.spm.spatial.normalise.estwrite.subj.resample = cellstr([spm_file(f,'prefix','ar');a]);
    matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.tpm = {fullfile(spm('dir'),'tpm','TPM.nii')};
    %matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70; 78 76 85];
    matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    
    
    % Smooth
    %--------------------------------------------------------------------------
    matlabbatch{5}.spm.spatial.smooth.data = cellstr(spm_file(f,'prefix','war'));
    matlabbatch{5}.spm.spatial.smooth.fwhm = [6 6 6];
    
    %save('face_batch_preprocessing.mat','matlabbatch');
    spm_jobman('run',matlabbatch);
end