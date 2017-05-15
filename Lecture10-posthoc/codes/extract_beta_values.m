% Start marsbar to make sure spm_get works
marsbar('on')


% You might want to define the path for your project
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal';
fn_xls    = fullfile(proj_path,'subjlist.xlsx');

T = readtable(fn_xls);
subjlist = T.subjname;
nsubj = length(subjlist);


%--------------------------------------------------------------------------
% Create ROI using marsbar script
%--------------------------------------------------------------------------
% MNIcenters: center coordinates of ROI
% RADIUS: radius of ROI
% roi_dir: output directory to save ROI image
% fn_mask(optional): file path of mask image (to define image space)

RADIUS = 6;
clear MNIcenters;
MNIcenters{1} = [-52 30 0];
MNIcenters{2} = [52 30 0];

fn_mask = fullfile(proj_path,'Analysis','SecondLevel','Flexible','mask.nii');
roi_dir = fullfile(proj_path,'Analysis','rois'); mkdir(roi_dir);
roi_files = create_ROI(MNIcenters,RADIUS,roi_dir,fn_mask);




%--------------------------------------------------------------------------
% MarsBaR estimation to extract beta values in each ROI
%--------------------------------------------------------------------------
nroi = length(roi_files);
ncond = 4;

BetaValues = zeros(nsubj,ncond,nroi);
for c = 1:5
    subjname = subjlist{c};
    spm_name = fullfile(proj_path,'Analysis','FirstLevel',subjname,'SPM.mat');
    %swa_path = fullfile(proj_path,'preprocessed',subjname);
    %change_SPMfile_path(spm_name,swa_path);

    % Make marsbar design object
    D = mardo(spm_name);
    
    for r=1:length(roi_files),
        % Make marsbar ROI object
        R = maroi(roi_files{r});
        
        % Fetch data into marsbar data object
        Y = get_marsy(R,D,'mean');
        
        % Get contrasts from original design
        xCon = get_contrasts(D);
        
        % Estimate design on ROI data
        E = estimate(D,Y);
        
        % Get design betas
        b = betas(E);
        for cond_i=1:length(xCon),
            con_vec = xCon(cond_i).c;
            BetaValues(c,cond_i,r) = mean(b(con_vec==1));  % average across sessions
        end
    end
end

dlmwrite('~/Desktop/BetaValues.csv',BetaValues(:,:,1));  % Save for ROI1