if strcmp(bs_eye,'right')
   Screen('DrawTexture', window, fixA(2), [], [], 0); %Draw
%     [nx, ny] = DrawFormattedText(window, '+', r_fix_cord1(1), 'center', [1 0 0]);
else %left eye BS, fix on RIGHT side
%     Screen('TextSize', window, 20);
    Screen('DrawTexture', window, fixA(2), [], [], 0); %Draw
%     [nx, ny] = DrawFormattedText(window, '+', l_fix_cord1(1), 'center', [1 0 0]);
%     Screen('DrawFormattedText',window, '+', l_fix_cord1(1), yCenter,white);
end