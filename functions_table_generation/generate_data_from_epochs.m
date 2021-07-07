function table_data = generate_data_from_epochs(EEG_file_path, task_type, condition_type)
%generate_data_from_epochs.m computes table data given certain EEG file and
% task- and condition-type.

%% Load globals
vars = globals();
stimuli_types = {1,2,3,4,5,6,7,8};
epoch_range = [-0.5 1.5]; % In seconds

num_bands = length(vars.band_names);
if strcmp(condition_type, 'Fixation cross')  % Check if fixation cross
    num_stimuli = 30;
else
    num_stimuli = 150;
end
length_table = vars.num_channels * num_bands * num_stimuli;
width_table = 23;

%% Load EEG data
% Original EEG file
EEG = pop_biosig(EEG_file_path);
% EEG file storing only impedance values
EEG_imp = pop_select(EEG, 'channel', vars.impedance_channels);
% Get Patient ID and day
[day, patient_index] = get_the_patient_index(EEG_file_path);
% Perform high and low pass filtering and normalization if wanted
EEG = preprocess(EEG);
electrode_names = {EEG.chanlocs.labels};

% Extract epochs with EEGLAB and add them as 3rd dimension
if contains(condition_type, "Condition")
    EEG = pop_epoch( EEG, stimuli_types, epoch_range, 'newname', 'EDF file epochs', 'epochinfo', 'yes');
    EEG_imp = pop_epoch( EEG_imp, stimuli_types, epoch_range, 'newname', 'EDF file epochs', 'epochinfo', 'yes');
else
    % If condition description is not "Condition..." but "Fixation cross"
    EEG = fake_epochs(EEG, 2);
    EEG_imp = fake_epochs(EEG_imp, 2);
end

% EEG = pop_rmbase( EEG, [-500 0] ,[]);

dim = size(EEG.data); % EEG.data = data array (chans x frames x epochs)
number_of_epochs = dim(3); % select epochs
epoched_data = zeros(length(electrode_names), length(vars.band_names), number_of_epochs);
epoched_data_rel = zeros(length(electrode_names), length(vars.band_names), number_of_epochs);
epoched_data_fft = zeros(length(electrode_names), length(vars.band_names), number_of_epochs);
epoched_data_rel_fft = zeros(length(electrode_names), length(vars.band_names), number_of_epochs);

table_data = table('Size',[length_table, width_table], ...
    'VariableTypes', ...
    {'single','string','string','double','double','double','double','double','double','double','double','single','logical','logical','double','string','string','single','single','single','single','logical','logical'}, ...
    'VariableNames', ...
    {'Patient_ID', 'Electrode_name', 'Band_name', 'Bandpower', 'Bandpower_full', 'Bandpower_fft', 'Bandpower_full_fft', 'Amplitude_max', 'Amplitude_min', 'Amplitude_mean', 'Amplitude_std', 'Event_Type', 'Is_target', 'Button_pressed', 'Reaction_time', 'Condition_type', 'Condition_subtype', 'Day', 'Q_min','Q_max','Q_mean', 'Uncorrupt_kurt', 'Uncorrupt_chan'});

iterator = 1;
% Must use separate for loop since if it this loop is inner one, 'generate_powerbands_for_feature gets called 14x4 times more'
target_bool_array = false(1,number_of_epochs);
user_pressed_button_array = false(1,number_of_epochs);
reaction_times = zeros(1,number_of_epochs);

if contains(condition_type, "Condition")
    [target_bool, user_pressed_button] = is_event_target_and_user_pressed_the_button_bool(EEG, task_type, condition_type);
    target_bool_array(target_bool) = true;
    user_pressed_button_array(user_pressed_button) = true;
end

% Getting for all the relevant epoched data per EEG file
% Note that here we don't use EEG with epochs generated from events, rather
% the prior no_filter_EEG one, since when epoching, eeglab 'messes up' the
% indexing of epochs (One epoch can have target and user pressed the button event within one epoch)
for epoch_idx = 1:number_of_epochs
    [epoched_data(:, :, epoch_idx), epoched_data_rel(:, :, epoch_idx), epoched_data_fft(:, :, epoch_idx), epoched_data_rel_fft(:, :, epoch_idx)] = generate_powerbands_for_feature(EEG, epoch_idx);
    if target_bool_array(epoch_idx) == true && user_pressed_button_array(epoch_idx) == true
        reaction_times(epoch_idx) = get_reaction_time(EEG, epoch_idx);
    end
end

% Check if channel would be corrupted according to eeglab - If after
% channel rejection procedure is still there we label it 1 for uncorrupt, 
% 0 for being corrupt
EEG_rej = EEG;
EEG_rej = pop_rejchan( EEG_rej, 'threshold', 5, 'norm', 'on', 'measure', 'kurt');

EEG_kurt = EEG;
if contains(condition_type, "Condition")
    EEG_kurt = pop_rejkurt(EEG_kurt,1,1:14 ,3,3,1,1,0,[],0);
end

% Fill table
for chan_idx = 1:length(electrode_names)
    
    electrode_name = electrode_names(chan_idx);
    uncorrupt = any(strcmp({EEG_rej.chanlocs.labels}, electrode_names(chan_idx)));
    uncorrupt_kurt = any(strcmp({EEG_kurt.chanlocs.labels}, electrode_names(chan_idx)));
    
    for epoch_idx = 1:number_of_epochs
        amplitude_rep = get_amplitude(EEG.data(chan_idx, :, epoch_idx));
        target_bool = target_bool_array(epoch_idx);
        user_pressed_button = user_pressed_button_array(epoch_idx);
        for band_idx = 1:length(vars.band_freq)
            
            value = epoched_data(chan_idx, band_idx, epoch_idx);
            value_rel = epoched_data_rel(chan_idx, band_idx, epoch_idx);
            value_fft = epoched_data_fft(chan_idx, band_idx, epoch_idx);
            value_rel_fft = epoched_data_rel_fft(chan_idx, band_idx, epoch_idx);
            band_name = vars.band_names(band_idx);
            
            table_data.Patient_ID(iterator) = patient_index;
            table_data.Electrode_name(iterator) = electrode_name;
            table_data.Band_name(iterator) = band_name;
            table_data.Bandpower(iterator) = value;
            table_data.Bandpower_full(iterator) = value_rel;
            table_data.Bandpower_fft(iterator) = value_fft;
            table_data.Bandpower_full_fft(iterator) = value_rel_fft;
            table_data.Amplitude_max(iterator) = amplitude_rep.max_eeg;
            table_data.Amplitude_min(iterator) = amplitude_rep.min_eeg;
            table_data.Amplitude_mean(iterator) = amplitude_rep.mean_eeg;
            table_data.Amplitude_std(iterator) = amplitude_rep.std_eeg;
            if contains(condition_type, "Condition")
                events = EEG.epoch(epoch_idx).eventtype;
                t_event = min(cell2mat(events));
                table_data.Event_Type(iterator) = t_event;
            else
                table_data.Event_Type(iterator) = 0;
            end
            table_data.Is_target(iterator) = target_bool;
            table_data.Button_pressed(iterator) = user_pressed_button;
            table_data.Reaction_time(iterator) = reaction_times(epoch_idx);
            table_data.Condition_type(iterator) = task_type;
            table_data.Condition_subtype(iterator) = condition_type;
            table_data.Day(iterator) = day;
            table_data.Q_min(iterator) = min(EEG_imp.data(chan_idx, : , epoch_idx));
            table_data.Q_max(iterator) = max(EEG_imp.data(chan_idx, : , epoch_idx));
            table_data.Q_mean(iterator) = mean(EEG_imp.data(chan_idx, : , epoch_idx));
            table_data.Uncorrupt_kurt(iterator) = uncorrupt_kurt;
            table_data.Uncorrupt_chan(iterator) = uncorrupt;
            iterator = iterator + 1;
        end
    end
end
fprintf('done');

end