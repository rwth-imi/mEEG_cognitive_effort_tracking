function table_generation(condition_types)
%table_generation.m generates the full table of EEG data for the dataset in
% globals and the condition that is passed as an argument.

%% Settings
vars = globals(); % Inititallize global variables
files = get_all_files(vars.real_data_dir); % filelist of all files in a dir

%% Pre-computation
num_conditions = length(vars.task_types) * length(condition_types);
num_channels = length(vars.electrode_names);
num_bands = length(vars.band_names);
if strcmp(condition_types{1}, 'Fixation cross') % Check if fixation cross
    num_stimuli = 30;
else
    num_stimuli = 150;
end
% #participants * #days * #conditions * #electrodes * #bands * #stimuli
length_table = vars.num_participants * vars.num_days * num_conditions * num_channels * num_bands * num_stimuli;
width_table = 23;
length_per_file = num_channels * num_bands * num_stimuli;

% Define table
tb = table('Size',[length_table, width_table], ...
    'VariableTypes', ...
    {'single','string','string','double','double','double','double','double','double','double','double','single','logical','logical','double','string','string','single','single','single','single','logical','logical'}, ...
    'VariableNames', ...
    {'Patient_ID', 'Electrode_name', 'Band_name', 'Bandpower', 'Bandpower_full', 'Bandpower_fft', 'Bandpower_full_fft', 'Amplitude_max', 'Amplitude_min', 'Amplitude_mean', 'Amplitude_std', 'Event_Type', 'Is_target', 'Button_pressed', 'Reaction_time', 'Condition_type', 'Condition_subtype', 'Day', 'Q_min','Q_max','Q_mean', 'Uncorrupt_kurt', 'Uncorrupt_chan'});


%% Loop
iterator = 1;

% Iterate over task type
for condition_type_idx = 1:length(vars.task_types)
    % Iterate over conditions
    for condition_subtype_idx = 1:length(condition_types)
        % Get all files for current condition
        condition_files = find_all_files_for_condition(files, vars.task_types{condition_type_idx}, condition_types{condition_subtype_idx});% find files based on name
        for file_idx = 1: length(condition_files)
            fprintf("%d / %d - subtype: %d, type %d  ---- > %s", file_idx, length(condition_files), condition_subtype_idx, condition_type_idx, condition_files{file_idx});
            % Generate table data
            tb((iterator-1)*length_per_file+1:iterator*length_per_file,:) = generate_data_from_epochs(condition_files{file_idx}, vars.task_types{condition_type_idx}, condition_types{condition_subtype_idx});
            iterator = iterator + 1;
        end
    end
end

%% Store generated table
save(['tb_', vars.task_types{1}, '_', condition_types{1}, '.mat'], 'tb');

end