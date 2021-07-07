function [p, d_left, bp_grouped] = anova_generation(area_name, band, max_amp, min_q, task, conditions, visualize, type)
var = globals();

%% Settings
num_patients = var.num_participants;

% Load tables
tables = cell(size(conditions));
for n = 1:length(conditions)
    table_name = ['tb_', task{1}, '_', conditions{n}, '.mat'];
    tables{n} = table_name;
end

% Reduce relevant table data to a single table
table = [];
for n = 1:length(tables)
    tb_buf = load(tables{n});
    tb_buf_c = struct2cell(tb_buf);
    tb_buf_ready = tb_buf_c{1} ;
    tb_buf_ready = tb_buf_ready(:,{'Patient_ID', 'Electrode_name', 'Band_name', 'Bandpower', 'Bandpower_full', 'Amplitude_max', 'Amplitude_min', 'Amplitude_mean', 'Amplitude_std', 'Event_Type', 'Is_target', 'Button_pressed', 'Reaction_time', 'Condition_type', 'Condition_subtype', 'Day', 'Q_min','Q_max','Q_mean', 'Uncorrupt_kurt', 'Uncorrupt_chan'});
    table = [table; tb_buf_ready];
end

% Perform pre-processing befora Anova
[table, d_left] = prepare_anova(table, task, conditions, max_amp, min_q, false);

% Prepare data for Anova and perform computation depending on the scaling
% type
if strcmp(type, 'rel') || strcmp(type, 'rel1') 
    % 'rel1' -> normalized by the averaged full band (1-40 Hz) power during
    % the same condition
    [p, bp_grouped] = compute_anova_rel(table, band, area_name, conditions, num_patients, visualize);
elseif strcmp(type, 'rel2')
    % 'rel2' -> normalized by the averaged full band (1-40 Hz) power during
    % the baseline condition c0
    [p, bp_grouped] = compute_anova_rel2(table, band, area_name, conditions, num_patients, visualize);
elseif strcmp(type, 'rt')
    % 'rt' -> Reaction time, no averaging steps performed, since signal
    % amplitudes are not analyzed
    [p, bp_grouped] = compute_anova_rt(table, band, area_name, conditions, num_patients, visualize);
else
    % No normalization
    [p, bp_grouped] = compute_anova(table, band, area_name, conditions, num_patients, visualize);
end

end