function trimmed_files = find_all_files_for_condition(files, condition_string_1, condition_string_2)
%find_all_files_for_condition.m returns the list of files for he given 
% condition names.
% trimmed files: files where the certain condition is met, for instance
% getting the 'Condition 2' files:
% condition_string_1 is precise name of condition (Condition 1/ Condition 2..)
% condition_string_2 is choice between 'Go-Nogo' and 'N-Back'
% It is being used for faster processing of directories and subdirectories.

corresponding_idxs = zeros(length(files),1);

for idx = 1:length(files)
    if(contains({files{idx}},condition_string_1,'IgnoreCase',true) && contains({files{idx}}, condition_string_2, 'IgnoreCase',true)) %
        corresponding_idxs(idx) = 1;
    end
end

A = find(corresponding_idxs);
files = string(files);
trimmed_files = files(A);

