function [p_acc, p_sen, p_spe, bp_grouped_acc, bp_grouped_sen, bp_grouped_spe] = compute_accuracy(table, cond, num_patients, visualize)

if nargin < 4
    visualize = 'off';
end

num_days = 2;
num_c = length(cond);
bp_per_cond_acc = cell(1,num_c);
bp_per_cond_sen = cell(1,num_c);
bp_per_cond_spe = cell(1,num_c);

for c = 1:num_c
    c_idx = strcmp(table.Condition_subtype, cond{c});
    iterator = 1;
    for n = 1:num_patients
        p_idx = table.Patient_ID == n;
        for day = 1:num_days
            d_idx = table.Day == day;
            s_idx = c_idx & p_idx & d_idx;
            
            subtable = table(s_idx,:);
            correct_responses = subtable.Is_target == subtable.Button_pressed;
            
            t_idx = subtable.Is_target == 1;
            subtable_targets = subtable(t_idx, :);
            correct_responses_targets = subtable_targets.Button_pressed == 1;
            
            t_idx = subtable.Is_target == 0;
            subtable_nontargets = subtable(t_idx, :);
            correct_responses_nontargets = subtable_nontargets.Button_pressed == 0;
            
            bp_per_cond_acc{1,c}(iterator,1) = mean(correct_responses);
            bp_per_cond_sen{1,c}(iterator,1) = mean(correct_responses_targets);
            bp_per_cond_spe{1,c}(iterator,1) = mean(correct_responses_nontargets);
            iterator = iterator + 1;
        end
    end
end

bp_grouped_acc = cell2mat(bp_per_cond_acc);
p_acc = anova1(bp_grouped_acc,cond,visualize);
bp_grouped_sen = cell2mat(bp_per_cond_sen);
p_sen = anova1(bp_grouped_sen,cond,visualize);
bp_grouped_spe = cell2mat(bp_per_cond_spe);
p_spe = anova1(bp_grouped_spe,cond,visualize);

end