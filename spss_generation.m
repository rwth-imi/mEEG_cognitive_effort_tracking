%% Get globals
var = globals();

%% Settings
areas = var.areas;
area_names = var.area_names;
band_names = var.band_names;

max_amp = 1500; % []
min_q = 100; % []

task = var.task_types(1); % N-Back
conditions = var.condition_types(1:end); % or 2:end
if length(conditions) == 4
    condition_names = 'c0-c1-c2-c3';
else
    condition_names = 'c1-c2-c3';
end

spss_folder = 'spss/';
if ~exist(spss_folder, 'dir')
    mkdir(spss_folder)
end
if ~exist([spss_folder, '/mat'], 'dir')
    mkdir([spss_folder, '/mat'])
end
if ~exist([spss_folder, '/csv'], 'dir')
    mkdir([spss_folder, '/csv'])
end

%% Loop
for area_counter = 1:length(areas)
   for band_counter = 1:length(band_names)
      [p, data_left, bp_grouped] = anova_generation(areas{area_counter}, band_names{band_counter}, max_amp, min_q, task, conditions, 'off', 'rel2');
      save_name_mat = [spss_folder, 'mat/', condition_names, '_', area_names{area_counter}, '_', band_names{band_counter}, '_', 'relative2'];
      save_name_csv = [spss_folder, 'csv/', condition_names, '_', area_names{area_counter}, '_', band_names{band_counter}, '_', 'relative2'];
      save([save_name_mat, '.mat'], 'bp_grouped');
      save([save_name_mat, '_data_left.mat'], 'data_left');
      csvwrite([save_name_csv, '.csv'], bp_grouped);
   end
end