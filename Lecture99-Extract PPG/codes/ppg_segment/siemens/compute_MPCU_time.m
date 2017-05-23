function MPCU = compute_MPCU_time(AcquisitionTime)

I = floor(AcquisitionTime);
F = AcquisitionTime-floor(AcquisitionTime);

HH = floor(I/10000);
MM = floor((I - HH*10000)/100);
SS = (I - HH*10000 - MM*100);

MPCU = (HH+12) * 60 * 60 * 1000;
MPCU = MM * 60 * 1000 + MPCU;
MPCU = SS * 1000 + MPCU;
MPCU = F * 1000 + MPCU;
MPCU = round(MPCU);

% The two example time formats can be shown to be equivalent:
%
% 37747165 = (10 hours * 60 mins/hour * 60 secs/min * 1000 msecs/sec) +
%            (29 mins  * 60 * 1000) +
%            (07 secs  * 1000) +
%            (1650 ticks / 10 ticks/msec)

