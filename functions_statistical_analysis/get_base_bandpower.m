function bp = get_base_bandpower(table, band, chan)
if iscell(chan)
    e_idx = false(size(table,1), 1);
    for n = 1:length(chan)
        e_idx = e_idx | strcmp(table.Electrode_name, chan{n});
    end
else
    e_idx = strcmp(table.Electrode_name, chan);
end
table = table(e_idx,:);
b_idx = strcmp(table.Band_name, band);
table = table(b_idx,:);
c_idx = strcmp(table.Condition_subtype, 'Condition 1');
table = table(c_idx,:);

bp = mean(table.Bandpower_full);
end

