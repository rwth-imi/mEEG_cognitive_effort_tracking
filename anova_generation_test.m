%% Get globals
var = globals();

%% Settings
areas = var.areas;
band_names = var.band_names;

max_amp = [];
min_q = [];

task = var.task_types(1); % N-Back
conditions = var.condition_types(1:end);


[p, data_left, bp_grouped] = anova_generation(areas{1}, band_names{1}, max_amp, min_q, task, conditions, 'off', 'rel2'); 