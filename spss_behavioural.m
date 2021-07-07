%% Get globals
var = globals();

max_amp = [];
min_q = [];

task = var.task_types(1); % N-Back
conditions = var.condition_types(2:end); % c1-c3
if length(conditions) == 4
    condition_names = 'c0-c1-c2-c3';
else
    condition_names = 'c1-c2-c3';
end

spss_folder = 'spss/';

%% Loop
[p_acc, p_sen, p_spe, bp_grouped_acc, bp_grouped_sen, bp_grouped_spe] = behavioural_generation(task, conditions, 'on');

save_name_mat = [spss_folder, 'mat/', condition_names, '_', 'accuracy'];
save_name_csv = [spss_folder, 'csv/', condition_names, '_', 'accuracy'];
save([save_name_mat, '.mat'], 'bp_grouped_acc');
csvwrite([save_name_csv, '.csv'], bp_grouped_acc);

save_name_mat = [spss_folder, 'mat/', condition_names, '_', 'sensitivity'];
save_name_csv = [spss_folder, 'csv/', condition_names, '_', 'sensitivity'];
save([save_name_mat, '.mat'], 'bp_grouped_sen');
csvwrite([save_name_csv, '.csv'], bp_grouped_sen);

save_name_mat = [spss_folder, 'mat/', condition_names, '_', 'specificity'];
save_name_csv = [spss_folder, 'csv/', condition_names, '_', 'specificity'];
save([save_name_mat, '.mat'], 'bp_grouped_spe');
csvwrite([save_name_csv, '.csv'], bp_grouped_spe);