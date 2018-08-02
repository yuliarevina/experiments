if strcmp(bs_eye,'right')
    Screen('TextSize', window, 20);
%     Screen('DrawFormattedText',window, '+', r_fix_cord1(1), yCenter,white);
    [nx, ny] = DrawFormattedText(window, '+', r_fix_cord1(1), 'center', black);
else %left eye BS, fix on RIGHT side
    Screen('TextSize', window, 20);
    [nx, ny] = DrawFormattedText(window, '+', l_fix_cord1(1), 'center', black);
%     Screen('DrawFormattedText',window, '+', l_fix_cord1(1), yCenter,white);
end