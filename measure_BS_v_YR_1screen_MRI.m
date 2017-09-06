% meas_trials = 5;
meas_positions_v = zeros(1,2*meas_trials);

% meas_stimRect = [0 0 10 10];

% flickFreq = 8;
% flickCol = [0 255];

% % Set the intial position of the square to be in the centre of the screen
% squareX = xCenter;
% squareY = yCenter;

% Set the amount we want our square to move on each button press
pixelsPerPress = 1;


% The avaliable keys to press
escapeKey = KbName('ESCAPE');
akey = KbName('a');
bkey = KbName('b');
% ckey = KbName('c');
dkey = KbName('d');
confirmkey = KbName('c');

%% instruct
flickInd = 0;

%% 
for mt = 1:2*meas_trials    
%     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    if mt <= meas_trials
       Screen('TextSize', window, 30);
       DrawFormattedText(window,'UPPER',nx,'center',black,[],[]);
    elseif mt == meas_trials+1
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'LOWER',nx,'center',[1 0 0],[],[]);
    else
        Screen('TextSize', window, 30);
        DrawFormattedText(window,'LOWER',nx,'center',black,[],[]);
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
    
    
    
    exitDemo = false;
    while exitDemo == false
        
        % Check the keyboard to see if a button has been pressed
        [keyIsDown,secs, keyCode] = KbCheck(-1);
        
        % Depending on the button press, either move ths position of the square
        % or exit the demo
        if keyCode(escapeKey)
            exitDemo = true;
        elseif keyCode(akey) %up
            squareY = squareY - pixelsPerPress;
        elseif keyCode(bkey) %down
            squareY = squareY + pixelsPerPress;
           
        elseif keyCode(confirmkey) %if confirm selection
            exitDemo = true;
        end
        
        
        
        % We set bounds to make sure our square doesn't go completely off of
        % the screen
        if squareX < 0
            squareX = 0;
        elseif squareX > screenXpixels
            squareX = screenXpixels;
        end
        
        if squareY < 0
            squareY = 0;
        elseif squareY > screenYpixels
            squareY = screenYpixels;
        end
        
        
       thisFlick = GetSecs;
       if thisFlick + ifi >= lastFlick + 1/flickFreq/2
           flickInd = mod(flickInd+1, 2);
           lastFlick = thisFlick;
       end
       
%        set target Rect to mouse coordinates
%        targetPoint = [BS_center_h, mouseY];
       
        targetPoint = [BS_center_h, squareY];
        
        % Center the rectangle on the centre of the screen
        centeredRect = CenterRectOnPointd(meas_stimRect, BS_center_h, squareY);
        
        % Draw the rect to the screen
        Screen('FillRect', window, flickCol(flickInd+1), centeredRect);
        
        ShowFix()
        
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
        
        
        % Flip to the screen
        vbl = Screen('Flip',window);
        
    end % while
    %RECORD RESPONSE
    meas_positions_v(mt) = targetPoint(2);
    raw_coords_v(mt) = squareX;
    
    %reset position to centre of h and ycentre
    squareX = BS_center_h;
    squareY = yCenter;
    
    
    
    
%     while ~any(buttons)
%        [keyIsDown, keyTime, keyCode] = KbCheck(-1);
% 
%         % Get mouse cursor coordinates.
%        [mouseX, mouseY, buttons] = GetMouse(window);
% 
%        % Shift the grating by "shiftperframe" pixels per frame:
%        %cycle through 3 directions (left, right, stationary)
%        thisFlick = GetSecs;
%        if thisFlick + ifi >= lastFlick + 1/flickFreq/2
%            flickInd = mod(flickInd+1, 2);
%            lastFlick = thisFlick;
%        end
% 
%        % set target Rect to mouse coordinates
%        if stereoMode == 10
%           targetPoint = [BS_center_h, mouseY];
%        else
%           targetPoint = [BS_center_h, mouseY];
%        end
% 
%        targetRect = CenterRectOnPoint(meas_stimRect, targetPoint(1), targetPoint(2));
%        
% %    Screen('TextSize', window, 20);
% %            textString = ['Mouse at X pixel ' num2str(round(mouseX))...
% %         ' and Y pixel ' num2str(round(mouseY))];
% %      DrawFormattedText(window, textString, 'center', 'center', white);
%      
%      
%        % FLIP 
%        vbl = Screen('Flip', window);
% 
%        % Select left-eye image buffer for drawing:
% %        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
% 
%            % draw fixation dot 
% %            Screen('CopyWindow', leftFixWin, window, [], windowRect);	  
% 
%            if isequal(bs_eye,'left')
%                ShowFix()
% %                Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,black);
%                Screen('FillRect', window, flickCol(flickInd+1), targetRect);
%            end
%            
%        % Select right-eye image buffer for drawing:
% %        Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
% 
%            % draw fixation dot 
% %            Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);	  
%            
%            if isequal(bs_eye,'right')
%                ShowFix()
% %                Screen('DrawText',window, '+', r_fix_cord1(1), r_fix_cord1(2)-8,black);
%                Screen('FillRect', window, flickCol(flickInd+1), targetRect);
%            end
%            
% %               Screen('TextSize', window, 20);
% %            textString = ['Mouse at X pixel ' num2str(round(mouseX))...
% %         ' and Y pixel ' num2str(round(mouseY))];
% %      DrawFormattedText(window, textString, 'center', 'center', white);
%         
%      
%      Screen('DrawingFinished',window);
% 
%        % Abort demo if any key is pressed:
%        if keyCode(KbName('ESCAPE'))
%            if togglegoggle == 1
%                ToggleArd(ard,'AllOff')
%                disp('Check goggles are off')
%                ShutdownArd(ard,comPort);
%                disp('Arduino is off')
%                %            cls
%            end
%            sca
%           break;
%        end
%     end
%     vbl = Screen('Flip',window);
%     meas_positions_v(mt) = targetPoint(2);
%      raw_coords_v(mt) = mouseY;
end

%%
upper_v = meas_positions_v(1:meas_trials)
lower_v = meas_positions_v(meas_trials+1:end)
figure;
plot(1:meas_trials, upper_v, 1:meas_trials, lower_v);
BS_center_v = mean(meas_positions_v)
% in_deg_v = pix2deg_YR(BS_center_v-mean(fix_cord1))
BS_diameter_v = abs(mean(upper_v) - mean(lower_v))
in_deg_v = pix2deg_YR_MRI(BS_diameter_v)
title('vertical');








