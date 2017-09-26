% BS localization for MRI


% 12 s fix
% Target flash 5hz
% 12 s fix
% Surr flash 5 hz
% 12 s fix


% Stim 1 - Target both
% Stim 2 - Target fellow
% Stim 3 - target BS
% Stim 4 - Surr both


responses = {};
resp = 1; %counter for responses


% if ~IsWin
    devices = PsychHID('Devices');
% end
keyboardind = GetKeyboardIndices();
mouseind = GetMouseIndices();


KbName('UnifyKeyNames')

% define keyboards used by subject and experimenter
% run KbQueueDemo(deviceindex) to test various indices
deviceindexSubject = []; %possibly MRI keypad
%can only listen to one device though...
% deviceindexExperimenter = 11; %possibly your laptop keyboard

% The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
space = KbName('space');
scannertrigger = KbName('s');

DisableKeysForKbCheck([]); % listen for all keys at the start




todaydate  = date;

% ASK FOR SUBJECT DETAILS

subCode = input('Enter Subject Code:   ');
subAge = input('Enter Subject Age in yrs:   ');
subGender = input('Enter Subject Gender:   ');

filename = sprintf('Localizer_%s_%s_%s_%s.mat', todaydate, subCode, num2str(subAge), subGender);
filenametxt = sprintf('Localizer_%s_%s_%s_%s.txt', todaydate, subCode, num2str(subAge), subGender);
fileID = fopen(filenametxt,'w');


stereoModeOn = 0; %don't need this for goggles, only for the 2 screen setup
stereoMode = 4;        % 4 for split screen, 10 for two screens
makescreenshotsforvideo = 0;

BS_measurementON = 1;                     

%%% toggle goggles for debugging %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
togglegoggle = 0; % 0 goggles off for debug; 1 = goggles on for real expt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% DEMO ON/OFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Demo = 0; %show the debug bars at the start?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


bs_eye = 'right';   %% Right eye has the blind spot. Left fixation spot


nSeq = 8;
nStim = 4;




distance2screen = 42; % how many centimeters from eye to screen? To make this portable on different machines

outside_BS = 5; %deg of visual angle
outside_BS = round(deg2pix_YR_MRI(outside_BS)); %in pixels for our screen

brightness = 0.1;
% brightness = 0.7; % for debugging
textcolor = [0 0 0];

% timing
goggle_delay = 0.35; %seconds to keep lens closed after stim offset, to account for slow fade out of stim

% GAMMA CORRECTION
load('CLUT_StationMRI_rgb_1920x1080_27_Jul_2017.mat', 'clut')

% _______________________________________________________________________
%  This is how to select each screen for stereo

% %  % Select left-eye image buffer for drawing:
%    Screen('SelectStereoDrawBuffer', w, 0);  %LEFT
%    % draw fixation dot 
%    Screen('CopyWindow', leftFixWin, w, [], leftScreenRect);	  
%    % Select right-eye image buffer for drawing:
%    Screen('SelectStereoDrawBuffer', w, 1);   %RIGHT
%    % draw fixation dot 
%    Screen('CopyWindow', rightFixWin, w, [], rightScreenRect);	  
%    Screen('Flip',w);


%% -------------------------------
% set up screen and psychtoolbox |
% --------------------------------

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

if IsWin
    Screen('Preference', 'SkipSyncTests', 1); %also remove this for the real expt. This is just for programming and testing the basic script on windows
end
% 
% This script calls Psychtoolbox commands available only in OpenGL-based 
% versions of the Psychtoolbox. (So far, the OS X Psychtoolbox is the
% only OpenGL-base Psychtoolbox.)  The Psychtoolbox command AssertPsychOpenGL will issue
% an error message if someone tries to execute this script on a computer without
% an OpenGL Psychtoolbox
AssertOpenGL;


if IsWin
    Priority(1); %MAX FOR WIN
else
    Priority(2);   % Linux
end

screens = Screen('Screens');  % Gives (0 1) if there is an external monitor attached or just (0) for no external
screenNumber = max(screens);  % puts stimulus on external screen

white = WhiteIndex(screenNumber);  %value of white for display screen screenNumber
black = BlackIndex(screenNumber);  %value of white for display screen screenNumber
grey = GrayIndex(screenNumber);  %value of white for display screen screenNumber
% grey_bkg = white*0.10
% grey_bkg = grey*brightness/10
grey_bkg = black



% % Set the blend function for the screen
% Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% % % correct non-linearity from CLUT
if ~IsWin
    oldCLUT= Screen('LoadNormalizedGammaTable', screenNumber, clut);
end


% Open an on screen window and color it grey

if stereoModeOn
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey_bkg, [], [], [], stereoMode); % StereoMode 4 for side by side
    leftScreenRect = windowRect;
    rightScreenRect = windowRect;
    if stereoMode == 10
        Screen('OpenWindow', screenNumber-1, 128, [], [], [], stereoMode);
    end
else %just open one window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey_bkg);
end


% % Set the blend function for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% 


white = WhiteIndex(screenNumber);  %value of white for display screen screenNumber
black = BlackIndex(screenNumber);  %value of white for display screen screenNumber
grey = GrayIndex(screenNumber);  %value of white for display screen screenNumber


% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

waitframes = 1; % update every frame?
    
% Translate frames into seconds for screen update interval:
waitduration = waitframes * ifi; % basically just = ifi if we update on every frame



% The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
space = KbName('space');
scannertrigger = KbName('s');



% Need mouse control for blind spot measurements
sinceLastClick = 0;
mouseOn = 1;
lastKeyTime = GetSecs;
SetMouse(xCenter,yCenter,window);
WaitSecs(.1);
[mouseX, mouseY, buttons] = GetMouse(window);


%% flickering checkerboard parameters

hz = 5; %flicker at 5 times per s
nSecsPerFlicker = 1/hz;
nFramesPerFlicker = (1/ifi)*nSecsPerFlicker; % n frames per second x seconds eg 60 x 0.2 = 12 frames

targetDegV = in_deg_v - 2; % annulus is 1deg wide so target is the inner circle 2 deg smaller overall in diameter
targetDegH2 = in_deg_h2 - 2;

targetPxV = deg2pix_YR_MRI(targetDegV); %size of small target circle in px
targetPxH2 = deg2pix_YR_MRI(targetDegH2);

%basic rect of target size
targetRect = [0 0 targetPxH2 targetPxV];
%centre on BS coords
targetRectCentre = CenterRectOnPointd(targetRect, BS_center_h2, BS_center_v);


%% Stimuli types

% 1. Target Both eyes
% 2. Target IPSI (BS eye)
% 3. Target contra (Fellow eye)
% 4. Surround (both eyes)
% 5. Fixation (both eyes)

% e.g.
% Fix | Stim 1 | Fix | Stim 3 | Fix | Stim 2 | Fix | Stim 4

%all possible combinations
allstimscomboslocalizer = perms(1:4);

% we need to choose 8 out of all poss ones
to_use = randperm(24,8);


%% Stimuli textures

% let's create all the textures we will need

% Define a simple 10 by 10 checker board
checkerboard = repmat(eye(2), 10, 10);

% Make the checkerboard into a texure (4 x 4 pixels)
checkerTexture(1) = Screen('MakeTexture', window, checkerboard);
checkerTexture(2) = Screen('MakeTexture', window, 1 - checkerboard); %inverse texture

texturecue = [1 2]; %switch between the normal and inverse

% We will scale our texure up to 70 times its current size be defining a
% larger screen destination rectangle
[s1, s2] = size(checkerboard);
dstRect = [0 0 s1 s2] .* 70;
%we need to center on the BS
dstRect = CenterRectOnPointd(dstRect, BS_center_h2, BS_center_v);
% ---> basic square checkerboard is complete!


% we will redefine the BS oval and centre it on the BS centre. This is the
% size and position of the BS and surr
occluderRectCentre_Expt = CenterRectOnPointd(occluderRect, BS_center_h2,BS_center_v);

% surroundMiddle = [0 0 surrwidth surrheight]; %make a smaller grey oval to be in the middle of the big one. We need a checkerboard annulus
% surroundMiddleCentre = CenterRectOnPointd(surroundMiddle, BS_center_h2,BS_center_v); %centre on the BS coords




% TARGET
% conditions 1, 2 and 3

% OPEN OFF SCREEN WINDOW
% Build a nice aperture texture: Offscreen windows can be used as
% textures as well, so we open an Offscreen window of exactly the same
% size 'objRect' as our noise textures, with a gray default background.
% This way, we can use the standard Screen drawing commands to 'draw'
% our aperture:
% we need three target textures as we have target in 3 conditions
aperture(1)=Screen('OpenOffscreenwindow', window, grey);
aperture(2)=Screen('OpenOffscreenwindow', window, grey);
aperture(3)=Screen('OpenOffscreenwindow', window, grey);
       
% Screen('DrawTextures', aperture(1), checkerTexture(texturecue(1)), [],...
%                                 dstRect, 0, filterMode);


% MAKE TRANSPARENT OVAL THE SIZE OF THE TARGET
% First we clear out the alpha channel of the aperture disk to zero -
% In this area the noise stimulus will shine through:
Screen('FillOval', aperture(1), [1 1 1 0], targetRectCentre);
Screen('FillOval', aperture(2), [1 1 1 0], targetRectCentre);
Screen('FillOval', aperture(3), [1 1 1 0], targetRectCentre);


Screen('FrameOval', aperture(1), [1 0 0 1], occluderRectCentre_Expt);
Screen('FrameOval', aperture(2), [1 0 0 1], occluderRectCentre_Expt);
Screen('FrameOval', aperture(3), [1 0 0 1], occluderRectCentre_Expt);


% SURROUND
% condition 4

% OPEN OFF SCREEN WINDOW
aperture(4)=Screen('OpenOffscreenwindow', window, grey);

% MAKE TRANSPARENT OVAL THE SIZE OF THE BS
% First we clear out the alpha channel of the aperture disk to zero -
% In this area the noise stimulus will shine through:
Screen('FillOval', aperture(4), [1 1 1 0], occluderRectCentre_Expt);

Screen('FrameOval', aperture(4), [1 0 0 1], occluderRectCentre_Expt);


% MAKE GREY OVAL THE SIZE OF TARGET to make an annulus
Screen('FillOval', aperture(4), [grey grey grey 1], targetRectCentre);



%% Fix frame

% Fixation point on the RIGHT
fp_offset = 400;
% frame
frameSize = 900;

rightFixWin = Screen('OpenOffScreenWindow',window, grey_bkg, windowRect); 
leftFixWin = Screen('OpenOffScreenWindow',window, grey_bkg, windowRect); 
[center(1), center(2)] = RectCenter(windowRect);
fix_r1 = 8;
fix_r2 = 4; 
fix_cord1 = [center-fix_r1 center+fix_r1] ;
fix_cord2 = [center-fix_r2 center+fix_r2] ;
l_fix_cord1 = [center-fix_r1 center+fix_r1] + [fp_offset 0 fp_offset 0];
l_fix_cord2 = [center-fix_r2 center+fix_r2] + [fp_offset 0 fp_offset 0];
r_fix_cord1 = [center-fix_r1 center+fix_r1] - [fp_offset 0 fp_offset 0];
r_fix_cord2 = [center-fix_r2 center+fix_r2] - [fp_offset 0 fp_offset 0];
Screen('FillOval', rightFixWin, uint8(white), l_fix_cord1);
Screen('FillOval', rightFixWin, uint8(black), l_fix_cord2);

% Two crosses in and lower
Screen('DrawText',leftFixWin, '+', center(1), 200,white);
Screen('DrawText',leftFixWin, '+', center(1), 1050-200,white);
Screen('DrawText',rightFixWin, '+', center(1), 200,white);
Screen('DrawText',rightFixWin, '+', center(1), 1050-200,white);

% Frame
frameRect = CenterRect([0 0 frameSize frameSize],windowRect);
Screen('FrameRect',leftFixWin, [0 256 0], frameRect, 4);
Screen('FrameRect',rightFixWin, [256 0 0], frameRect, 4);
%DEBUG
% Screen('DrawText',rightFixWin,'Adjust UPPER grating!',300,400,white,[],[],1);

% Fixation point on the LEFT
leftFixWin = Screen('OpenOffScreenWindow',window, grey_bkg, windowRect); 
Screen('FillOval', leftFixWin, uint8(white), r_fix_cord1);
Screen('FillOval', leftFixWin, uint8(black), r_fix_cord2);

% Two crosses in and lower
Screen('DrawText',leftFixWin, '+', center(1), 200,white);
Screen('DrawText',leftFixWin, '+', center(1), 1050-200,white);

% Frame
frameRect = CenterRect([0 0 frameSize frameSize],windowRect);


if togglegoggle == 1;
    [ard, comPort] = InitArduino;
    disp('Arduino Initiated')
    
    goggles(bs_eye, 'both', togglegoggle,ard)
%     ToggleArd(ard,'LensOn') % need both eyes to view everything up until the actual experiment trials (and for the BS measurement)
    
    % Remember to switch this off if the code stops for any reason. Any
    % Try/Catch routines should have LensOff integrated there...
else
    ard =[]; %dummy variable in case we are not using goggles
end


%% ---------------
%  Intro screen  |
%-----------------
%show fix

Screen('FillRect', window, grey) % make the whole screen grey_bkg
ShowFix()

instructions = 'Blind spot localization \n \n Please fixate on the cross at all times \n \n Standby for Scanner Trigger';
DrawFormattedText(window, instructions, 'center', 'center', textcolor, [], []);

%flip to screen
 Screen('TextSize', window, 20);
 Screen('Flip', window);
% KbStrokeWait;



    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)    
        
    %get timestamp
   
%     DrawFormattedText(window, 'Waiting for scanner trigger...', 'center', 'center', white,[],[]);
%     Screen('Flip', window);
    disp('Waiting for scanner trigger...')
    
    [secs, keyCode, deltaSecs]=    KbStrokeWait(-1);
    
    while ~keyCode(scannertrigger)
        [keyIsDown, secs, keyCode] = KbCheck(-1);% Check the keyboard to see if a button has been pressed
    end
    disp('Trigger detected')
    DisableKeysForKbCheck(scannertrigger); % now disable the scanner trigger
    
    vbl = secs;
    expt_start = secs;
    KbQueueCreate(deviceindexSubject);
    
    KbQueueStart(deviceindexSubject);
    
    for Sequence = 1:nSeq
        disp(sprintf('Sequence %d', Sequence))
        
        currSequenceOrder = allstimscomboslocalizer(to_use(Sequence), :); % the current sequence e.g. 2 4 1 3
        
        for Stimulus = 1:nStim
%               KbQueueStart();

                %Show fix
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%% FIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % ADD TASK on fix pt

        curr_frame = 1;
        start_time = vbl;

        totalframes = 12/ifi;
        taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
        
        
        respmade = 0;
 
        goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)       
 
        time_zero = vbl;
        if Stimulus == 1
            startblock = vbl; %if the start of a block, record first flip of stim onset
        end
        
        
        
        while vbl - start_time < ((12/ifi - 0.2)*ifi)%time is under 12 s
            Screen('FillRect', window, grey) % make the whole screen grey_bkg
            
            if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/ifi) %if between taskframe and taskframe + 1s
                %show alternative fix
                if curr_frame == taskframe %if the very first frame
                    startSecs = GetSecs(); %rough onset of alternative fix
                    disp('Task!')
                end
                AlternativeShowFixRed() %red
%                 disp(num2str(curr_frame))
                %   disp(num2str(taskframe))
%                 disp('alternative')
                
            else
                ShowFix() %white
%                 disp(num2str(curr_frame))
                %  disp(num2str(taskframe))
%                 disp('normal')
            end
            
            
            
%             ShowFix()
            DrawFormattedText(window, '12s fixation...', 'center', 'center', black,[],[]);
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
            curr_frame = curr_frame + 1; %increment frame counter
            
            %        then do another flip to clear this half a sec later
            %         KbQueueStop();
            %check for ESC key
            
%             vbl = Screen('Flip', window, vbl + (12/ifi - 0.2) * ifi);
%             [pressed, firstPress]=KbQueueCheck();
%             pressedKeys = KbName(firstPress);
            
            % record responses
            [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
            [keyIsDown, secs, keyCode] = KbCheck(-1);% Check the keyboard to see if a button has been pressed
            pressedKeys = KbName(firstPress); %which key
            timeSecs = firstPress(find(firstPress)); %what time
            if pressed %report the keypress for the experimenter to see
                % Again, fprintf will give an error if multiple keys have been pressed
                fprintf('"%s" typed at time %.3f seconds, %d  Fix  \r\n', KbName(firstPress), timeSecs - startSecs,Sequence);
                fprintf(fileID,'"%s" typed at time %.3f seconds  %d  Fix  \r\n', KbName(firstPress), timeSecs - startSecs,Sequence);
                RT = timeSecs - startSecs;
                responses{resp,1}= Sequence;
                responses{resp,2} = 'Fix';
                responses{resp,3} = pressedKeys;
                responses{resp,4} = RT;
                respmade = 1;
            else
               
            end
            % end of response recording
            
            
            if max(strcmp(pressedKeys,'ESCAPE')) || keyCode(escapeKey)
                goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
                if togglegoggle == 1
                    ShutdownArd(ard,comPort);
                end
                %             close goggles
                %             save any data
                pressedKeys
                disp('Escape this madness!!')
                fclose(fileID);
                sca
                save(filename)
            end
        end %while
        if ~respmade %if no response whatsoever
            RT = NaN;
            responses{resp,1}= Sequence;
            responses{resp,2} = 'Fix';
            responses{resp,3} = 'No response';
            responses{resp,4} = RT;
        end
        resp = resp + 1; %update resp counter

        time_elapsed = vbl - time_zero;
        time_elapsed2 = vbl - startblock;
%         time_elapsed3 = vbl - timestart;
        disp(sprintf('    Time elapsed for 12s fix:  %.5f seconds from first flip',time_elapsed));
        disp(sprintf('    Time elapsed for 12s fix:  %.5f seconds from startblock',time_elapsed2));
%         disp(sprintf('    Time elapsed for 6s fix:  %.5f seconds from scannertrigg',time_elapsed3));
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Show stimulus %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



        % Flashing checkerboard at 5 hz
                
                             % ADD TASK on fix pt
                
                % Draw the checkerboard texture to the screen. By default bilinear
                % filtering is used. For this example we don't want that, we want nearest
                % neighbour so we change the filter mode to zero
                filterMode = 0;
                curr_frame = 1;
                start_time = vbl;
                
                totalframes = 12/ifi;
                taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand);
                
                respmade = 0;
                
                while vbl - start_time < ((12/ifi - 0.2)*ifi)%time is under 12 s
%                     
                        %for showtimes = 1:hz
                        % display this checkerboard for a certain number of frames
                        % and then flip the contrast... (maybe best to do this based on seconds elapsed rather than frames but can leave this for now as a WIP)
                        for i = 1:nFramesPerFlicker
                            
                            %check we are not over time
                            if vbl - start_time >= (12)
                                disp(sprintf('Oops, over time! Time now is: %d, i = %d, curr_frame = %d', vbl - start_time,i, curr_frame))
                                break;
                            end
                            
                            
                            % display the basic checker
                            Screen('DrawTextures', window, checkerTexture(texturecue(1)), [],...
                                dstRect, 0, filterMode);
                            
                            
                             % Overdraw the rectangular noise image with our special
                            % aperture image. The noise image will shine through in areas
                            % of the aperture image where its alpha value is zero (i.e.
                            % transparent):                 
                            Screen('DrawTexture', window, aperture(currSequenceOrder(Stimulus)), [], [], [], filterMode); % call up the right texture for the curr stim
                            
                            
                            if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/ifi) %if between taskframe and taskframe + 1s
                                %show alternative fix
                                if curr_frame == taskframe %if the very first frame
                                    startSecs = GetSecs(); %rough onset of alternative fix
                                    disp('Task!')
                                end
                                AlternativeShowFixRed() %red
%                                 disp(num2str(curr_frame))
%                                 disp(num2str(taskframe))
%                                 disp('alternative')
                                
                            else
                                ShowFix() %white
%                                 disp(num2str(curr_frame))
%                                 disp(num2str(taskframe))
%                                 disp('normal')
                            end
                            
                            
                            switch currSequenceOrder(Stimulus)
                                case 1
                                    goggles(bs_eye, 'both', togglegoggle,ard)
                                case 2
                                    goggles(bs_eye, 'BS', togglegoggle,ard)
                                case 3
                                    goggles(bs_eye, 'fellow', togglegoggle,ard)
                                case 4
                                    goggles(bs_eye, 'both', togglegoggle,ard)
                            end
                            
                            DrawFormattedText(window, num2str(currSequenceOrder(Stimulus)), 'center', 'center', textcolor, [],[]);
                            vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
                            curr_frame = curr_frame + 1; %increment frame counter
                        end
                        texturecue = fliplr(texturecue);
                        
                        % record responses
                        [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
                        [keyIsDown,secs, keyCode] = KbCheck(-1);
                        pressedKeys = KbName(firstPress); %which key
                        timeSecs = firstPress(find(firstPress)); %what time
                        if pressed %report the keypress for the experimenter to see
                            % Again, fprintf will give an error if multiple keys have been pressed
                            fprintf('"%s" typed at time %.3f seconds  %d  %d  \r\n', KbName(firstPress), timeSecs - startSecs, Sequence, Stimulus);
                            fprintf(fileID,'"%s" typed at time %.3f seconds  %d  %d  \r\n', KbName(firstPress), timeSecs - startSecs, Sequence, Stimulus);
                            RT = timeSecs - startSecs;
                            responses{resp,1}= Sequence;
                            responses{resp,2} = Stimulus;
                            responses{resp,3} = pressedKeys;
                            responses{resp,4} = RT;
                            respmade = 1;
                            
                            
                        end
                        % end of response recording
                        
                          if max(strcmp(pressedKeys,'ESCAPE')) || keyCode(escapeKey)
                            goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
                            if togglegoggle == 1
                                ShutdownArd(ard,comPort);
                            end
                            %             close goggles
                            %             save any data
                            pressedKeys
                            disp('Escape this madness!!')
                            fclose(fileID);
                            sca
                            save(filename)
                        end
                end %while
                if ~respmade %if no response was made at all
                    RT = NaN;
                    responses{resp,1}= Sequence;
                    responses{resp,2} = Stimulus;
                    responses{resp,3} = 'No response';
                    responses{resp,4} = RT;
                end
                
                resp = resp + 1; %update resp counter
                time_elapsed = vbl - start_time;
%                 time_elapsed2 = vbl - startblock;
%               time_elapsed3 = vbl - timestart;
                disp(sprintf('    Time elapsed for 12s flash:  %.5f seconds from first flip',time_elapsed));
%                 disp(sprintf('    Time elapsed for 12s fix:  %.5f seconds from startblock',time_elapsed2));

        end
    end
    %show one last fix
    
                %Show fix
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%% FIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % ADD TASK on fix pt

        curr_frame = 1;
        start_time = vbl;

        totalframes = 12/ifi;
        taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
        
        
        respmade = 0;
 
        goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)       
 
        time_zero = vbl;
        if Stimulus == 1
            startblock = vbl; %if the start of a block, record first flip of stim onset
        end
        
        
        
        while vbl - start_time < ((12/ifi - 0.2)*ifi)%time is under 12 s
            Screen('FillRect', window, grey) % make the whole screen grey_bkg
            
            if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/ifi) %if between taskframe and taskframe + 1s
                %show alternative fix
                if curr_frame == taskframe %if the very first frame
                    startSecs = GetSecs(); %rough onset of alternative fix
                    disp('Task!')
                end
                AlternativeShowFixRed() %red
%                 disp(num2str(curr_frame))
                %   disp(num2str(taskframe))
%                 disp('alternative')
                
            else
                ShowFix() %white
%                 disp(num2str(curr_frame))
                %  disp(num2str(taskframe))
%                 disp('normal')
            end
            
            
            
%             ShowFix()
            DrawFormattedText(window, '12s fixation...', 'center', 'center', black,[],[]);
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
            curr_frame = curr_frame + 1; %increment frame counter
            
            %        then do another flip to clear this half a sec later
            %         KbQueueStop();
            %check for ESC key
            
%             vbl = Screen('Flip', window, vbl + (12/ifi - 0.2) * ifi);
%             [pressed, firstPress]=KbQueueCheck();
%             pressedKeys = KbName(firstPress);
            
            % record responses
            [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
            [keyIsDown, secs, keyCode] = KbCheck(-1);% Check the keyboard to see if a button has been pressed
            pressedKeys = KbName(firstPress); %which key
            timeSecs = firstPress(find(firstPress)); %what time
            if pressed %report the keypress for the experimenter to see
                % Again, fprintf will give an error if multiple keys have been pressed
                fprintf('"%s" typed at time %.3f seconds, %d  Fix  \r\n', KbName(firstPress), timeSecs - startSecs,Sequence);
                fprintf(fileID,'"%s" typed at time %.3f seconds  %d  Fix  \r\n', KbName(firstPress), timeSecs - startSecs,Sequence);
                RT = timeSecs - startSecs;
                responses{resp,1}= Sequence;
                responses{resp,2} = 'Fix';
                responses{resp,3} = pressedKeys;
                responses{resp,4} = RT;
                respmade = 1;
            else
               
            end
            % end of response recording
            
            
            if max(strcmp(pressedKeys,'ESCAPE')) || keyCode(escapeKey)
                goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
                if togglegoggle == 1
                    ShutdownArd(ard,comPort);
                end
                %             close goggles
                %             save any data
                pressedKeys
                disp('Escape this madness!!')
                fclose(fileID);
                sca
                save(filename)
            end
        end %while
        if ~respmade %if no response whatsoever
            RT = NaN;
            responses{resp,1}= Sequence;
            responses{resp,2} = 'Fix';
            responses{resp,3} = 'No response';
            responses{resp,4} = RT;
        end
        resp = resp + 1; %update resp counter

        time_elapsed = vbl - time_zero;
        time_elapsed2 = vbl - startblock;
%         time_elapsed3 = vbl - timestart;
        disp(sprintf('    Time elapsed for 12s fix:  %.5f seconds from first flip',time_elapsed));
        disp(sprintf('    Time elapsed for 12s fix:  %.5f seconds from startblock',time_elapsed2));
%         disp(sprintf('    Time elapsed for 6s fix:  %.5f seconds from scannertrigg',time_elapsed3));
       
    
    
    
    expt_end = vbl;
       disp(sprintf('Total run time: %d', expt_end-expt_start))
    

    if togglegoggle == 1;
        %Close goggles
        % Shut down ARDUINO
        goggles(bs_eye, 'neither', togglegoggle,ard)
        ShutdownArd(ard,comPort);
        disp('Arduino is off')
       
    end
   save(filename)
    sca
    fclose(fileID);