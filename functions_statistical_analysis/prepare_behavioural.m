function table = prepare_behavioural(table, task)
% Select one channel and one band
s_idx = strcmp(table.Electrode_name, 'F3');
s_idx = s_idx & strcmp(table.Band_name, 'alpha');
table = table(s_idx,:);
% N-Back task
n_back_idx = strcmp(table.Condition_type, task);
table = table(n_back_idx,:);
% Target stimulus
event_idx = table.Event_Type < 1000;
table = table(event_idx,:);

end

