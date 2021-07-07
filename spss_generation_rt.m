%% Get globals
var = globals();

%% Settings
areas = {{'F3'}};
band_names = {'alpha'};

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
for area_counter = 1:length(areas)
   for band_counter = 1:length(band_names)
      [p, data_left, bp_grouped] = anova_generation(areas{area_counter}, band_names{band_counter}, max_amp, min_q, task, conditions, 'on', 'rt');
      save_name_mat = [spss_folder, 'mat/', condition_names, '_', 'reaction-times'];
      save_name_csv = [spss_folder, 'csv/', condition_names, '_', 'reaction-times'];
      save([save_name_mat, '.mat'], 'bp_grouped');
      csvwrite([save_name_csv, '.csv'], bp_grouped);
   end
end