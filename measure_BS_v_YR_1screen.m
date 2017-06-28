% meas_trials = 5;
meas_positions_v = zeros(1,2*meas_trials);

% meas_stimRect = [0 0 10 10];

% flickFreq = 8;
% flickCol = [0 255];
%% instruct
flickInd = 0;

%% 
for mt = 1:2*meas_trials    
%     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    if mt <= meas_trials
       DrawFormattedText(window,'UPPER',500,400,white,[],[]);
    elseif mt == meas_trials+1
        DrawFormattedText(window,'LOWER',500,400,[1 0 0],[],[]);
    else
        DrawFormattedText(window,'LOWER',500,400,white,[],[]);
    end
%     Screen('SelectStereoDrawBuffer', window, 1);  %Right
%     if mt <= meas_trials
%         DrawFormattedText(window,'UPPER',500,400,white,[],1);
%     else
%         DrawFormattedText(window,'LOWER',500,400,white,[],1);
%     end
    vbl = Screen('Flip',window);
%     GetChar;
    vbl = Screen('Flip',window, vbl+2);
    lastFlick = vbl;
    buttons = zeros(size(buttons));
    
    while ~any(buttons)
       [keyIsDown, keyTime, keyCode] = KbCheck(-1);

        % Get mouse cursor coordinates.
       [mouseX, mouseY, buttons] = GetMouse(window);

       % Shift the grating by "shiftperframe" pixels per frame:
       %cycle through 3 directions (left, right, stationary)
       thisFlick = GetSecs;
       if thisFlick + ifi >= lastFlick + 1/flickFreq/2
           flickInd = mod(flickInd+1, 2);
           lastFlick = thisFlick;
       end

       % set target Rect to mouse coordinates
       if stereoMode == 10
          targetPoint = [BS_center_h, mouseY];
       else
          targetPoint = [BS_center_h, mouseY];
       end

       targetRect = CenterRectOnPoint(meas_stimRect, targetPoint(1), targetPoint(2));
       
%    Screen('TextSize', window, 20);
%            textString = ['Mouse at X pixel ' num2str(round(mouseX))...
%         ' and Y pixel ' num2str(round(mouseY))];
%      DrawFormattedText(window, textString, 'center', 'center', white);
     
     
       % FLIP 
       vbl = Screen('Flip', window);

       % Select left-eye image buffer for drawing:
%        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT

           % draw fixation dot 
%            Screen('CopyWindow', leftFixWin, window, [], windowRect);	  

           if isequal(bs_eye,'left')
               Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
               Screen('FillRect', window, flickCol(flickInd+1), targetRect);
           end
           
       % Select right-eye image buffer for drawing:
%        Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT

           % draw fixation dot 
%            Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);	  
           
           if isequal(bs_eye,'right')
               Screen('DrawText',window, '+', r_fix_cord1(1), r_fix_cord1(2)-8,white);
               Screen('FillRect', window, flickCol(flickInd+1), targetRect);
           end
           
%               Screen('TextSize', window, 20);
%            textString = ['Mouse at X pixel ' num2str(round(mouseX))...
%         ' and Y pixel ' num2str(round(mouseY))];
%      DrawFormattedText(window, textString, 'center', 'center', white);
        
     
     Screen('DrawingFinished',window);

       % Abort demo if any key is pressed:
       if keyCode(KbName('ESCAPE'))
           if togglegoggle == 1
               ToggleArd(ard,'AllOff')
               disp('Check goggles are off')
               ShutdownArd(ard,comPort);
               disp('Arduino is off')
               %            cls
           end
           sca
          break;
       end
    end
    vbl = Screen('Flip',window);
    meas_positions_v(mt) = targetPoint(2);
     raw_coords_v(mt) = mouseY;
end

%%
upper_v = meas_positions_v(1:meas_trials)
lower_v = meas_positions_v(meas_trials+1:end)
figure;
plot(1:meas_trials, upper_v, 1:meas_trials, lower_v);
BS_center_v = mean(meas_positions_v)
% in_deg_v = pix2deg_YR(BS_center_v-mean(fix_cord1))
BS_diameter_v = abs(mean(upper_v) - mean(lower_v))
in_deg_v = pix2deg_YR(BS_diameter_v)
title('vertical');








