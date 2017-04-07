function fmri = create_fakedata(epiDir,nscan)

fmri = spm_select('FPList', epiDir,'s6wrafake.nii'); % spm_selct('FPList....)
fmri = get_filepath(fmri,nscan);