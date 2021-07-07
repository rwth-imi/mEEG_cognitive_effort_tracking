function amplitude_rep = get_amplitude(eeg_epoched_signal_vector)
%get_amplitude.m returns a struct holding max, min, mean, std etc.
% of the amplitude values in the vector passed as argument.
amplitude_rep = struct;

amplitude_rep.max_eeg = max(eeg_epoched_signal_vector);
amplitude_rep.min_eeg = min(eeg_epoched_signal_vector);
amplitude_rep.mean_eeg = mean(eeg_epoched_signal_vector);
amplitude_rep.var_eeg = var(eeg_epoched_signal_vector);
amplitude_rep.median_eeg = median(eeg_epoched_signal_vector);
amplitude_rep.std_eeg = std(eeg_epoched_signal_vector);

end
    








