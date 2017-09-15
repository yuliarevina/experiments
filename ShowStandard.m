% This script shows the control (standard stimulus) for
% Yulia_test_gratings_one_screen.m

%% _________________________________________________
% SHOW THE CONTROL
        goggles(bs_eye, 'fellow', togglegoggle,ard)      

%         if togglegoggle == 1;
%             ToggleArd(ard,'RightOff') % turn right lens off
%         end
        
        while vbl - start_time < ((0.8/ifi - 0.2)*ifi)
            % Motion
            shiftperframe = cyclespersecond * periods(2) * waitduration;
            
            % Shift the grating by "shiftperframe" pixels per frame:
            % the mod'ulo operation makes sure that our "aperture" will snap
            % back to the beginning of the grating, once the border is reached.
            xoffset = mod(incrementframe*shiftperframe,periods(2));
            %incrementframe=incrementframe+1;
            
            % Define shifted srcRect that cuts out the properly shifted rectangular
            % area from the texture: Essentially make a different srcRect every frame which is shifted by some amount
            srcRect=[0, xoffset, bar_width, xoffset + bar_length];
            
            
            %show fix
            Screen('FillRect', window, grey_bkg); % make the whole screen grey_bkg
            ShowFix();
            
            % display intact at SF of 0.3 ir gratingtex(2)
            Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
           
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi);
%            
            incrementframe = incrementframe + 1;
                    if makescreenshotsforvideo
                          imageArray = Screen('GetImage', window);
                          filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
                          imwrite(imageArray, filenameimage);
                          framenumber = framenumber+1;
                    end
        end    %while
        time_elapsed_control = vbl - start_time;
        disp(sprintf('    Time elapsed for control:  %.5f seconds using VBL - start',time_elapsed_control));