meas_trials = 5;
meas_positions_h = zeros(1,2*meas_trials);

meas_stimRect = [0 0 5 5]; %was originally 10 but might be too big...

SetMouse(xCenter,yCenter, window);

flickFreq = 4;
flickCol = [0 255];
%% instruct
flickInd = 0;

%% 
for mt = 1:2*meas_trials    
%     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    if mt <= meas_trials
        DrawFormattedText(window,'INNER',500,400,white,[],1);
    else
        DrawFormattedText(window,'OUTER',500,400,white,[],1);
    end
%     Screen('SelectStereoDrawBuffer', window, 1);  %Right
%     if mt <= meas_trials
%         DrawFormattedText(window,'INNER',500,400,white,[],1);
%     else
%         DrawFormattedText(window,'OUTER',500,400,white,[],1);
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

%        Screen('TextSize', window, 20);
%        textString = ['Mouse at X pixel ' num2str(round(mouseX))...
%         ' and Y pixel ' num2str(round(mouseY))];
%      DrawFormattedText(window, textString, 'center', 470, white);
%       Screen('Flip', window);
       
       % Shift the grating by "shiftperframe" pixels per frame:
       %cycle through 3 directions (left, right, stationary)
       thisFlick = GetSecs;
       if thisFlick + ifi >= lastFlick + 1/flickFreq/2
           flickInd = mod(flickInd+1, 2);
           lastFlick = thisFlick;
       end

       % set target Rect to mouse coordinates
%        targetPoint = [windowRect(3)-mouseX, windowRect(4)/2];
        targetPoint = [mouseX, windowRect(4)/2];
       targetRect = CenterRectOnPoint(meas_stimRect, targetPoint(1), targetPoint(2));
       

       % FLIP 
       vbl = Screen('Flip', window);

       % Select left-eye image buffer for drawing:
%        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT

           % draw fixation dot 
           Screen('CopyWindow', leftFixWin, window, [], windowRect);	  

           if isequal(bs_eye,'left')
                % draw fixation dot 
               Screen('CopyWindow', leftFixWin, window, [], windowRect);
               Screen('FillRect', window, flickCol(flickInd+1), targetRect);
          
           end
           
%        % Select right-eye image buffer for drawing:
%        Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT

           % draw fixation dot 
%            Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);	  
           
           if isequal(bs_eye,'right')
                % draw fixation dot 
               Screen('CopyWindow', leftFixWin, window, [], windowRect);
               Screen('FillRect', window, flickCol(flickInd+1), targetRect);
           end
           Screen('TextSize', window, 20);
           textString = ['Mouse at X pixel ' num2str(round(mouseX))...
        ' and Y pixel ' num2str(round(mouseY))];
     DrawFormattedText(window, textString, 'center', 470, white);
           
        Screen('DrawingFinished',window);

       % Abort demo if any key is pressed:
       if keyCode(KbName('ESCAPE'))
          cls
          break;
       end
      
    end
    vbl = Screen('Flip',window);
    meas_positions_h(mt) = targetPoint(1);
    raw_coords_h(mt) = mouseX;
end;

%%
inner_h = meas_positions_h(1:meas_trials);
outer_h = meas_positions_h(meas_trials+1:end);
figure;
plot(1:meas_trials, inner_h, 1:meas_trials, outer_h);
BS_center_h = mean(meas_positions_h)
%mean(fix_cord1) is probably a BUG because it has both x and y coordinates
in_deg_h = pix2deg_YR(BS_center_h-mean(fix_cord1))
BS_diameter_h = abs(mean(inner_h) - mean(outer_h))
in_deg_h = pix2deg_YR(BS_diameter_h)
title('horizontal');








