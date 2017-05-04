% Start marsbar to make sure spm_get works
marsbar('on')

% You might want to define the path for your project
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal';
fn_xls    = fullfile(proj_path,'subjlist.xlsx');
T         = readtable(fn_xls);
subjlist  = T.subjname;
nsubj     = length(subjlist);


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
event_duration = 0;  % default SPM event duration

PCT_EVT = zeros(nsubj,ncond,nroi);
for c = 1:nsubj
    subjname = subjlist{c};
    spm_name = fullfile(proj_path,'Analysis','FirstLevel',subjname,'SPM.mat');
    
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
        
        % Get definition of all events in model
        [e_specs, e_names] = event_specs(E);
        n_events = size(e_specs,2);
        
        % Return percent signal estimate for all events in design
        pct_ev = zeros(n_events,1);
        for e_s = 1:n_events,
            pct_ev(e_s) = event_signal(E, e_specs(:,e_s),event_duration);
        end
        
        % Compute average value over sessions
        for cond_i=1:length(xCon),
            PCT_EVT(c,cond_i,r) = mean(pct_ev(e_specs(2,:)==cond_i));  % average over sessions
        end
        
    end
end

dlmwrite('~/Desktop/PCT_EVT.csv',PCT_EVT(:,:,1));  % Save for ROI1