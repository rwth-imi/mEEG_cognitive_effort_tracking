function [day, index] = get_the_patient_index(EEG_file_path)
%get_the_patient_index.m extracts the patient index for numbering from the
% file name.
%index: index of a patient given a EEG_file_path
start_index = regexp(EEG_file_path, 'T[12]'); % Search for T1 or T2
day = str2num(EEG_file_path(start_index+1));
% Get the index where file extenstion starts
start_index = regexp(EEG_file_path, '.edf'); 
% Index number is right-most in file name
index = str2num(EEG_file_path(start_index-2:start_index-1)); 

end

