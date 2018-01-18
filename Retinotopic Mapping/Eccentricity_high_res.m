% Eccentricity Mapping
% Using stimulus images from Andrew Tyler Morgan, University of Glasgow
%
% 2017 Yulia Revina, NTU, SG

%%%% STEREO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stereoModeOn = 0; %don't need this for goggles, only for the 2 screen setup
stereoMode = 4;        % 4 for split screen, 10 for two screens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% GOGGLES ON/OFF for debugging %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
togglegoggle = 0; % 0 goggles off for debug; 1 = goggles on for real expt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% DEMO ON/OFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Demo = 0; %show the debug bars at the start?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% DEBUG ON/OFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
debugmode = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% BLIND SPOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bs_eye = 'right';   %% Right eye has the blind spot. Left fixation spot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

devices = PsychHID('Devices');
keyboardind = GetKeyboardIndices();
mouseind = GetMouseIndices();


KbName('UnifyKeyNames')


todaydate  = date;


subCode = input('Enter Subject Code:   ');
subAge = input('Enter Subject Age in yrs:   ');
subGender = input('Enter Subject Gender:   ');


filenametxt = sprintf('Eccentricity_%s_%s_%s_%s.txt', todaydate, subCode, num2str(subAge), subGender);
filename = sprintf('Eccentricity_%s_%s_%s_%s.mat', todaydate, subCode, num2str(subAge), subGender);

responses = {};
resp = 1; %counter for responses

fileID = fopen(filenametxt,'w');


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

load('CLUT_StationMRI_rgb_1920x1080_27_Jul_2017.mat', 'clut')
% % % correct non-linearity from CLUT
if ~IsWin || debugmode == 0
    oldCLUT= Screen('LoadNormalizedGammaTable', screenNumber, clut);
end



if stereoModeOn
%     [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], [], [], stereoMode); % StereoMode 4 for side by side
    if IsWin
        screenNumber = 0;
    end
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], [], [], stereoMode); % StereoMode 4 for side by side
    leftScreenRect = windowRect;
    rightScreenRect = windowRect;
    if stereoMode == 10
%         Screen('OpenWindow', screenNumber-1, 128, [], [], [], stereoMode);
        Screen('OpenWindow', screenNumber, grey_bkg, [], [], [], stereoMode);
    end
else %just open one window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey_bkg);
end
 
 % % Set the blend function for fileIDthe screen
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

% define keyboards used by subject and experimenter
% run KbQueueDemo(deviceindex) to test various indices
if IsWin
    deviceindexSubject = [0]; %possibly MRI keypad
else
    deviceindexSubject = []; %possibly MRI keypad
end
%can only listen to one device though...
% deviceindexExperimenter = 11; %possibly your laptop keyboard


DisableKeysForKbCheck([]) % listen for all keys at the start



% Need mouse control for blind spot measurements
sinceLastClick = 0;
mouseOn = 1;
lastKeyTime = GetSecs;
SetMouse(xCenter,yCenter,window);
WaitSecs(.1);
[mouseX, mouseY, buttons] = GetMouse(window);

%% stim parameters

dir = 'C:/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/';
% dir = '/media/perception/Windows/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/';
% dir ='D:/MRI scripts/Retinotopic Mapping/';
% dir = 'C:/Users/Psychology/Documents/Yulia''s Expt/MRI scripts/Retinotopic Mapping/';
% dir = '/media/laptop1/THE STICK/MRI scripts/Retinotopic Mapping/';
% dir ='/home/laptop1/Documents/Yulia/Retinotopic Mapping/';


stimDur = 125; %ms

nStims = 512;
expansionratiolinear = 3.73; %each ring scales by 1.17 on each iteration
expansionratioexponent = 1.01;

imWidth = 1910*2;
imHeight = 1910*2;

sizemultiplier = 1; %we will increase our texture by 2.

% baseRect = [0 0 imWidth imHeight];
% texturerectangle = CenterRectOnPointd(baseRect * sizemultiplier,...
%         xCenter, yCenter);

textcolor = [0 0 0];

nFrames2wait4nextStim = stimDur/1000/ifi; 


% % %% stimuli
% % 
% % %load the images
% % theImage = ones(imHeight,imWidth,3,nStims); %images are in format H x W x 3 uint8
% % 
% % % Here we load in an image from file.
% % for imnumber = 1:nStims
% %     %get the location
% %     theImageLocation = sprintf('C:/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/PA_Images/PolAngImage_%d.png', imnumber);
% %     % load the image from location
% %     theImage(:,:,:,imnumber) = double(imread(theImageLocation));
% %     % Make the image into a texture
% %     imageTexture(imnumber) = Screen('MakeTexture', window, theImage(:,:,:,imnumber));
% % end
% % 
% % 
% % % load spider web
% % theImageLocation = sprintf('C:/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/SpiderWebBackground.png');
% % SpiderWeb = imread(theImageLocation);
% % SpiderTex = Screen('MakeTexture', window, SpiderWeb);

%% Fix frame

% Fixation point on the RIGHT

fp_offset = 800;

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
leftFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
Screen('FillOval', leftFixWin, uint8(white), r_fix_cord1);
Screen('FillOval', leftFixWin, uint8(black), r_fix_cord2);

% Two crosses in and lower
Screen('DrawText',leftFixWin, '+', center(1), 200,white);
Screen('DrawText',leftFixWin, '+', center(1), 1050-200,white);

% Frame
frameRect = CenterRect([0 0 frameSize frameSize],windowRect);

try
    %% stimuli
    if stereoModeOn
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    end
    
    %load the images
    % theImage = ones(1,1,3,nStims); %images are in format H x W x 3 uint8
    % img = ones(1,1,3,nStims); %images are in format H x W x 3 uint8
    %    testrect = CenterRectOnPointd([0 0 1920 1080], xCenter, yCenter);
    testrect = CenterRectOnPointd([0 0 1600 900], xCenter, yCenter);
    Screen('FillRect',window, [1 0 0], testrect);
    Screen('FrameRect',window, [1 1 0], testrect, 30);
    DrawFormattedText(window, 'Loading...', 'center', 'center', textcolor, [], []);
    disp('Loading...')
    
    if stereoModeOn
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        Screen('FillRect', window, grey) % make the whole screen grey_bkg
        Screen('FillRect',window, [1 0 0], testrect);
        Screen('FrameRect',window, [1 1 0], testrect, 30);
        DrawFormattedText(window, 'Loading...', 'center', 'center', textcolor, [], []);
    end
    
    
    WaitSecs(1);
    
    
    % Here we load in an image from file.
    for imcount = 1:2
        %get the location
        
        %     theImageLocation = sprintf('C:/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/PA_Images/3x3-geocaching-logo-sticker_500_1.jpg');
        %     3x3-geocaching-logo-sticker_500_1.jpg
        theImageLocation = sprintf('%sEcc_Ring_%d.png', dir, imcount);
        %     % load the image from location
        [img, imgmap, alpha] = imread(theImageLocation, 'png');
        
        %       load as a mat file because matlab struggles with this png for some
        %       reason
%         load(theImageLocation)
%         img = cdata;
        %     img = double(img);
        %     %     theImage(:,:,:,imnumber) = double(imread(theImageLocation));
        img(:,:,2) = img(:,:,1); %take info only from red channel, we don't need color info
        img(:,:,3) = img(:,:,1); %take info only from red channel, we don't need color info
        % Make the image into a texture
        
        texture1(imcount) = Screen('MakeTexture', window, img);
        img(:, :, 4) = alpha;
        texture2(imcount) = Screen('MakeTexture', window, img);
        
        if stereoModeOn
            Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        end
        Screen('FillRect', window, grey) % make the whole screen grey_bkg
        Screen('FillRect',window, [1 0 0], testrect);
        Screen('FrameRect',window, [1 1 0], testrect, 30);
        %   imageTexture(imnumber) = Screen('MakeTexture', window, theImage(:,:,:,imnumber));
        DrawFormattedText(window, sprintf('Loading... %d',imcount), 'center', 'center', textcolor, [], []);
        disp(sprintf('Loading... %d',imcount))
        
        if stereoModeOn
            Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
            Screen('FillRect', window, grey) % make the whole screen grey_bkg
            Screen('FillRect',window, [1 0 0], testrect);
            Screen('FrameRect',window, [1 1 0], testrect, 30);
            %   imageTexture(imnumber) = Screen('MakeTexture', window, theImage(:,:,:,imnumber));
            DrawFormattedText(window, sprintf('Loading... %d',imcount), 'center', 'center', textcolor, [], []);
        end
        
        vbl = Screen('Flip', window);
    end
    
    
    % load spider web
    theImageLocation = sprintf('%s/SpiderWebBackground.png',dir);
    [SpiderWeb, ~, alphaspider] = imread(theImageLocation);
    SpiderTex(1) = Screen('MakeTexture', window, SpiderWeb);
    SpiderWeb(:,:,4) = alphaspider;
    SpiderTex(2) = Screen('MakeTexture', window, SpiderWeb);
    
    
    %load the fixation images
    theImageLocation = sprintf('%s/fixA.png',dir);
    [fixA, ~, alphafixA] = imread(theImageLocation);
    fixATex(1) = Screen('MakeTexture', window, fixA);
    fixA(:,:,4) = alphafixA;
    fixATex(2) = Screen('MakeTexture', window, fixA);
    
    theImageLocation = sprintf('%s/fixB.png',dir);
    [fixB, ~, alphafixB] = imread(theImageLocation);
    fixBTex(1) = Screen('MakeTexture', window, fixB);
    fixB(:,:,4) = alphafixB;
    fixBTex(2) = Screen('MakeTexture', window, fixB);
    
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if stereoModeOn
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    end
    DrawFormattedText(window, 'Finished', 'center', 'center', textcolor, [], []);
    if stereoModeOn
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        DrawFormattedText(window, 'Finished', 'center', 'center', textcolor, [], []);
    end
    %for devbug
    imSize = 1910;
    baseRect = [0 0 imSize imSize];
    texturerectangle = CenterRectOnPointd(baseRect * sizemultiplier,...
        xCenter, yCenter);
    Screen('DrawTexture', window, texture2(1), [], texturerectangle, [], 0);
    vbl = Screen('Flip', window);
    
    WaitSecs(2);
    
    
    %% present instructions and wait for trigger
    if stereoModeOn
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    end
    Screen('FillRect', window, grey) % make the whole screen grey_bkg
    
    instructions = 'Please fixate at the center at all times \n \n Press with index finger when you see color change \n \n Standby for Scanner Trigger';
    DrawFormattedText(window, instructions, 'center', 'center', textcolor, [], []);
    
    if stereoModeOn
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        Screen('FillRect', window, grey) % make the whole screen grey_bkg
        DrawFormattedText(window, instructions, 'center', 'center', textcolor, [], []);
    end
    
    %flip to screen
    Screen('TextSize', window, 20);
    vbl = Screen('Flip', window);
    
    
    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)
    
    disp('Waiting for scanner trigger...')
    
    [secs, keyCode, deltaSecs]=    KbStrokeWait([-1]);
    
    while ~keyCode(scannertrigger) %while not trigger
        [keyIsDown, secs, keyCode] = KbCheck([-1]);% Check the keyboard to see if a button has been pressed
    end
    disp('Trigger detected')
    DisableKeysForKbCheck(scannertrigger); % now disable the scanner trigger
    vbl = secs; %get timestamp
    KbQueueCreate(deviceindexSubject); %start listening for key presses
    KbQueueStart(deviceindexSubject);
    start_time = secs;
    expt_start = secs;
    
    
    if strcmp(bs_eye,'right')
        fixationpoint = [r_fix_cord1(1), yCenter];
    elseif strcmp(bs_eye,'left')
        fixationpoint = [l_fix_cord1(1), yCenter];
    else
        sca
        if togglegoggle == 1;
            %Close goggles
            % Shut down ARDUINO
            try
                goggles(bs_eye, 'neither', togglegoggle,ard)
            catch
                disp('goggle err')
            end
            ShutdownArd(ard,comPort);
            disp('Arduino is off')
            disp('BS eye undefined!')
        end
    end
    
    
    baseRect = [0 0 imWidth imHeight];
    texturerectangle = CenterRectOnPointd(baseRect * sizemultiplier,...
        fixationpoint(1), yCenter);
    baseRect = [0 0 size(fixA,1) size(fixA,2)];
    fixrectangle = CenterRectOnPointd(baseRect,...
        fixationpoint(1), yCenter);
    baseRect = [0 0 size(SpiderWeb,1) size(SpiderWeb,2)];
    spiderrectangle = CenterRectOnPointd(baseRect,...
        fixationpoint(1), yCenter);
    
    %% %%%%% FIX 12 s %%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Task
    curr_frame = 1;
    start_time = vbl;
    fix_start = vbl;
    
    totalframes = 12/ifi;
    taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
    
    respmade = 0;
    
    stim_dur_for_debug = NaN;
    nflips_for_debug = NaN;
    
    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)
    
    while vbl - start_time < ((12/ifi - 0.2)*ifi)%time is under 12 s
        
        if stereoModeOn
            Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        end
        Screen('FillRect', window, grey) % make the whole screen grey_bkg
        Screen('DrawTexture', window, SpiderTex(2), [], spiderrectangle, 0); %Draw
        
        if stereoModeOn
            Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
            Screen('FillRect', window, grey) % make the whole screen grey_bkg
            Screen('DrawTexture', window, SpiderTex(2), [], spiderrectangle, 0); %Draw
        end
    
        
        if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/ifi) %if between taskframe and taskframe + 1s
            %show alternative fix
            if curr_frame == taskframe %if the very first frame
                startSecs = GetSecs(); %rough onset of alternative fix
                disp('Task!')
            end
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
            end
            Screen('DrawTexture', window, fixATex(2), [], fixrectangle, 0); %Draw() %red
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
                Screen('DrawTexture', window, fixATex(2), [], fixrectangle, 0); %Draw() %red
            end
            %   disp(num2str(curr_frame))
            %   disp(num2str(taskframe))
            %   disp('alternative')
            
        else
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
            end
            Screen('DrawTexture', window, fixBTex(2), [], fixrectangle, 0); %Draw %blue
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
                Screen('DrawTexture', window, fixBTex(2), [], fixrectangle, 0); %Draw %blue
            end
            % disp(num2str(curr_frame))
            % disp(num2str(taskframe))
            % disp('normal')
        end
        
        vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
        curr_frame = curr_frame + 1; %increment frame counter
        
        % record responses
        [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
        [keyIsDown, secs, keyCode] = KbCheck([-1]);
        pressedKeys = KbName(firstPress); %which key
        timeSecs = firstPress(find(firstPress)); %what time
        if pressed %report the keypress for the experimenter to see
            % Again, fprintf will give an error if multiple keys have been pressed
            fprintf('"%s" typed at time %.3f seconds, []  Fix  \r\n', KbName(firstPress), timeSecs - startSecs);
            fprintf(fileID,'"%s" typed at time %.3f seconds []  Fix  \r\n', KbName(firstPress), timeSecs - startSecs);
            RT = timeSecs - startSecs;
            responses{resp,1}= [];
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
                ShutdownArd(ard,comPort);% close goggles
            end
            pressedKeys
            disp('Escape this madness!!')
            % save any data
            fclose(fileID);
            save(filename)
            sca
        end
    end %while
    fix_end = vbl;
    disp(sprintf('Time for first fix: %d', fix_end- fix_start));
    
    if ~respmade %if no response whatsoever
        RT = NaN;
        responses{resp,1}= [];
        responses{resp,2} = 'Fix';
        responses{resp,3} = 'No response';
        responses{resp,4} = RT;
    end
    resp = resp + 1; %update resp counter
    
    %% %%%%%%% Images %%%%%%%%%%%%%%%%%%%%%%%
    
    % Draw the image to the screen, unless otherwise specified PTB will draw
    % the texture full size in the center of the screen.
    
    % % texture1 = Screen('MakeTexture', w, img);
    % % img(:, :, 4) = alpha;
    % % texture2 = Screen('MakeTexture', w, img);
    % %
    
    
    % --- TASK ----
    % Let's show the fix change once every 12s or so (to keep in line with
    % the fix condition task, the localizer and the main expt)
    
    %
    curr_frame = 1;
    start_time = vbl;
    
    totalframes = 12/0.125; %96
    taskframe = round(1/0.125 + ((totalframes-(1/0.125))-1/0.125).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
    TaskNo = 1;
    
    respmade = 0;
    
    curr_time = vbl - expt_start; %last time stamp - start of expt
    requested_time = 12; %12s fix so we should be on timepoint 12.0s
    
    for i = 1:8 %8 repetitions of the cycle
        disp(sprintf('Cycle Number %d', i))
        cycle_start = vbl;
        nexpansions = 512;
        imnumber = [1 2];
        
        for expan = 1:nexpansions
            %linear increase
            %             imSize = imWidth-expansionratiolinear*((nexpansions)-expan);
            %
            %exponential (multiply by a scaling factor each time
            imSize = imWidth/expansionratioexponent^((nexpansions)-expan);
            baseRect = [0 0 imSize imSize];
            texturerectangle = CenterRectOnPointd(baseRect * sizemultiplier,...
                fixationpoint(1), yCenter);
            
            nflip = 0;
            stimstart = vbl;
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
            end
            Screen('FillRect', window, grey) % make the whole screen grey_bkg
            Screen('DrawTexture', window, SpiderTex(2), [], spiderrectangle, 0); %Draw
            
            %         First, the image without the alpha channel.
            %         Screen('DrawTexture', window, texture1(imnumber), [], []);
            
            %         Then, the RGBA texture.
            Screen('DrawTexture', window, texture2(imnumber(1)), [], texturerectangle, [], 0);
            
            %         Screen('DrawTexture', window, imageTexture(imnumber), [], [], 0); %Draw
            
            
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 0);  %LEFR
                Screen('FillRect', window, grey) % make the whole screen grey_bkg
                Screen('DrawTexture', window, SpiderTex(2), [], [], 0); %Draw
                Screen('DrawTexture', window, texture2(imnumber(1)), [], texturerectangle, [], 0);
                DrawFormattedText(window, sprintf('Time for prev stim: %d     N flips %d /n /n Cycle : %d', stim_dur_for_debug,nflips_for_debug,i), 'center', 'center', [1 0 0], [], []);
            end
            
            %invert the image for next trial
            imnumber = fliplr(imnumber);
            
            if debugmode
                if stereoModeOn
                    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
                end
                DrawFormattedText(window, sprintf('Image %d',imnumber), 'center', 'center', [1 0 0], [], []);
            end
            
            if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/0.125) %if between taskframe and taskframe + 1s
                %show alternative fix
                if curr_frame == taskframe %if the very first frame
                    startSecs = GetSecs(); %rough onset of alternative fix
                    disp('Task!')
                end
                if stereoModeOn
                    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
                end
                Screen('DrawTexture', window, fixATex(2), [], fixrectangle, 0); %Draw() %red
                if stereoModeOn
                    Screen('SelectStereoDrawBuffer', window, 0);  %LEFR
                    Screen('DrawTexture', window, fixATex(2), [], fixrectangle, 0); %Draw() %red
                end
                %                 disp(num2str(curr_frame))
                %   disp(num2str(taskframe))
                %                 disp('alternative')
                
            else
                if stereoModeOn
                    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
                end
                Screen('DrawTexture', window, fixBTex(2), [], fixrectangle, 0); %Draw %blue
                if stereoModeOn
                    Screen('SelectStereoDrawBuffer', window, 0);  %LEFR
                    Screen('DrawTexture', window, fixBTex(2), [], fixrectangle, 0); %Draw %blue
                end
                %                 disp(num2str(curr_frame))
                %  disp(num2str(taskframe))
                %                 disp('normal')
            end
            
            
            %     Flip to the screen
            if mod(imnumber,2) == 0 % every 2 stims... show the stim for 1 extra frame
                %                 vbl = Screen('Flip', window, vbl + (nFrames2wait4nextStim) * ifi); %every 8 frames. On ave we need 7.5 frames
                %                 vbl = Screen('Flip', window, vbl + (0.13333333333/ifi - 0.2) * ifi); %every 8 frames. On ave we need 7.5 frames
                %check timing
                curr_time = GetSecs - expt_start;
                requested_time = requested_time + 0.125; %increment by 125 ms
                if curr_time - requested_time > ifi %if one frame over
                    nflip = 7;
                elseif curr_time - requested_time < -ifi %if one frame under
                    nflip = 9;
                else
                    nflip = 8;
                end
                
                vbl = Screen('Flip', window, vbl + ((nflip - 0.2)*ifi)); %every 8 frames. On ave we need 7.5 frames
            else %every 7 frames
                %                 vbl = Screen('Flip', window, vbl + (nFrames2wait4nextStim - 1) * ifi); % try to flip every 125 ms. Get ready to flip 6.5 frames after last, in other words, it will happen
                %                 vbl = Screen('Flip', window, vbl + (0.116666666/ifi - 0.2) * ifi); % try to flip every 125 ms. Get ready to flip 6.5 frames after last, in other words, it will happen
                %check timing
                curr_time = GetSecs - expt_start;
                requested_time = requested_time + 0.125; %increment by 125 ms
                if curr_time - requested_time > ifi %if one frame over
                    nflip = 6;
                elseif curr_time - requested_time < -ifi %if one frame under
                    nflip = 8;
                else
                    nflip = 7;
                end
             vbl = Screen('Flip', window, vbl + ((nflip - 0.2)*ifi));
                % on frame 7. This is 0.116666 ms. So we underrun by 0.00833 on
                % each frame. Every 14 frames, there is a 1 frame deficit so we
                % show the frame again.if mod(imnumber,2) == 0 % every 2 stims... show the stim again to make up for delay
            end
            curr_frame = curr_frame + 1; %update "frame" (125ms image presentation counts as one frame here rather than 1 refresh)
            stimend = vbl;
            disp(sprintf('Time for stim: %d     N flips %d', stimend - stimstart,nflip));
            stim_dur_for_debug = stimend - stimstart;
            nflips_for_debug = nflip;
            DrawFormattedText(window, sprintf('Time for prev stim: %d     N flips %d', stimend - stimstart,nflip), 'center', 'center', textcolor, [], []);
            
            % record responses
            [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
            [keyIsDown, secs, keyCode] = KbCheck([-1]);
            pressedKeys = KbName(firstPress); %which key
            timeSecs = firstPress(find(firstPress)); %what time
            if pressed %report the keypress for the experimenter to see
                % Again, fprintf will give an error if multiple keys have been pressed
                fprintf('"%s" typed at time %.3f seconds, []  Stim  \r\n', KbName(firstPress), timeSecs - startSecs);
                fprintf(fileID,'"%s" typed at time %.3f seconds []  Task No %d  \r\n', KbName(firstPress), timeSecs - startSecs, TaskNo);
                RT = timeSecs - startSecs;
                responses{resp,1}= TaskNo;
                responses{resp,2} = 'Stim';
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
            
            
            
            
            if mod(curr_frame,96) == 0 %every 96 frames...
                
                if ~respmade %if no response whatsoever
                    RT = NaN;
                    responses{resp,1}= TaskNo;
                    responses{resp,2} = 'Stim';
                    responses{resp,3} = 'No response';
                    responses{resp,4} = RT;
                end
                resp = resp + 1; %update resp counter (do we even need this?)
                
                %reset curr_frame
                curr_frame = 1;
                %new task frame
                taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
                %reset response
                respmade = 0;
                %increment task number
                TaskNo = TaskNo+1;
            end
            % %
            % %         if mod(imnumber,2) == 0 % every 2 stims... show the stim again to make up for delay
            % % %             stimstart = vbl;
            % %             Screen('FillRect', window, grey) % make the whole screen grey_bkg
            % %             Screen('DrawTexture', window, SpiderTex(2), [], [], 0); %Draw
            % %
            % %             %         First, the image without the alpha channel.
            % %             %         Screen('DrawTexture', window, texture1(imnumber), [], []);
            % %
            % %             %         Then, the RGBA texture.
            % %             Screen('DrawTexture', window, texture2(imnumber), [], texturerectangle, [], 0);
            % %
            % %             %         Screen('DrawTexture', window, imageTexture(imnumber), [], [], 0); %Draw
            % %             DrawFormattedText(window, sprintf('Image %d',imnumber), 'center', 'center', [1 0 0], [], []);
            % %
            % %
            % %             if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/0.125) %if between taskframe and taskframe + 1s
            % %                 %show alternative fix
            % %                 if curr_frame == taskframe %if the very first frame
            % %                     startSecs = GetSecs() %rough onset of alternative fix
            % %                 end
            % %                 Screen('DrawTexture', window, fixATex(2), [], [], 0); %Draw() %red
            % %                 %                 disp(num2str(curr_frame))
            % %                 %   disp(num2str(taskframe))
            % %                 %                 disp('alternative')
            % %
            % %             else
            % %                 Screen('DrawTexture', window, fixBTex(2), [], [], 0); %Draw %blue
            % %                 %                 disp(num2str(curr_frame))
            % %                 %  disp(num2str(taskframe))
            % %                 %                 disp('normal')
            % %             end
            % %
            % %
            % %             %     Flip to the screen
            % %             vbl = Screen('Flip', window, vbl + (1 - 0.2) * ifi); % repeat ONE extra frame here
            % % %             curr_frame = curr_frame + 1; %update "frame" (125ms image presentation counts as one frame here rather than 1 refresh)
            % %             stimend = vbl;
            % %             disp(sprintf('Time for stim: %d', stimend - stimstart));
            % %
            % %             % record responses
            % %             [pressed, firstPress]=KbQueueCheck();
            % %             pressedKeys = KbName(firstPress); %which key
            % %             timeSecs = firstPress(find(firstPress)); %what time
            % %             if pressed %report the keypress for the experimenter to see
            % %                 % Again, fprintf will give an error if multiple keys have been pressed
            % %                 fprintf('"%s" typed at time %.3f seconds, []  Stim  \r\n', KbName(firstPress), timeSecs - startSecs);
            % %                 fprintf(fileID,'"%s" typed at time %.3f seconds []  Task No %d  \r\n', KbName(firstPress), timeSecs - startSecs, TaskNo);
            % %                 RT = timeSecs - startSecs;
            % %                 responses{resp,1}= TaskNo;
            % %                 responses{resp,2} = 'Stim';
            % %                 responses{resp,3} = pressedKeys;
            % %                 responses{resp,4} = RT;
            % %                 respmade = 1;
            % %             else
            % %
            % %             end
            % %             % end of response recording
            % %
            % %
            % %             if max(strcmp(pressedKeys,'ESCAPE'))
            % %                 goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
            % %                 if togglegoggle == 1
            % %                     ShutdownArd(ard,comPort);
            % %                 end
            % %                 %             close goggles
            % %                 %             save any data
            % %                 pressedKeys
            % %                 disp('Escape this madness!!')
            % %                 fclose(fileID);
            % %                 sca
            % %             end
            % %
            % %
            % %
            % %
            % %             if mod(curr_frame,96) == 0 %every 96 frames...
            % %
            % %                 if ~respmade %if no response whatsoever
            % %                     RT = NaN;
            % %                     responses{resp,1}= TaskNo;
            % %                     responses{resp,2} = 'Stim';
            % %                     responses{resp,3} = 'No response';
            % %                     responses{resp,4} = RT;
            % %                 end
            % %                 resp = resp + 1; %update resp counter (do we even need this?)
            % %
            % %                 %reset curr_frame
            % %                 curr_frame = 1;
            % %                 %new task frame
            % %                 taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
            % %                 %reset response
            % %                 respmade = 0;
            % %                 %increment task number
            % %                 TaskNo = TaskNo+1;
            % %             end
            % %         end %repeat stim
            
        end %stim
        cycle_end = vbl;
        disp(sprintf('Time for cycle: %d', cycle_end - cycle_start));
        
    end %cycle
    %
    start_time = vbl;
    fix_start = vbl;
    %% %%% 12s fix %%%%%%%%%%%%%%%%%%
    
    % Task
    curr_frame = 1;
    start_time = vbl;
    
    totalframes = 12/ifi;
    taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
    
    respmade = 0;
    
    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)
    
    
    while vbl - start_time < ((12/ifi - 0.2)*ifi)%time is under 12 s
        Screen('FillRect', window, grey) % make the whole screen grey_bkg
        Screen('DrawTexture', window, SpiderTex(2), [], spiderrectangle, 0); %Draw
        
        if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/ifi) %if between taskframe and taskframe + 1s
            %show alternative fix
            if curr_frame == taskframe %if the very first frame
                startSecs = GetSecs() %rough onset of alternative fix
            end
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
            end
            Screen('DrawTexture', window, fixATex(2), [], fixrectangle, 0); %Draw() %red
             if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
                Screen('DrawTexture', window, fixATex(2), [], fixrectangle, 0); %Draw() %red
            end
            %                 disp(num2str(curr_frame))
            %   disp(num2str(taskframe))
            %                 disp('alternative')
            
        else
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
            end
            Screen('DrawTexture', window, fixBTex(2), [], fixrectangle, 0); %Draw %blue
            if stereoModeOn
                Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
                Screen('DrawTexture', window, fixBTex(2), [], fixrectangle, 0); %Draw %blue
            end
            %                 disp(num2str(curr_frame))
            %  disp(num2str(taskframe))
            %                 disp('normal')
        end
        
        vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
        curr_frame = curr_frame +1;
        
        fix_end = vbl;
        
        % record responses
        [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
        [keyIsDown, secs, keyCode] = KbCheck([-1]);
        pressedKeys = KbName(firstPress); %which key
        timeSecs = firstPress(find(firstPress)); %what time
        if pressed %report the keypress for the experimenter to see
            % Again, fprintf will give an error if multiple keys have been pressed
            fprintf('"%s" typed at time %.3f seconds, []  Fix  \r\n', KbName(firstPress), timeSecs - startSecs);
            fprintf(fileID,'"%s" typed at time %.3f seconds []  Fix  \r\n', KbName(firstPress), timeSecs - startSecs);
            RT = timeSecs - startSecs;
            responses{resp,1}= [];
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
    disp(sprintf('Time for first fix: %d', fix_end- fix_start));
    expt_end = vbl;
    
    if ~respmade %if no response whatsoever
        RT = NaN;
        responses{resp,1}= [];
        responses{resp,2} = 'Fix';
        responses{resp,3} = 'No response';
        responses{resp,4} = RT;
    end
    resp = resp + 1; %update resp counter
    
    %% the end
    DrawFormattedText(window, sprintf('The End!'), 'center', 'center', [1 0 0], [], []);
    vbl = Screen('Flip', window);
    WaitSecs(2);
    
catch ERR
    rethrow(ERR)
    if togglegoggle == 1;
        %Close goggles
        % Shut down ARDUINO
        goggles(bs_eye, 'neither', togglegoggle,ard)
        ShutdownArd(ard,comPort);
        disp('Arduino is off')
        fclose(fileID);
        save(filename)
    end
    sca
end
if togglegoggle == 1;
    %Close goggles
    % Shut down ARDUINO
    goggles(bs_eye, 'neither', togglegoggle,ard)
    ShutdownArd(ard,comPort);
    disp('Arduino is off')
    
end
save(filename)
fclose(fileID);

disp(sprintf('Total run time: %d', expt_end-expt_start))

sca
