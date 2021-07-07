%% Get globals
var = globals();

%% Settings
areas = var.areas;
band_names = var.band_names;

max_amp = [];
min_q = [];

task = var.task_types(1); % N-Back
conditions = var.condition_types(1:end);

%% Loop
for area_counter = 1:length(areas)
   for band_counter = 1:length(band_names)
      [p, data_left, bp_grouped] = anova_generation(areas{area_counter}, band_names{band_counter}, max_amp, min_q, task, conditions, 'off', 'rel2'); 
   end
end