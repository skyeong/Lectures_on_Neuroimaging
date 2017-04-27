function T = extract_onset_info(T)

nevt = size(T);
trial_type = T.trial_type;
Concreteness = cell(0);
Repetition = cell(0);
for i=1:nevt
    tmpstr = strsplit(trial_type{i},'-');
    Concreteness{i} = tmpstr{3};
    Repetition{i} = tmpstr{4};
end

T.Concreteness = [Concreteness'];
T.Repetition = [Repetition'];