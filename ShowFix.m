% Displays fixation cross

% Yulia Revina 2017

if strcmp(bs_eye,'right')
    Screen('TextSize', window, 20);
    Screen('DrawText',window, '+', r_fix_cord1(1), yCenter,white);
else %left eye BS, fix on RIGHT side
    Screen('TextSize', window, 20);
    Screen('DrawText',window, '+', l_fix_cord1(1), yCenter,white);
end
