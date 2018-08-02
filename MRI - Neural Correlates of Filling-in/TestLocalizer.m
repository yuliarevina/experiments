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


% define keyboards used by subject and experimenter
% run KbQueueDemo(deviceindex) to test various indices
deviceindexSubject = []; %possibly MRI keypad
%can only listen to one device though...
% deviceindexExperimenter = 11; %possibly your laptop keyboard


KbName('UnifyKeyNames')


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


filename = sprintf('Localizer_%s_%s_%s_%s.txt', todaydate, subCode, num2str(subAge), subGender);
fileID = fopen(filename,'w');

stereoModeOn = 0; %don't need this for goggles, only for the 2 screen setup
stereoMode = 4;        % 4 for split screen, 10 for two screens
makescreenshotsforvideo = 0;

BS_measurementON = 1;                     

%%% toggle goggles for debugging %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
togglegoggle = 1; % 0 goggles off for debug; 1 = goggles on for real expt
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
load CLUT_Station1_1152x864_100Hz_25_Apr_2016.mat


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
%     oldCLUT= Screen('LoadNormalizedGammaTable', screenNumber, clut);
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


% Need mouse control for blind spot measurements
sinceLastClick = 0;
mouseOn = 1;
lastKeyTime = GetSecs;
SetMouse(xCenter,yCenter,window);
WaitSecs(.1);
[mouseX, mouseY, buttons] = GetMouse(window);


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
leftFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
Screen('FillOval', leftFixWin, uint8(white), r_fix_cord1);
Screen('FillOval', leftFixWin, uint8(black), r_fix_cord2);

% Two crosses in and lower
Screen('DrawText',leftFixWin, '+', center(1), 200,white);
Screen('DrawText',leftFixWin, '+', center(1), 1050-200,white);

% Frame
frameRect = CenterRect([0 0 frameSize frameSize],windowRect);


try
%% set up arduino
if togglegoggle == 1;
    disp('We need to switch on the Arduino...')
    [ard, comPort] = InitArduino;
    disp('Arduino Initiated')
    
    goggles(bs_eye, 'both', togglegoggle,ard)
%     ToggleArd(ard,'LensOn') % need both eyes to view everything up until the actual experiment trials (and for the BS measurement)
    
    % Remember to switch this off if the code stops for any reason. Any
    % Try/Catch routines should have LensOff integrated there...
else
%     ard =[]; %dummy variable in case we are not using goggles
end

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




catch
    disp('Error in your code')
     if togglegoggle == 1;
        %Close goggles
        % Shut down ARDUINO
        goggles(bs_eye, 'neither', togglegoggle,ard)
        ShutdownArd(ard,comPort);
        disp('Arduino is off')
        fclose(fileID);
         sca
     end

end
disp('Everything is fine')
     if togglegoggle == 1;
        %Close goggles
        % Shut down ARDUINO
        goggles(bs_eye, 'neither', togglegoggle,ard)
        ShutdownArd(ard,comPort);
        disp('Arduino is off')
        fclose(fileID);
     end
sca