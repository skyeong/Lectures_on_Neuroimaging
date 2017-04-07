%--------------------------------------------------------------------------
% Specify path and addpath
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Matlab/Lecture7-Efficiency';
myHome = fullfile(proj_path,'eff_with_spm'); mkdir(myHome);
opqseq2_output_path = fullfile(proj_path,'optseq2_output');

addpath('/Users/skyeong/matlabwork/spm12');
addpath(fullfile(proj_path,'utils'));
addpath(myHome);


%--------------------------------------------------------------------------
% Some parameters and variables
%--------------------------------------------------------------------------
plotmode=0;
nseq = 10;
clear EFF;
for i=1:nseq,
    
    %----------------------------------------------------------------------
    % Create fMRI Model using optseq2 results
    %----------------------------------------------------------------------
    filename = sprintf('ex1-%03d',i);
    fn_par   = fullfile(opqseq2_output_path,[filename,'.par']);
    LA       = create_fmri_model(myHome,fn_par,filename);
    
    
    %----------------------------------------------------------------------
    % First fMRI data analysis using optseqs and fake fMRI data
    %----------------------------------------------------------------------
    spm fmri;
    firstlevel_specify_model(LA);    % model specification
    firstlevel_parameter_est(LA);    % parameter estimation
    firstlevel_create_contrast(LA);  % create contrast
    
    
    %----------------------------------------------------------------------
    % Efficiencies: get calculated
    %----------------------------------------------------------------------
    load (fullfile(LA.d_stats,'SPM.mat'));
    eff = [];
    for j=1:length(LA.con)
        eff = [eff, spm_ccr_contrast_efficiency(SPM,j)];
    end
    EFF(i).eff = eff;
    
    %----------------------------------------------------------------------
    % Efficiencies: get calculated
    %----------------------------------------------------------------------
    EFF(i).corr = corr(SPM.xX.X);
    
    %----------------------------------------------------------------------
    % Plot contrast efficiency vector
    %----------------------------------------------------------------------
    if (plotmode)
        try
            close(fh33);
        end
        fh33 = figure(33); bar(eff); title('Efficiency Matrix');
        xlabel('Contrasts'); ylabel('Arbitrary Efficiency Value');
    end
    
    % Concatenate eff-variable in the 3rd dimension
    %----------------------------------------------------------------------
    contrastEffVector_3D = cat(3, contrastEffVector_3D, eff) ;
end


%--------------------------------------------------------------------------
% Plot Efficiency Matrix
%--------------------------------------------------------------------------
fh55 = figure(55);
effMat = squeeze(contrastEffVector_3D);
meanEffMat = mean(effMat,2);
stdErrEffMat = std(effMat,1,2) / sqrt(size(effMat,2));
eh1 = errorbar(1:length(stdErrEffMat), meanEffMat, stdErrEffMat); hold on;
set(eh1, 'linestyle', 'none', 'color', [0 0 0], 'linewidth', 2);
bar(meanEffMat, 'k');

set(gca , 'XTick', 1:length(LA.con));
set(gca , 'XTickLabels', {LA.con.name});
xticklabel_rotate([],45,[],'Fontsize',10); axis square;

title('Efficiency Matrix');
xlabel('Contrasts'); ylabel('Arbitrary Efficiency Value');

cd(myHome);
