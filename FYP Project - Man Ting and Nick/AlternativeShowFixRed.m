if strcmp(bs_eye,'right')
    Screen('TextSize', window, 30); %40 for MRI, 20 is fine for behavioural
%     Screen('DrawFormattedText',window, '+', r_fix_cord1(1), yCenter,white);
    [nx, ny] = DrawFormattedText(window, 'x', r_fix_cord1(1), 'center', [1 1 1]);
else %left eye BS, fix on RIGHT side
    Screen('TextSize', window, 30);
    [nx, ny] = DrawFormattedText(window, 'x', l_fix_cord1(1), 'center', [1 1 1]);
%     Screen('DrawFormattedText',window, '+', l_fix_cord1(1), yCenter,white);
end