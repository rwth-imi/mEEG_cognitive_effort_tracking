function [targets, pressed] = is_event_target_and_user_pressed_the_button_bool(EEG, c_type, c_subtype)
%is_event_target_and_user_pressed_the_button_bool.m returns a list of
% targets and epoch where the button has been pressed.
targets = zeros(1,1);
pressed = zeros(1,1);

% Set targets according to condition
if strcmp(c_subtype, "Condition 1")
    targets = getTargetsNBC1([EEG.urevent.type]);
elseif strcmp(c_subtype, "Condition 2")
    targets = getTargetsNBC2([EEG.urevent.type]);
elseif strcmp(c_subtype, "Condition 3")
    targets = getTargetsNBC3([EEG.urevent.type]);
end

if contains(c_subtype, "Condition")
    all_stimuli = getStimuli([EEG.urevent.type]);
    
    pressed = getTargetsClicked(all_stimuli, [EEG.urevent.type]);
    
    targets = getEpochNum(targets, [EEG.urevent.type]);
    
    pressed = getEpochNum(pressed, [EEG.urevent.type]);
    
end

    function selected_epochs = getEpochNum(targets, event_type)
        event_type(targets) = -1;
        stimuli = event_type(event_type < 1000);
        stimuli = stimuli < 0;
        selected_epochs = find(stimuli);
    end

    function targets_clicked = getTargetsClicked(targets, event_type)
        targets_clicked = zeros(1,1);
        c = 1;
        for target = targets
            if target+1 <= length(event_type) && event_type(target+1) == 1001
                targets_clicked(c) = target;
                c = c + 1;
            end
        end
    end

    function targets = getStimuli(event_type)
        targets = zeros(1,1);
        c = 1;
        for n = 1:length(event_type)
            if (event_type(n) < 1000)
                targets(c) = n;
                c = c + 1;
            end
        end
    end

    % Targets for N-Back Condition 1
    function targets = getTargetsNBC1(event_type)
        targets = zeros(1,1);
        c = 1;
        for n = 1:length(event_type)
            if (event_type(n) == 1)
                targets(c) = n;
                c = c + 1;
            end
        end
    end

    % Targets for N-Back Condition 2
    function targets = getTargetsNBC2(event_type)
        even_counter = 0;
        targets = zeros(1,1);
        c = 1;
        for n = 1:length(event_type)
            if (event_type(n) < 1000)
                if (mod(event_type(n), 2) == 0)
                    even_counter = even_counter + 1;
                else
                    even_counter = 0;
                end
                
                if (even_counter >= 3)
                    targets(c) = n;
                    c = c + 1;
                end
            end
        end
    end

    % Targets for N-Back Condition 3
    function targets = getTargetsNBC3(event_type)
        targets = zeros(1,1);
        c = 1;
        counter = 1;
        for n = 1:length(event_type)
            if (event_type(n) < 1000)
                % Find first number after the current one
                while (n + counter) <= length(event_type) && event_type(n + counter) >= 1000
                    counter = counter + 1;
                end
                if ((n + counter) <= length(event_type) && event_type(n + counter) < 1000)
                    counter = counter + 1;
                end
                % Find sescond number after the current one
                while (n + counter) <= length(event_type) && event_type(n + counter) >= 1000
                    counter = counter + 1;
                end
                % Check if 3rd number matches 1st number
                if (n + counter) <= length(event_type) && event_type(n + counter) == event_type(n)
                    targets(c) = n + counter;
                    c = c + 1;
                end
                counter = 1;
            end
        end
    end

end

