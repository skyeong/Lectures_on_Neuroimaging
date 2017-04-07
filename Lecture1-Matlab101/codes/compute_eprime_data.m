function RT = compute_eprime_data(Eprime)

nevts = length(Eprime.RT);

% Initialize struct
RT = struct();

for i=1:nevts,
      
    % Get event type
    evtType = Eprime.evtType{i}(end);
    
    % First try commands. If tailed, run commands in 'catch'
    try
        RT.(evtType)   = [RT.(evtType); Eprime.RT(i)];
    catch
        RT.(evtType)   = Eprime.RT(i);
    end
end
