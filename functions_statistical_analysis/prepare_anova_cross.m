function [table, data_left] = prepare_anova_cross(table, task, max_amp, min_q, corrupt_check)
if nargin < 5
    corrupt_check = true;
end

% Target and button pressed
% target_idx = table.Is_target == 1 & table.Button_pressed == 1;
% table = table(target_idx,:);
% N-Back task
n_back_idx = strcmp(table.Condition_type, task);
table = table(n_back_idx,:);
% Target stimulus
event_idx = table.Event_Type < 1000;
table = table(event_idx,:);

tb_size = size(table,1);

% No corrupt channel
if corrupt_check
    corr_idx = table.Uncorrupt_kurt == 1; % & table.Uncorrupt_chan == 1;
    table = table(corr_idx,:);
end
% Filter by min and max amplitude
amp_idx = table.Amplitude_max <= max_amp; % 10, 3
table = table(amp_idx,:);
amp_idx = table.Amplitude_min >= -max_amp; % 10, 3
table = table(amp_idx,:);
% Filter by quality channel
q_idx = table.Q_mean >= min_q; % 10, 3
table = table(q_idx,:);

tb_size_new = size(table,1);

data_left = tb_size_new / tb_size;

end

