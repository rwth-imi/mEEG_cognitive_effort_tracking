function [p, bp_grouped] = compute_anova(table, band, chan, cond, num_patients, visualize)

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
table = table(e_idx,:);
for c = 1:num_c
    c_idx = strcmp(table.Condition_subtype, cond{c});
    subtable = table(c_idx,:);
    iterator = 1;
    for day = 1:num_days
        d_idx = subtable.Day == day;
        subtable2 = subtable(d_idx,:);
        for n = 1:num_patients
            p_idx = subtable2.Patient_ID == n;
            subtable3 = subtable2(p_idx,:);
            
            b_idx = strcmp(subtable3.Band_name, band);
            subtable_b = subtable3(b_idx,:);
            
            bp_per_cond{1,c}(iterator,1) = mean(subtable_b.Bandpower);
            iterator = iterator + 1;
        end
    end
end

bp_grouped = cell2mat(bp_per_cond);

p = anova1(bp_grouped,cond,visualize);

end