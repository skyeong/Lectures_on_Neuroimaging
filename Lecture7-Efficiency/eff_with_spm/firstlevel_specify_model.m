function firstlevel_specify_model(LA)

clear jobs;
jobs{1}.stats{1}.fmri_spec.dir              = {[LA.d_stats]};

% model timing variables
jobs{1}.stats{1}.fmri_spec.timing.units     = LA.TU;
jobs{1}.stats{1}.fmri_spec.timing.RT        = LA.TR;
jobs{1}.stats{1}.fmri_spec.timing.fmri_t    = LA.fmri_t;
jobs{1}.stats{1}.fmri_spec.timing.fmri_t0   = LA.fmri_t0;

% hemodynamic model specifics
jobs{1}.stats{1}.fmri_spec.volt             = LA.volt;
jobs{1}.stats{1}.fmri_spec.global           = LA.global;
jobs{1}.stats{1}.fmri_spec.cvi              = LA.serial;
jobs{1}.stats{1}.fmri_spec.mask             = {LA.mask};
jobs{1}.stats{1}.fmri_spec.bases.hrf.derivs = [0 0];

% session specifics
clear fmri;
fmri = create_fakedata(LA.d_data,LA.nscan);
jobs{1}.stats{1}.fmri_spec.sess(1).scans   = cellstr(fmri);
jobs{1}.stats{1}.fmri_spec.sess(1).hpf     = LA.hpcutoff;
for c = 1 : length(LA.c_ons)
    jobs{1}.stats{1}.fmri_spec.sess(1).cond(c).name     = LA.c_names{c};
    jobs{1}.stats{1}.fmri_spec.sess(1).cond(c).onset    = LA.c_ons{c};
    jobs{1}.stats{1}.fmri_spec.sess(1).cond(c).duration = LA.c_dur{c};
    %jobs{1}.stats{1}.fmri_spec.sess(1).cond(c).tmod     = LA.c_tparam{c}; % no time modulation
    %jobs{1}.stats{1}.fmri_spec.sess(1).cond(c).tmod     = 0; % no time modulation
    %jobs{1}.stats{1}.fmri_spec.sess(1).cond(c).pmod     = LA.c_param{c};
end
jobs{1}.stats{1}.fmri_spec.sess(1).regress = LA.regress;

% factorial design?
jobs{1}.stats{1}.fmri_spec.fact = LA.fact;
spm_jobman('run',jobs);