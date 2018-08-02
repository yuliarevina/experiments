% Displays fixation cross

% Yulia Revina 2017

if strcmp(bs_eye,'right')
    Screen('TextSize', window, 40);
%     Screen('DrawFormattedText',window, '+', r_fix_cord1(1), yCenter,white);
    [nx, ny] = DrawFormattedText(window, '+', r_fix_cord1(1), 'center', white);
else %left eye BS, fix on RIGHT side
    Screen('TextSize', window, 40);
    [nx, ny] = DrawFormattedText(window, '+', l_fix_cord1(1), 'center', white);
%     Screen('DrawFormattedText',window, '+', l_fix_cord1(1), yCenter,white);
end
