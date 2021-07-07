function EEG = preprocess(EEG)
%preprocess.m Performs filtering on the passed EEG.
%EEGLAB, afterwards, signal is being filtered to [1 40] range

vars = globals();
EEG = pop_select( EEG, 'channel', vars.electrode_names);

% Adding channel locations for topoplots
EEG = pop_chanedit(EEG, 'lookup', 'Standard-10-5-Cap385.sfp');
% Highpass and lowpass filtering
EEG = pop_eegfilt( EEG, 1, 40, [], [0], 0, 0, 'fir1', 0);

end

