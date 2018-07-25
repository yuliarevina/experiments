% meas_trials = 5;
meas_positions_v = zeros(1,2*meas_trials);

% meas_stimRect = [0 0 10 10];

% flickFreq = 8;
% flickCol = [0 255];
%% instruct
flickInd = 0;

%% 
for mt = 1:2*meas_trials    
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    % draw fixation dot
    Screen('CopyWindow', leftFixWin, window, [], windowRect);
    if mt <= meas_trials
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'UPPER',nx,'center',black,[],1);
    elseif mt == meas_trials+1
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'LOWER',nx,'center',[1 0 0],[],1);
    else
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'LOWER',nx,'center',black,[],1);
    end
    
    Screen('SelectStereoDrawBuffer', window, 1);  %Right
    % draw fixation dot
    Screen('CopyWindow', rightFixWin, window, [], windowRect);
    if mt <= meas_trials
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'UPPER',nx,'center',black,[],1);
    elseif mt == meas_trials+1
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'LOWER',nx,'center',[1 0 0],[],1);
    else
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'LOWER',nx,'center',black,[],1);
    end
           
           
           
           
           
%     if mt <= meas_trials
%         DrawFormattedText(window,'UPPER',500,400,white,[],1);
%     else
%         DrawFormattedText(window,'LOWER',500,400,white,[],1);
%     end
    vbl = Screen('Flip',window);
    %     GetChar;
    
    
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    % draw fixation dot
    Screen('CopyWindow', leftFixWin, window, [], windowRect);
    
    Screen('SelectStereoDrawBuffer', window, 1);  %Right
    % draw fixation dot
    Screen('CopyWindow', rightFixWin, window, [], windowRect);

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
           if isequal(bs_eye,'left')
               targetPoint = [BS_center_h_l, mouseY];
           else
               targetPoint = [BS_center_h_r, mouseY];
           end
       else %not stereo 10
          if isequal(bs_eye,'left')
               targetPoint = [BS_center_h_l, mouseY];
           else
               targetPoint = [BS_center_h_r, mouseY];
           end
       end

       targetRect = CenterRectOnPoint(meas_stimRect, targetPoint(1), targetPoint(2));
       
%    Screen('TextSize', window, 20);
%            textString = ['Mouse at X pixel ' num2str(round(mouseX))...
%         ' and Y pixel ' num2str(round(mouseY))];
%      DrawFormattedText(window, textString, 'center', 'center', white);
     
     
       

       % Select left-eye image buffer for drawing:
       Screen('SelectStereoDrawBuffer', window, 0);  %LEFT

           % draw fixation dot 
           Screen('CopyWindow', leftFixWin, window, [], windowRect);	  ShowFix()
            ShowFix()

           if isequal(bs_eye,'left')
%                ShowFix()
%                Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,black);
               Screen('FillRect', window, flickCol(flickInd+1), targetRect);
           end
           
       % Select right-eye image buffer for drawing:
       Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
       

           % draw fixation dot 
           Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);	  
            ShowFix()
           if isequal(bs_eye,'right')
%                ShowFix()
%                Screen('DrawText',window, '+', r_fix_cord1(1), r_fix_cord1(2)-8,black);
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
       % FLIP
       vbl = Screen('Flip', window);
    end
     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    % draw fixation dot
    Screen('CopyWindow', leftFixWin, window, [], windowRect);

    Screen('SelectStereoDrawBuffer', window, 1);  %Right
    % draw fixation dot
    Screen('CopyWindow', rightFixWin, window, [], windowRect);
    vbl = Screen('Flip',window);
    meas_positions_v(mt) = targetPoint(2);
     raw_coords_v(mt) = mouseY;
end

%% save data
if isequal(bs_eye,'left')
    upper_v_l = meas_positions_v(1:meas_trials)
    lower_v_l = meas_positions_v(meas_trials+1:end)
    figure;
    plot(1:meas_trials, upper_v_l, 1:meas_trials, lower_v_l);
    BS_center_v_l = mean(meas_positions_v)
    % in_deg_v = pix2deg_YR(BS_center_v-mean(fix_cord1))
    BS_diameter_v_l = abs(mean(upper_v_l) - mean(lower_v_l))
    in_deg_v_l = pix2deg_YR(BS_diameter_v_l)
    title('vertical Left');
else
    upper_v_r = meas_positions_v(1:meas_trials)
    lower_v_r = meas_positions_v(meas_trials+1:end)
    figure;
    plot(1:meas_trials, upper_v_r, 1:meas_trials, lower_v_r);
    BS_center_v_r = mean(meas_positions_v)
    % in_deg_v = pix2deg_YR(BS_center_v-mean(fix_cord1))
    BS_diameter_v_r = abs(mean(upper_v_r) - mean(lower_v_r))
    in_deg_v_r = pix2deg_YR(BS_diameter_v_r)
    title('vertical right');
end







