if strcmp(bs_eye,'right')
    Screen('TextSize', window, 40); %40 for MRI, 20 is fine for behavioural
%     Screen('DrawFormattedText',window, '+', r_fix_cord1(1), yCenter,white);
    [nx, ny] = DrawFormattedText(window, '+', r_fix_cord1(1), 'center', [1 0 0]);
else %left eye BS, fix on RIGHT side
    Screen('TextSize', window, 40);
    [nx, ny] = DrawFormattedText(window, '+', l_fix_cord1(1), 'center', [1 0 0]);
%     Screen('DrawFormattedText',window, '+', l_fix_cord1(1), yCenter,white);
end