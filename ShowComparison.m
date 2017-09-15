% % This script shows the comparison stimulus for
% Yulia_test_gratings_one_screen.m

%%
% SHOW THE COMPARISON STIM
%         if strcmp(whicheye, 'right'); %compare strings
%             if togglegoggle == 1;
%                 %BS trial so open right lens
%                 ToggleArd(ard,'LeftOff') %close left
%             end
%         else
%             if togglegoggle == 1;
%                 ToggleArd(ard,'RightOff') %close right
%             end
%         end
        
        goggles(bs_eye, whicheye, togglegoggle,ard)
        
        while vbl - start_time < ((0.8/ifi - 0.2)*ifi)
            % Motion
            shiftperframe = cyclespersecond * periods(thistrial(2)) * waitduration;
            
            % Shift the grating by "shiftperframe" pixels per frame:
            % the mod'ulo operation makes sure that our "aperture" will snap
            % back to the beginning of the grating, once the border is reached.
            xoffset = mod(incrementframe*shiftperframe,periods(thistrial(2)));
            %incrementframe=incrementframe+1;
            
            % Define shifted srcRect that cuts out the properly shifted rectangular
            % area from the texture: Essentially make a different srcRect every frame which is shifted by some amount
            srcRect=[0, xoffset, bar_width, xoffset + bar_length];
            
                        
            
            ShowFix()
            
            
            Screen('DrawTexture', window, gratingtex(thistrial(2),1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
            
            
            switch thistrial(1)
                case 1 %intact
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %
                    %we don't need to do anything else
                case 2 %Blindspot - special case, we need to present to the other eye!
                    %present the grating of the SF stored in thistrial(2) to
                    %the RIGHT EYE
                    %
                    %we don't need to do anything else
                case 3 %Occluded
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %
                    %pop on the occluder
                    Screen('FillOval', window, white*0.5*brightness, occluderRectCentre_Expt, maxDiameter); %'white' occluder of 0.7 greyness
                    Screen('FrameOval', window, [(white*0.5*brightness)/2], occluderRectCentre_Expt, 3);
                case 4 %Deleted sharp
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %
                    %grey mask
                    Screen('FillOval', window, grey_bkg, occluderRectCentre_Expt, maxDiameter); %grey occluder
                case 5 %Deleted fuzzy
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
%                     Screen('DrawTexture', window, gratingtex(thistrial(2),1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %fuzzy mask
                    Screen('DrawTexture', window, maskTexture, [], fuzzyRectCentre_Expt);
            end %switch
            
            Screen('DrawingFinished', window);
            
            % fix point
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2  ) * ifi);
           
            incrementframe = incrementframe + 1;
            
        end %while 
        time_elapsed_comp = vbl - start_time;
        disp(sprintf('    Time elapsed for comparison:  %.5f seconds using VBL - start',time_elapsed_comp));