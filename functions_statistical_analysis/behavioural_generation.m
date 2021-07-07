function [p_acc, p_sen, p_spe, bp_grouped_acc, bp_grouped_sen, bp_grouped_spe] = behavioural_generation(task, conditions, visualize)
var = globals();

if nargin < 6
    visualize = 'off';
end

%% Settings
num_patients = var.num_participants;
lims = [-inf, inf];
%lims = [26, 34]; % 25, 35 

tables = cell(size(conditions));
for n = 1:length(conditions)
    table_name = ['tb_', task{1}, '_', conditions{n}, '.mat'];
    tables{n} = table_name;
end

%
table = [];
for n = 1:length(tables)
    tb_buf = load(tables{n});
    tb_buf_c = struct2cell(tb_buf);
    tb_buf_ready = tb_buf_c{1} ;
    tb_buf_ready = tb_buf_ready(:,{'Patient_ID', 'Electrode_name', 'Band_name', 'Bandpower', 'Bandpower_full', 'Amplitude_max', 'Amplitude_min', 'Amplitude_mean', 'Amplitude_std', 'Event_Type', 'Is_target', 'Button_pressed', 'Reaction_time', 'Condition_type', 'Condition_subtype', 'Day', 'Q_min','Q_max','Q_mean', 'Uncorrupt_kurt', 'Uncorrupt_chan'});
    table = [table; tb_buf_ready];
end

table = prepare_behavioural(table, task);

[p_acc, p_sen, p_spe, bp_grouped_acc, bp_grouped_sen, bp_grouped_spe] = compute_accuracy(table, conditions, num_patients, visualize);
end