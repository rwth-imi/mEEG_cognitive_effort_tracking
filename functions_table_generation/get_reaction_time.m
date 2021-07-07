function reaction_time = get_reaction_time(EEG, epoch_idx)
%get_reaction_time.m computes the reaction time given the epoch index.
idx = [EEG.event.epoch] == epoch_idx;
cur_epoch = EEG.event(idx);

stimulus_idx = find([cur_epoch.type] < 1000, 1);
stimulus_ur_idx = cur_epoch(stimulus_idx).urevent;

stimulus_time = EEG.urevent(stimulus_ur_idx).latency;

cur_epoch_new = EEG.urevent(stimulus_ur_idx:end);

response_idx = find([cur_epoch_new.type] == 1001, 1);
response_time = cur_epoch_new(response_idx).latency;

reaction_time = ((response_time - stimulus_time) / 128) * 1000;

end

