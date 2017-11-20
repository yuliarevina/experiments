meas_trials = 3;
meas_positions_h = zeros(1,2*meas_trials);

meas_stimRect = [0 0 10 10]; %was originally 10 but might be too big... changed it back to 10 for distance of 70cm on station1

SetMouse(xCenter,yCenter, window);

flickFreq = 4;
flickCol = [0 255]; %b&w
% flickCol = [0.1 0.1 0.1; 0.3 0.3 0.3]; %B&grey
%% instruct
flickInd = 0;
Screen('TextSize', window, 30);
%% 
for mt = 1:2*meas_trials    
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    % draw fixation dot
    Screen('CopyWindow', leftFixWin, window, [], windowRect);
    if mt <= meas_trials
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'INNER',nx,'center',black,[],[]);
    elseif mt == meas_trials+1
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'OUTER',nx,'center',[1 0 0],[],[]); % red
    elseif mt < meas_trials*2+1;
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'OUTER',nx,'center',black,[],[]); 
    end
    
    Screen('SelectStereoDrawBuffer', window, 1);  %Right
    % draw fixation dot
    Screen('CopyWindow', rightFixWin, window, [], windowRect);
    if mt <= meas_trials
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'INNER',nx,'center',black,[],[]);
    elseif mt == meas_trials+1
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'OUTER',nx,'center',[1 0 0],[],[]); % red
    elseif mt < meas_trials*2+1;
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'OUTER',nx,'center',black,[],[]); 
    end
    
%     Screen('SelectStereoDrawBuffer', window, 1);  %Right
%     if mt <= meas_trials
%         DrawFormattedText(window,'INNER',500,400,white,[],1);
%     else
%         DrawFormattedText(window,'OUTER',500,400,white,[],1);
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
       

       

       % Select left-eye image buffer for drawing:
       Screen('SelectStereoDrawBuffer', window, 0);  %LEFT

           % draw fixation dot 
           Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
           ShowFix()

           if isequal(bs_eye,'left')
                % draw fixation dot 
%                 ShowFix()
%                Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,black);
               Screen('FillRect', window, flickCol(flickInd+1), targetRect);
          
           end
           
%        % Select right-eye image buffer for drawing:
       Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT

           % draw fixation dot 
           Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);	  
           ShowFix()

           if isequal(bs_eye,'right')
                % draw fixation dot 
%                 ShowFix()
%                Screen('DrawText',window, '+', r_fix_cord1(1), r_fix_cord1(2)-8,black);
               Screen('FillRect', window, flickCol(flickInd+1), targetRect);
           end
           Screen('TextSize', window, 20);
%            textString = ['Mouse at X pixel ' num2str(round(mouseX))...
%         ' and Y pixel ' num2str(round(mouseY))];
%      DrawFormattedText(window, textString, 'center', 470, white);
           
        Screen('DrawingFinished',window);

       % Abort demo if any key is pressed:
       if keyCode(KbName('ESCAPE'))
            if togglegoggle == 1
                ToggleArd(ard,'AllOff')
                disp('Check goggles are off')
%                   ShutdownArd(ard,comPort);
%                   disp('Arduino is off')
%                cls
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
    meas_positions_h(mt) = targetPoint(1);
    raw_coords_h(mt) = mouseX;
end;

%% save data
if isequal(bs_eye,'right')
    inner_h_r = meas_positions_h(1:meas_trials)
    outer_h_r = meas_positions_h(meas_trials+1:end)
    figure;
    plot(1:meas_trials, inner_h_r, 1:meas_trials, outer_h_r);
    BS_center_h_r = mean(meas_positions_h)
    %mean(fix_cord1) is probably a BUG because it has both x and y coordinates
    % in_deg_h = pix2deg_YR(BS_center_h-mean(fix_cord1))
    BS_diameter_h_r = abs(mean(inner_h_r) - mean(outer_h_r))
    in_deg_h_r = pix2deg_YR(BS_diameter_h_r)
    title('horizontal right');
else
    inner_h_l = meas_positions_h(1:meas_trials)
    outer_h_l = meas_positions_h(meas_trials+1:end)
    figure;
    plot(1:meas_trials, inner_h_l, 1:meas_trials, outer_h_l);
    BS_center_h_l = mean(meas_positions_h)
    %mean(fix_cord1) is probably a BUG because it has both x and y coordinates
    % in_deg_h = pix2deg_YR(BS_center_h-mean(fix_cord1))
    BS_diameter_h_l = abs(mean(inner_h_l) - mean(outer_h_l))
    in_deg_h_l = pix2deg_YR(BS_diameter_h_l)
    title('horizontal left');
end








