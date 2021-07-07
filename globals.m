function var = globals()
%% General settings
% Data directory
var.real_data_dir = 'Path\To\Data';

%% Device settings
% Sampling rate in Hz
var.sampling_rate = 128;
% Electrode names
var.electrode_names = {'F3','FC5','AF3','F7','T7','P7','O1','O2','P8','T8','F8','AF4','FC6','F4'};
var.impedance_channels = {'F3_q' 'FC5_q' 'AF3_q' 'F7_q' 'T7_q' 'P7_q' 'O1_q' 'O2_q' 'P8_q' 'T8_q' 'F8_q' 'AF4_q' 'FC6_q' 'F4_q'};
var.num_channels = length(var.electrode_names);
var.areas = {{'F3','FC5','AF3','F7','F8','AF4','FC6','F4'},{'P7','P8'},{'O1','O2'},{'T7'},{'T8'}};
var.area_names = {'frontal', 'parietal', 'occipital', 'left-temporal', 'right-temporal'};
% Band names
var.band_names = {'delta', 'theta', 'alpha', 'beta', 'full'};
% Band frequencies
var.band_freq = [1 3.5; 3.5 7.5; 7.5 12.5; 12.5 30; 1 40];
% Task types
var.task_types = {'N-Back'}; % {'N-Back', 'Go-Nogo'};
% Condition types
var.condition_types = {'Fixation cross', 'Condition 1', 'Condition 2', 'Condition 3'};
% Participants
var.participants = 1:24; %[1,3:25];
% Number of participants
var.num_participants = length(var.participants);
% Number of days
var.num_days = 2;

%% Stimuli
% Number of target stimuli per file
var.num_target_stimuli = 150;
% Number of fake stimuli per file (Fixation cross)
var.num_fake_stimuli = 30;

end