function EEG = fake_epochs(EEG, epoch_size)
%fake_epochs.m generates epochs that are not bound to stimuli. Instead the
% original signal is equally divided into frames of size epoch_size. 
vars = globals();
srate = vars.sampling_rate;
epoch_size = epoch_size * srate; % Sample size of one epoch frame
eeg_size_original = srate * 60;
eeg_size = floor (eeg_size_original / epoch_size); % Number of epochs
num_chans = size(EEG.data,1);

% Prepare the new 3-dimensionional data array
EEG_data = zeros(num_chans, epoch_size, eeg_size);

for epoch_counter = 1:eeg_size
    chan_data = EEG.data(:,(epoch_counter-1)*epoch_size+1:epoch_counter*epoch_size);
    EEG_data(:,:,epoch_counter) = chan_data; % Add epoch data as 3rd dimension 
end

EEG.data = EEG_data;

end

