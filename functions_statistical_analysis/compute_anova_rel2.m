function [p, bp_grouped] = compute_anova_rel2(table, band, chan, cond, num_patients, visualize)

if nargin < 6
    visualize = 'off';
end

num_days = 2;
num_c = length(cond);
bp_per_cond = cell(1,num_c);

e_idx = false(size(table,1),1);
for n = 1:length(chan)
    e_idx_c = strcmp(table.Electrode_name, chan{n});
    e_idx = e_idx | e_idx_c;
end

fc_idx = strcmp(table.Condition_subtype, 'Fixation cross');

for c = 1:num_c
    c_idx = strcmp(table.Condition_subtype, cond{c});
    iterator = 1;
    for day = 1:num_days
        d_idx = table.Day == day;
        for n = 1:num_patients
            p_idx = table.Patient_ID == n;
            
            b_idx = strcmp(table.Band_name, band);
            b_idx = b_idx & e_idx & c_idx & p_idx & d_idx;
            f_idx = strcmp(table.Band_name, 'full');
            f_idx = f_idx & e_idx & fc_idx & p_idx & d_idx;
            
            bp_per_cond{1,c}(iterator,1) = mean(table.Bandpower(b_idx,:)) / mean(table.Bandpower(f_idx,:));
            iterator = iterator + 1;
        end
    end
end

bp_grouped = cell2mat(bp_per_cond);

p = anova1(bp_grouped,cond,visualize);

end