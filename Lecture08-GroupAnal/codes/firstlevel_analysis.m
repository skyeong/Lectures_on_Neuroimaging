addpath('/Users/skyeong/matlabscripts/Couple_fmri/utils');


% fMRI parameter
%--------------------------------------------------------------------------
nslices  = 21;
refslice = round(nslices/2);
TR       = 2;
nscan    = 200;


% Analysis Options
%--------------------------------------------------------------------------
flagCreateDeasignMatrix = 1;
flagEstimateParameters  = 1;
flagCreateContrasts     = 1;



% Directory containing Cross-language data
%--------------------------------------------------------------------------
proj_path = '/Volumes/JetDrive/workshops/Neuroimaging/Lecture08-GroupAnal';
fmri_path = fullfile(proj_path,'preprocessed');
fn_xls    = fullfile(proj_path,'subjlist.xlsx');


T = readtable(fn_xls);

subjlist = T.subjname;
nsubj = length(subjlist);


%--------------------------------------------------------------------------
% 1st-level general linear modeling
%--------------------------------------------------------------------------
stim_types = {'Abstract-Novel','Abstract-Repeat','Concrete-Novel','Concrete-Repeat'};
for c=1:nsubj,
    clear matlabbatch;
    subjname = subjlist{c};
    out_path = fullfile(proj_path,'Analysis','FirstLevel',subjname); mkdir(out_path);
    
    % Specify 1st-level
    %----------------------------------------------------------------------
    if flagCreateDeasignMatrix==1
        matlabbatch{1}.spm.stats.fmri_spec.dir = {out_path};
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = nslices;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = refslice;
        
        % Load Session Data
        for s=1:6,
            
            % fmri data
            fmri1 = fullfile(fmri_path,subjname,['func' num2str(s)],'swarfmri.nii');
            fmri1 = get_filepath(fmri1);
            
            % onset information
            fn_onset = fullfile(fmri_path,subjname,['func' num2str(s)],'fmri.csv');
            T_onset = readtable(fn_onset,'Delimiter','\t');
            T_onset = extract_onset_info(T_onset);
            
            % Head motion parameter
            rpfile = fullfile(fmri_path,subjname,['func' num2str(s)],'rp_fmri.txt');
            
            
            AbstractNovel = T_onset(strcmpi(T_onset.Concreteness,'Abstract') & strcmpi(T_onset.Repetition,'Novel'),:).onset;
            AbstractRepeat = T_onset(strcmpi(T_onset.Concreteness,'Abstract') & strcmpi(T_onset.Repetition,'Repeat'),:).onset;
            ConcreteNovel = T_onset(strcmpi(T_onset.Concreteness,'Concrete') & strcmpi(T_onset.Repetition,'Novel'),:).onset;
            ConcreteRepeat = T_onset(strcmpi(T_onset.Concreteness,'Concrete') & strcmpi(T_onset.Repetition,'Repeat'),:).onset;
            
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).scans = cellstr(fmri1);
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).name = 'Abstract-Novel';
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).onset = AbstractNovel;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(1).duration = 2;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).name = 'Abstract-Repeat';
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).onset = AbstractRepeat;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(2).duration = 2;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).name = 'Concrete-Novel';
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).onset = ConcreteNovel;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(3).duration = 2;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).name = 'Concrete-Repeat';
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).onset = ConcreteRepeat;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).cond(4).duration = 2;
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).multi_reg = {rpfile};
            matlabbatch{1}.spm.stats.fmri_spec.sess(s).hpf = 128;
        end
        
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
        
        % spm_jobman('interactive',matlabbatch);
        spm_jobman('run',matlabbatch);
    end
    
    % Parameter estimation
    %----------------------------------------------------------------------
    fn_mat = fullfile(out_path,'SPM.mat');
    if flagEstimateParameters==1
        clear matlabbatch;
        matlabbatch{1}.spm.stats.fmri_est.spmmat = {fn_mat};
        matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
        spm_jobman('run',matlabbatch);
    end
    
    % Create contrasts
    %----------------------------------------------------------------------
    if flagCreateContrasts==1
        clear matlabbatch;
        matlabbatch{1}.spm.stats.con.spmmat = {fn_mat};
        cnt = 1;
        for i=1:4,
            contrasts = zeros(4,1);
            contrasts(i) = +1;
            matlabbatch{1}.spm.stats.con.consess{cnt}.tcon.name = stim_types{i};
            matlabbatch{1}.spm.stats.con.consess{cnt}.tcon.weights = contrasts;
            matlabbatch{1}.spm.stats.con.consess{cnt}.tcon.sessrep = 'repl';
            cnt = cnt+1;
        end
        
        matlabbatch{1}.spm.stats.con.delete = 1;
        spm_jobman('run',matlabbatch);
    end
end