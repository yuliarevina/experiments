% FYP Project experiment script.
% Is filled in information more reliable and help you on an orientation
% task?
% Replication of Ehinger et al. 2017 study

% Yulia Revina, NTU, Singapore, 2020


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get some hardware info %%%%%%%%%%%%%%%%%%%%%%%

% if ~IsWin
    devices = PsychHID('Devices');
% end
keyboardind = GetKeyboardIndices();
mouseind = GetMouseIndices();


KbName('UnifyKeyNames')

% for linux try additional params when hiding cursor

% HideCursor([screenid=0][, mouseid])

% By default, the cursor of screen zero on Linux, and all screens on
% Windows and Mac OS/X is hidden. 'mouseid' defines which of multiple
% cursors shall be hidden on Linux. The parameter is silently ignored
% on other systems.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


    
todaydate  = date;

stereoModeOn = 1; %don't need this for goggles, only for the 2 screen setup
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

distance2screen = 42; % how many centimeters from eye to screen? To make this portable on different machines

% outside_BS = 5; %deg of visual angle
% outside_BS = round(deg2pix_YR(outside_BS)); %in pixels for our screen

% brightness = 0.1;
% brightness = 0.7; % for debugging
textcolor = [0 0 0];
    
% % timing
% goggle_delay = 0.35; %seconds to keep lens closed after stim offset, to account for slow fade out of stim

% GAMMA CORRECTION
% load CLUT_Station4_1152x864_100Hz_27_Apr_2016.mat

% ASK FOR SUBJECT DETAILS

subCode = input('Enter Subject Code:   ');
subAge = input('Enter Subject Age in yrs:   ');
subGender = input('Enter Subject Gender:   ');
feedbackYes = input('Give Feedback?:   ')

filename = sprintf('Data_%s_%s_%s_%s.mat', todaydate, subCode, num2str(subAge), subGender);
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

PsychImaging('PrepareConfiguration')

% PsychImaging('AddTask', 'LeftView', 'DisplayColorCorrection', 'LookupTable');
% PsychImaging('AddTask', 'RightView', 'DisplayColorCorrection', 'LookupTable');


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

% % % % correct non-linearity from CLUT
% if ~IsWin
%     oldCLUT= Screen('LoadNormalizedGammaTable', screenNumber, clut);
% end


% Open an on screen window and color it grey

if stereoModeOn
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey_bkg, [], [], [], stereoMode); % StereoMode 4 for side by side
    leftScreenRect = windowRect;
    rightScreenRect = windowRect;
    if stereoMode == 10
        Screen('OpenWindow', screenNumber, 128, [], [], [], stereoMode);
    end
else %just open one window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey_bkg);
end


KbStrokeWait(-1)



% 
% 
% load CLUT_Station3_1152x864_100Hz_20_Jun_2018.mat
% %clut = 1-clut; %for debug
% PsychColorCorrection('SetLookupTable', window, clut, 'LeftView');
% 
% load CLUT_Station2_1152x864_100Hz_18_Jun_2018.mat
% PsychColorCorrection('SetLookupTable', window, clut, 'RightView');
% 

% % Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
% % GAMMA CORRECTION
% % load CLUT_Station4_1152x864_100Hz_27_Apr_2016.mat
% % 
% % % % correct non-linearity from CLUT
% % if ~IsWin
% %     oldCLUT= Screen('LoadNormalizedGammaTable', window, clut, [], 0);
% % end
% % Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
% % GAMMA CORRECTION
% % load CLUT_Station2_1152x864_100Hz_27_Apr_2016.mat
% % 
% % % % correct non-linearity from CLUT
% % if ~IsWin
% %     oldCLUT= Screen('LoadNormalizedGammaTable', window, clut, [], 1);
% % end




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
one =  KbName('1!');
two =  KbName('2@');
three = KbName('3#');
four = KbName('4$');
five = KbName('5%');

% Need mouse control for blind spot measurements
sinceLastClick = 0;
mouseOn = 1;
lastKeyTime = GetSecs;
SetMouse(xCenter,yCenter,window);
WaitSecs(.1);
[mouseX, mouseY, buttons] = GetMouse(window);




%% Fix frame

% Fixation point on the RIGHT
% fp_offset = 400;
fp_offset = 0; %no offset, center of screen
% frame
frameSizeH = 1140;
frameSizeV = 850;

% %debug on smaller screens
% frameSizeH = 500;
% frameSizeV = 500;

rightFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
leftFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
[center(1), center(2)] = RectCenter(windowRect);
fix_r1 = 8;
fix_r2 = 4; 
fix_cord1 = [center-fix_r1 center+fix_r1] ;
fix_cord2 = [center-fix_r2 center+fix_r2] ;
l_fix_cord1 = [center-fix_r1 center+fix_r1] + [fp_offset 0 fp_offset 0];
l_fix_cord2 = [center-fix_r2 center+fix_r2] + [fp_offset 0 fp_offset 0];
r_fix_cord1 = [center-fix_r1 center+fix_r1] - [fp_offset 0 fp_offset 0];
r_fix_cord2 = [center-fix_r2 center+fix_r2] - [fp_offset 0 fp_offset 0];
% Screen('FillOval', rightFixWin, uint8(white), l_fix_cord1);
% Screen('FillOval', rightFixWin, uint8(black), l_fix_cord2);

ShowFix()

% Two crosses in and lower
Screen('DrawText',leftFixWin, '+', center(1), 200,white);
Screen('DrawText',leftFixWin, '+', center(1), 864-200,white);
Screen('DrawText',rightFixWin, '+', center(1), 200,white);
Screen('DrawText',rightFixWin, '+', center(1), 864-200,white);

% Frame
frameRect = CenterRect([0 0 frameSizeH frameSizeV],windowRect);
Screen('FrameRect',leftFixWin, [0 256 0], frameRect, 4);
Screen('FrameRect',rightFixWin, [256 0 0], frameRect, 4);
%DEBUG
% Screen('DrawText',rightFixWin,'Adjust UPPER grating!',300,400,white,[],[],1);

% Fixation point on the LEFT
% leftFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
% Screen('FillOval', leftFixWin, uint8(white), r_fix_cord1);
% Screen('FillOval', leftFixWin, uint8(black), r_fix_cord2);
ShowFix()
% 
% Two crosses in and lower
Screen('DrawText',leftFixWin, '+', center(1), 200,white);
Screen('DrawText',leftFixWin, '+', center(1), 864-200,white);

% Frame
% frameRect = CenterRect([0 0 frameSize frameSize],windowRect);




%% ---------------
%  Intro screen  |
%-----------------
%show fix
try
    
    
    % Select left-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    %    draw fixation dot
    Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
    
    % Screen('FillRect', leftFixWin, grey) % make the whole screen grey_bkg
    ShowFix()
    
    instructions = 'Hello and welcome \n \n to the experiment for perceptual filling-in \n \n Press any key to continue';
    DrawFormattedText(window, instructions, 'center', 'center', textcolor, [], 1);
    
    
    % Select left-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    %    draw fixation dot
    Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
    
    ShowFix()
    
    instructions = 'Hello and welcome \n \n to the experiment for perceptual filling-in \n \n Press any key to continue';
    DrawFormattedText(window, instructions, 'center', 'center', textcolor, [], 1);


    %flip to screen
    Screen('Flip', window);
    KbStrokeWait(-1);



%% BLIND SPOT MEASUREMENT

% % Measure blind spot if we dont have the measurements already
% ------------------------------

%if any of the files are missing, redo BS measurements
if ~exist('BS_diameter_h_r') || ~exist('BS_diameter_v_r') || ~exist('BS_diameter_h2_r') ...
        || ~exist('BS_diameter_h_l') || ~exist('BS_diameter_v_l') || ~exist('BS_diameter_h2_l');
    
    % LEFT screen
    % Select left-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    %    draw fixation dot
    Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
    ShowFix()
    % instructions
     Screen('TextSize', window, 20);
    DrawFormattedText(window, 'Let''s measure the blindspot! \n \n Click the mouse when the flickering marker \n \n completely disappears for you \n \n Take your time, this step is very important! \n \n Press any key...', 'center', 'center', textcolor, [], 1);
    
    % RIGHT screen
    % Select left-eye image buffer for drawing:
    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    %    draw fixation dot
    Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
    % instructions
      Screen('TextSize', window, 20);
    DrawFormattedText(window, 'Let''s measure the blindspot! \n \n Click the mouse when the flickering marker \n \n completely disappears for you \n \n Take your time, this step is very important! \n \n Press any key...', 'center', 'center', textcolor, [], 1);
    ShowFix()
    
    
    
   
    % FLIP
    Screen('Flip', window);
    KbStrokeWait(-1);
    
%     goggles(bs_eye, 'BS', togglegoggle,ard)
%     if togglegoggle == 1;
%         ToggleArd(ard,'LeftOff') % close left eye so we can look with our right and measure BS
%     end

    if IsLinux 
        HideCursor(1,0)
    else
        HideCursor()
    end
% 

% Let's measure LEFT BS first
bs_eye = 'left';
% RIGHT screen
% Select left-eye image buffer for drawing:
Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
%    draw fixation dot
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
  Screen('TextSize', window, 20);
DrawFormattedText(window, '<<---------------- Left Blindspot', 'center', 'center', textcolor, [], 1);
ShowFix()



% LEFT screen
% Select left-eye image buffer for drawing:
Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
%draw fixation dot
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
  Screen('TextSize', window, 20);
DrawFormattedText(window, '<<---------------- Left Blindspot', 'center', 'center', textcolor, [], 1);
ShowFix()
Screen('Flip', window);
WaitSecs(5.5)

measure_BS_h_YR_stereo    %horizontal
measure_BS_v_YR_stereo    %vertical
measure_BS_h2_YR_stereo   %measure horizontal again based on the midline of vertical (bcos BS is not exactly centered on horiz merid)


% Then measure RIGHT BS
bs_eye = 'right';

% LEFT screen
% Select left-eye image buffer for drawing:
Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
%draw fixation dot
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
  Screen('TextSize', window, 20);
DrawFormattedText(window, 'Right Blindspot ---------------->>', 'center', 'center', textcolor, [], 1);
ShowFix()

% RIGHT screen
% Select left-eye image buffer for drawing:
Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
%    draw fixation dot
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
  Screen('TextSize', window, 20);
DrawFormattedText(window, 'Right Blindspot ---------------->>', 'center', 'center', textcolor, [], 1);
ShowFix()
Screen('Flip', window);
WaitSecs(5.5)


measure_BS_h_YR_stereo    %horizontal
measure_BS_v_YR_stereo    %vertical
measure_BS_h2_YR_stereo   %measure horizontal again based on the midline of vertical (bcos BS is not exactly centered on horiz merid)

ShowCursor()

%     Screen('FillRect', window, grey) % make the whole screen grey_bkg
%     measure_BS_h_YR_1screen    %horizontal
%     measure_BS_v_YR_1screen    %vertical
%     measure_BS_h2_YR_1screen   %measure horizontal again based on the midline of vertical (bcos BS is not exactly centered on horiz merid)
% %     goggles(bs_eye, 'both', togglegoggle,ard)
% %     if togglegoggle == 1;
% %         ToggleArd(ard,'LensOn') %put goggles back on
% %     end
%     ShowCursor()
end % check if BS exist



% Show the BS locations

%%%%%%%%%%%%%%%%% LEFT SCREEN
% Left BS
% Select left-eye image buffer for drawing:
Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
%draw fixation dot
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
ShowFix()
%draw a blindspot oval to test its location
oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l);
% show blind spot
Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
  Screen('TextSize', window, 20);
DrawFormattedText(window, 'This is the location of blindspot \n \n Check you cannot see it', 'center', 'center', textcolor, [],1);


%%%%%%%%%%%%%%%%%% RIGHT SCREEN
% RIGHT BS
% Select left-eye image buffer for drawing:
Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
%    draw fixation dot
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
ShowFix()
%draw a blindspot oval to test its location
oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r);
% show blind spot
Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
  Screen('TextSize', window, 20);
DrawFormattedText(window, 'This is the location of blindspot \n \n Check you cannot see it', 'center', 'center', textcolor, [],1);


Screen('Flip', window);

KbStrokeWait(-1);


% %draw a blindspot oval to test its location
% oval_rect = [0 0 BS_diameter_h2 BS_diameter_v];
% oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2, BS_center_v);
%                                                                            
% ShowFix()
% 
% % show blind spot  
% Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
% if strcmp(bs_eye, 'right')
%      DrawFormattedText(window, 'This is the location of blindspot \n \n Check you cannot see it \n \n by closing your LEFT eye and fixating on the +', 'center', 'center', textcolor, [],[]);
% else
%      DrawFormattedText(window, 'This is the location of blindspot \n \n Check you cannot see it \n \n by closing your RIGHT eye and fixating on the +', 'center', 'center', textcolor, [],[]);
% end
% 
% Screen('Flip', window);
% KbStrokeWait;


%% Stimuli specifications

% ------------------
%%% GRATING %%%%%
% -------------------   

% grating to be BS size + say 3 deg either side (check how much Ehinger
% had). So width + 3 on each side, height + 3 on each side. This might be
% limited due to our screen size/ mirror size. But cannot go too small cos
% you wont get filling in

%make a square grating texture
cyclesPerDeg = 0.89; 
% orientations_real = [30 37.5 45 52.5 60]; %7.5 deg
orientations_real = [22.5 30 37.5 45 52.5 60 67.5]; %7.5 deg
% orientations_real = [25 35 45 55 65]; %for debug
% orientations_real = [5 25 45 65 85]; %for debug
orientations = 360 - orientations_real; %because the image will be mirrored in our set up
condition = [0 1]; %0 = both BS; 1 = both fellow
maxsize= 2000; %px, for example
gratingType = 'sine';
maxContrast= 1;
durationGrating = 0.5; %500ms

degaroundgrating = 1; %how many degrees on each side of grating to add (has to be bigger than blindspot otherwise
% we wouldn't see anything)
pixaroundgrating = deg2pix_YR(degaroundgrating);

%calculate size of grating -> maximum of the 4 diameters + the extra
%padding on both sides. This way we get a circle that is the same size for
%each eye, with at least X deg padding (as defined above). L and R BS would
%be diff sizes but if we have diff sized gratings then maybe it's not such
%a good comparison. Or maybe we want to have them very different, because
%we are just comparing the slope for FELLOW and the slope for BS. As long
%as the task is equally hard for both. Doesn't matter if one eye has a
%smaller grating and hence is harder to judge. To be decided....
sizeofgrating = max([BS_diameter_h2_l BS_diameter_h2_r BS_diameter_v_l BS_diameter_v_r]) +pixaroundgrating*2;
sizeofgratingindeg = pix2deg_YR(sizeofgrating)

cyclesPerWholeGrating = pix2deg_YR(maxsize) .* cyclesPerDeg;
period = maxsize./cyclesPerWholeGrating;

%not using this here
% % %get a one and 3 quarter cycle near the middle of the whole grating
% % % to set symmetrical xoffsets later
% % mean_cycles = round(cyclesPerWholeGrating(midCS)/2); %+ [1 3]./4;

% Define Half-Size of the grating image.
texsize=maxsize / 2;

% This is the visible size of the grating. It is twice the half-width
% of the texture plus one pixel to make sure it has an odd number of
% pixels and is therefore symmetric around the center of the texture:
visiblesize=2*texsize+1;

grating2 = [];


% create textures for the gratings
f = 1/period;
fr = f*2*pi;
inc = white-grey;
x = meshgrid(0:maxsize-1, 1);

switch gratingType
    case 'square'
        grating(1,:) = grey + maxContrast*inc*sign(sin(fr*x));
    case 'sine'
        %                 grating(p,t,:) = grey + tcos(t)*maxContrast*inc*sin(fr*x);
        %                 grating(p,t,:) = (grey + tcos(t)*maxContrast*inc*sin(fr*x)) * 0.2;
        %                 grating2(p,t,:) = (grey + maxContrast*inc*sin(fr*x)) ; %removed the tcos. We need the same contrast every frame
        grating2(1,:) = ((grey + maxContrast*inc*sin(fr*x)));
end
gratingtex = Screen('MakeTexture', window, (grating2(1,:)), [], 1,2);

baseRect = [0 0 maxsize maxsize];
gratingrectRIGHTeye = CenterRectOnPointd(baseRect, BS_center_h2_r, BS_center_v_r);
gratingrectLEFTeye = CenterRectOnPointd(baseRect, BS_center_h2_l, BS_center_v_l);

%         BS_oval_RIGHT = [0 0 BS_diameter_h2_r + pixaroundgrating*2, BS_diameter_v_r + pixaroundgrating*2]; % x2 because we need to add to top AND bottom, left AND right
%         BS_oval_LEFT = [0 0 BS_diameter_h2_l + pixaroundgrating*2, BS_diameter_v_l + pixaroundgrating*2];

Stim_oval_RIGHT = [0 0 sizeofgrating sizeofgrating];
Stim_oval_LEFT = [0 0 sizeofgrating sizeofgrating];

BS_oval_RIGHT = [0 0 BS_diameter_h2_r BS_diameter_v_r ];
BS_oval_LEFT = [0 0 BS_diameter_h2_l BS_diameter_v_l];

Stim_oval_RIGHT = CenterRectOnPointd(Stim_oval_RIGHT, BS_center_h2_r, BS_center_v_r);
Stim_oval_LEFT = CenterRectOnPointd(Stim_oval_LEFT, BS_center_h2_l, BS_center_v_l);

BS_oval_RIGHT = CenterRectOnPointd(BS_oval_RIGHT, BS_center_h2_r, BS_center_v_r);
BS_oval_LEFT = CenterRectOnPointd(BS_oval_LEFT, BS_center_h2_l, BS_center_v_l);

aperture(1)=Screen('OpenOffscreenwindow', window, grey); %right
aperture(2)=Screen('OpenOffscreenwindow', window, grey); %left

% Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
%    draw fixation dot


% Make inset texture
BS_size_pix = min([(BS_diameter_h2_r), (BS_diameter_v_r), (BS_diameter_h2_l), (BS_diameter_v_l)])
[x, y] = meshgrid(-BS_size_pix/4:1:BS_size_pix/4, -BS_size_pix/4:1:BS_size_pix/4);

inset = grating2(1:size(x,1)); % half the size of the BS
% figure; imagesc(inset), colormap gray

% % % Make a gaussian aperture with the "alpha" channel
% % gaussDim = 50;
% % gaussSigma = gaussDim / 3;
% % [xm, ym] = meshgrid(-gaussDim:gaussDim, -gaussDim:gaussDim);
% % gauss = exp(-(((xm .^2) + (ym .^2)) ./ (2 * gaussSigma^2)));
% % [s1, s2] = size(gauss);
% % mask = ones(s1, s2, 2) * grey;
% % mask(:, :, 2) = white * (1 - gauss);
% % masktex = Screen('MakeTexture', window, mask);


% 
% [x, y] = meshgrid(-floor(length(inset)/2):1:ceil(length(inset)/2), -floor(length(inset)/2):1:ceil(length(inset)/2));
% [x, y] = meshgrid(-(length(inset)/2):1:(length(inset)/2), -(length(inset)/2):1:(length(inset)/2));


% parameters for the gaussian blob
a1 = 1; %amplitude
b1 = 0;
b2 = 0;
c1 = (BS_size_pix/4.0-5)/2; % standard deviation, 
c2 = (BS_size_pix/4.0-5)/2; % SD in the other orientation since we have an oval

trim = 0.05;

%complete formula for oval gaussian
gauss = a1.*exp(-(((x-b1)./c1).^2+((y-b2)./c2).^2));

figure; imagesc(gauss); colormap gray
%best to trim the gaussian otherwise it displays a bit rectangular...
gauss(gauss < trim) = 0; %trim anything below trim value ie just change to zero
% gauss(gauss>1) = 1; % "flatten" the peak. Change anything bigger than 1 to 1. We need the end matrix to be between 0 and 1

%This time we create a two layer texture fill
% the first layer with the background color and then place the gauss
% texure in the second 'alpha' layer


[x, y] = meshgrid(-BS_size_pix/3.5:1:BS_size_pix/3.5, -BS_size_pix/3.5:1:BS_size_pix/3.5);
% parameters for the gaussian blob
a1 = 3.5; %amplitude
b1 = 0;
b2 = 0;
c1 = (BS_size_pix/3-5)/2; % standard deviation, 
c2 = (BS_size_pix/3-5)/2; % SD in the other orientation since we have an oval

trim = 0.05;

%complete formula for oval gaussian
gaussGrayBlob = a1.*exp(-(((x-b1)./c1).^2+((y-b2)./c2).^2));


%best to trim the gaussian otherwise it displays a bit rectangular...
gaussGrayBlob(gaussGrayBlob < trim) = 0; %trim anything below trim value ie just change to zero
gaussGrayBlob(gaussGrayBlob>1) = 1; % "flatten" the peak. Change anything bigger than 1 to 1. We need the end matrix to be between 0 and 1
figure; imagesc(gaussGrayBlob); colormap gray

contrast = 1;
[s1, s2] = size(gaussGrayBlob);
maskGray = ones(s1, s2, 1) .* 0.5; %just makes grey bkg
maskGray(:,:,2) = 0.5;
maskGray(:,:,3) = 0.5;
figure; image(maskGray); colormap 
maskGray(:, :, 4)= gaussGrayBlob; %makes transparency following the gaussian vals, visible in the middle, transparent edges
maskTexture1 = Screen('MakeTexture', window, maskGray); %make into a texture



%make second mask to smooth grating, display this on top of gray-blob-masktexture1
InsetBlob = repmat(inset, length(inset),1); %just makes grey bkg
InsetBlob(:, :, 2)= gauss; %makes transparency following the gaussian vals, transparent middle
InsetTexture = Screen('MakeTexture', window, InsetBlob); %make into a texture

% Order of texture mapping
% 1) Display grating
% 2) Display gray bkg for inset
% 3) Display inset grating



% ---------------
%%% MASK 
% ---------------
maxsize= 100; 

% % % uniform noise
% % maskgrid1 = rand(maxsize,maxsize); %uniform random ns
% % maskgrid2 = rand(maxsize,maxsize); %uniform random ns
% % maskgrid3 = rand(maxsize,maxsize); %uniform random ns
% % maskgrid4 = rand(maxsize,maxsize); %uniform random ns
% % maskgrid5 = rand(maxsize,maxsize); %uniform random ns

% sine noise
maskgrid1 = sin(linspace(0,2*pi,maxsize^2));
maskgrid1_shuff = Shuffle(maskgrid1);
maskgrid1_reshape = reshape(maskgrid1_shuff,maxsize,maxsize);

maskgrid2 = sin(linspace(0,2*pi,maxsize^2));
maskgrid2_shuff = Shuffle(maskgrid2);
maskgrid2_reshape = reshape(maskgrid2_shuff,maxsize,maxsize);

maskgrid3 = sin(linspace(0,2*pi,maxsize^2));
maskgrid3_shuff = Shuffle(maskgrid3);
maskgrid3_reshape = reshape(maskgrid3_shuff,maxsize,maxsize);

maskgrid4 = sin(linspace(0,2*pi,maxsize^2));
maskgrid4_shuff = Shuffle(maskgrid4);
maskgrid4_reshape = reshape(maskgrid4_shuff,maxsize,maxsize);

maskgrid5 = sin(linspace(0,2*pi,maxsize^2));
maskgrid5_shuff = Shuffle(maskgrid5);
maskgrid5_reshape = reshape(maskgrid5_shuff,maxsize,maxsize);



maskgridtex(1) = Screen('MakeTexture', window, maskgrid1_reshape, [], 1,2);
maskgridtex(2) = Screen('MakeTexture', window, maskgrid2_reshape, [], 1,2);
maskgridtex(3) = Screen('MakeTexture', window, maskgrid3_reshape, [], 1,2);
maskgridtex(4) = Screen('MakeTexture', window, maskgrid4_reshape, [], 1,2);
maskgridtex(5) = Screen('MakeTexture', window, maskgrid5_reshape, [], 1,2);
durationMask = 0.5; % 500ms


%% Procedure and trials specifications

% (1) Percept:
%       0 = Unambiguous
%       1 = Ambiguous
% (2) Eye
%       0 = Fellow Eye only
%       1 = Right BS
%       2 = Left BS
%       3 = Both BS
% (3) Inset
%       0 = None
%       1 = Right
%       2 = Left
% (4) Orientation
%       0 = Vertical
%       90 = Horizontal
% (5) RT (in seconds)
% (6) Confidence
%       1 = Low
%       2 = Intermediate
%       3 = High



% EXAMPLE RESULTS MATRIX
% PERCEPT | EYE | INSET | ORIENTATION |  RT  | CONFIDENCE
%   0        0      1         1         0.50       1     UnA FE Only R (15)
%   0        0      2         1         0.456      2     UnA FE Only L (15)
%   0        2      1         2         0.765      1     UnA L-BS R (15)
%   0        1      2         2         1.034      3     UnA R-BS L (15)
%   1        0      0         1         0.470      3     A FE Only None (60
%   1        3      0         2         0.845      1     A Both-BS None (20
%   1        3      1         1         1.09       3     A Both-BS R (20)
%   1        3      2         1         1.235      1     A Both-BS L (20)
%   1        2      0         2         0.654      3     A L-BS None (30)
%   1        1      0         2         0.519      1     A R-BS None (30)
%   1        1      1         2         0.519      1     A R-BS R (30)
%   1        2      2         2         0.519      1     A L-BS L (30)
%  ...          ...             ...             ...     ...         ...


% Number of trials for each condition is different because there is
% balancing for the number of times each percept appears (as opposed to
% physical stim)
% 120 trials = Unambig
% 120 trials = Ambiguous Fellow Eye only
% 120 trials = Ambiguous Both BS
% 120 trials = Ambiguous R BS
% 120 trials = Ambiguous L BS




rng('shuffle'); % randomize the random number generator. Otherwise

% nrepetitions = 30; %show each unique condition 50 times

% condsvector = [zeros(1,7) ones(1,7) 2*ones(1,7)]';

% add conditions manually because we don't have every combination of
% parameters so hard to do a loop


% For training it's different:
%First column
% 0 = Fellow L
% 1 = Fellow R
% 2 = BS L
% 3 = BS R
% Second column
% 0 = No inset
% 1 = Inset
% Third column
% Orientation

% Show each condition 6 times (3 for each orientation

conditions = [  repmat([0 0], 3, 1); ... % 
                repmat([1 0], 3, 1); ...
                repmat([2 0], 3, 1); ...
                repmat([3 0], 3, 1); ...
                repmat([0 1], 3, 1); ... % 
                repmat([1 1], 3, 1); ...
                repmat([2 1], 3, 1); ...
                repmat([3 1], 3, 1); ...
                ];
conditions = repmat(conditions,2, 1)  ;       
conditions(1:24, 3) = 0; %add orientations
conditions(25:48, 3) = 90; %add orientations


% allconds = [condsvector orientationvector];

% allconds(:,3:6) = NaN; %make columns for other varibles

% experimentalconditions = repmat(allconds,nrepetitions,1); %all conditions for the experiment: eg each cond x 50 = 500 trials
% 
% experimentalconditions(1:size(experimentalconditions,1)/2, 3) = 1; %half of trials = standard left
% experimentalconditions(size(experimentalconditions,1)/2 + 1:end, 3) = 2; %half of trials = standard right
% 
% %select the order of the conditions
% %shuffle rows
condsorder = randperm(size(conditions,1)); %this is the order of the conditions for each subject

curr_response = 0; %store current response on trial n, just initializing the variable here
respmade = 0; %logical variable, response made or not yet


%% Demo

InsetRect = [0 0 BS_size_pix/2 BS_size_pix/2];
InsetRectLeft = CenterRectOnPointd(InsetRect, BS_center_h2_l, BS_center_v_l)
InsetRectRight = CenterRectOnPointd(InsetRect, BS_center_h2_r, BS_center_v_r)

GrayBlobRect = [0 0 (1.5*BS_size_pix)/2 (1.5*BS_size_pix)/2];
GrayBlobRectLeft = CenterRectOnPointd(GrayBlobRect, BS_center_h2_l, BS_center_v_l)
GrayBlobRectRight = CenterRectOnPointd(GrayBlobRect, BS_center_h2_r, BS_center_v_r)

% RIGHT BS INSET
Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
Screen('CopyWindow', rightFixWin, aperture(1), [], rightScreenRect); %Always Right fix frame because this is right screen
Screen('FillOval', aperture(1), [1 1 1 0], Stim_oval_RIGHT); %right BS aperture
Screen('DrawTexture', window, gratingtex, [], gratingrectRIGHTeye, []) % FULL GRATING %Right screen -> RIGHT BS position
Screen('DrawTexture', window, aperture(1), [], [], 0) %right aperture mask
Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectRight, 0) %gray blob
Screen('DrawTexture', window, InsetTexture, [], InsetRectRight, 90) %Inset
DrawFormattedText(window, 'Right BS inset', 'center', 100, textcolor, [], 1);
ShowFix()

%draw a blindspot oval to test its location
oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r);
% show blind spot
Screen('FrameOval', window, [1 0.2 0.2], oval_rect_centred);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% LEFT BS INSET
Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
Screen('CopyWindow', leftFixWin, aperture(2), [], rightScreenRect);
Screen('FillOval', aperture(2), [1 1 1 0], Stim_oval_LEFT); %right BS aperture
Screen('DrawTexture', window, gratingtex, [], gratingrectLEFTeye, []) % FULL GRATING 
Screen('DrawTexture', window, aperture(2), [], [], 0) %right aperture mask
Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectLeft, 0) %gray blob
Screen('DrawTexture', window, InsetTexture, [], InsetRectLeft, 90) %Inset
DrawFormattedText(window, 'Left BS inset', 'center', 100, textcolor, [], 1);
ShowFix()

% %draw a blindspot oval to test its location
% oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l];
% oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l);
% % show blind spot
% Screen('FrameOval', window, [1 0.2 0.2], oval_rect_centred);

Screen('Flip', window)
%make a screenshot
imageArray = Screen('GetImage', window); %omitting rect argument means the whole screen is taken
% imwrite is a Matlab function, not a PTB-3 function
imwrite(imageArray, 'myscreenshot.jpg');
KbStrokeWait(-1);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% RIGHT Fellow INSET
Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
Screen('CopyWindow', rightFixWin, aperture(1), [], rightScreenRect); %Always Right fix frame because this is right screen
Screen('FillOval', aperture(2), [1 1 1 0], Stim_oval_LEFT); %Left BS location
Screen('DrawTexture', window, gratingtex, [], gratingrectLEFTeye, []) % FULL GRATING %Right screen -> LEFT side for BS position
Screen('DrawTexture', window, aperture(2), [], [], 0) %Left aperture mask
Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectLeft, 0) %gray blob
Screen('DrawTexture', window, InsetTexture, [], InsetRectLeft, 90) %Inset
DrawFormattedText(window, 'Left Side Fellow inset', 'center', 100, textcolor, [], 1);
ShowFix()

%draw a blindspot oval to test its location
oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l);
% show blind spot
Screen('FrameOval', window, [1 0.2 0.2], oval_rect_centred);


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% LEFT Fellow INSET
Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
Screen('CopyWindow', rightFixWin, aperture(1), [], leftScreenRect); %Always left fix frame because this is left screen
Screen('FillOval', aperture(1), [1 1 1 0], Stim_oval_RIGHT); %Left BS location
Screen('DrawTexture', window, gratingtex, [], gratingrectRIGHTeye, []) % FULL GRATING %Right screen -> LEFT side for BS position
Screen('DrawTexture', window, aperture(1), [], [], 0) %Left aperture mask
Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectRight, 0) %gray blob
Screen('DrawTexture', window, InsetTexture, [], InsetRectRight, 90) %Inset
DrawFormattedText(window, 'Right Side Fellow inset', 'center', 100, textcolor, [], 1);
ShowFix()

%draw a blindspot oval to test its location
oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r);
% show blind spot
Screen('FrameOval', window, [1 0.2 0.2], oval_rect_centred);


Screen('Flip', window)
KbStrokeWait(-1);
% sca


%% main experimental session

% present gratings either both BS or both Fellow
% present masks
% ask Q - which one was more tilted clockwise e.g. | or /, answer Left or Right


% display texture example syntax
% Screen('DrawTexture', windowPointer, texturePointer [,sourceRect]
% [,destinationRect] [,rotationAngle])

Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
DrawFormattedText(window, 'Press any key to continue. Remember to fixate on the central cross!', 'center', 'center', textcolor, [], 1);


Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
DrawFormattedText(window, 'Press any key to continue. Remember to fixate on the central cross!', 'center', 'center', textcolor, [], 1);
Screen('Flip', window)
 
KbStrokeWait(-1);

corrNumber = 0;

for trialN = 1:size(conditions,1)
    
    % experimental conditions are all trials not in random order
    % condsorder is the predefined random order they will be displayed in
    % trialN = counter for trial number. Go through condsorder one by one and
    % extract the trial specifications from there.
    % e.g. trial 2 -> condsorder(2) = 35. experimentalconditions(35,:) = trial
    % (row) 35 in the big matrix of all possible conditions
    %   row 35 ->>  [0    55     1   NaN   NaN]
    
    %current_trial = experimentalconditions(condsorder(trialN),:)
    
    vbl = GetSecs;
    
    
    
    
    
    % -----------------------------
    % 500 ms blank screen
    % ------------------------------
     Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
     Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
     ShowFix()
     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
     Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
     ShowFix()
     vbl = Screen('Flip', window, vbl + (waitframes - 0.2  ) * ifi);
     
     Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
     Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
     ShowFix()
     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
     Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
     ShowFix()
     vbl = Screen('Flip', window, vbl + (0.5/ifi - 0.2  ) * ifi);
     
     
     
     currcondition = conditions(condsorder(trialN),1)
     currorientation = conditions(condsorder(trialN),3)
     currinset = conditions(condsorder(trialN),2)
     
     
     
%      if currstandardposition == 1 %if standard is left
%          orientation = [orientations(3) currorientation];
%      else %if standard is right
%          orientation = [currorientation orientations(3)];
%      end
     
     
%      disp(sprintf('Trial type: 0 = Fellow Only; 1 = R BS; 2 = L BS; 3 = Both BS: \n %d | \n Orientation: \n %d | \n Inset 0 = none; 1 = Right; 2 = Left: \n %d',currcondition,currorientation,currinset))
     
     
     
     start_time = vbl;
    % ------------------------------
    % present grating
    % -------------------------------
    while vbl - start_time < durationGrating
        % DISPLAY STIMULUS
        
      
        
        % RIGHT SCREEN
        
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        %    draw fixation dot
        Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
        
        if currcondition == 0 % FELLOW L
            % draw L BS stimulus on the right screen. LEFT inset also goes
            % here
            Screen('CopyWindow', rightFixWin, aperture(1), [], rightScreenRect); %Always Right fix frame because this is right screen
            Screen('FillOval', aperture(1), [1 1 1 0], Stim_oval_LEFT); %left BS aperture
            Screen('DrawTexture', window, gratingtex, [], gratingrectLEFTeye, currorientation) % FULL GRATING %Right screen -> LEFT BS position
            Screen('DrawTexture', window, aperture(1), [], [], 0) %right aperture mask
            if currinset == 1 % LEFT inset
                Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectLeft, 0) %gray blob
                Screen('DrawTexture', window, InsetTexture, [], InsetRectLeft, currorientation+90) %Inset
            end
            ShowFix()
        elseif currcondition == 1 % Fellow R
            % Blank
            ShowFix()
        elseif currcondition == 2 % LEFT BS
            % draw L BS stimulus on the left screen
            % draw R BS stimulus on the left screen (fellow eye
            % stimulation)
            % either L or R inset to go on the left screen
            % right screen should just be blank
            ShowFix()
            
        elseif currcondition == 3 % BS R
            % draw R BS on the right screen
            Screen('CopyWindow', rightFixWin, aperture(1), [], rightScreenRect); %Always Right fix frame because this is right screen
            Screen('FillOval', aperture(1), [1 1 1 0], Stim_oval_RIGHT); %Left BS location
            Screen('DrawTexture', window, gratingtex, [], gratingrectRIGHTeye, currorientation) % FULL GRATING %Right screen -> RIGHT side for BS position
            Screen('DrawTexture', window, aperture(1), [], [], 0)%right aperture mask
            if currinset == 1 % RIGHT inset
                Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectRight, 0) %gray blob
                Screen('DrawTexture', window, InsetTexture, [], InsetRectRight, currorientation+90) %Inset
            end
            ShowFix()
        end
        
%         Screen('FillOval', window, [1 0 0], BS_oval_RIGHT);
%         ShowFix()
%         Screen('TextSize', window, 18);
%         Screen('DrawText',window, '+', center(1), 200,white);
%         Screen('DrawText',window, '+', center(1), 1050-200,white);
        
        %LEFT SCREEN
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);%    draw stereo fusion helper lines
        
        if currcondition == 0 % Fellow L
            % Blank
            ShowFix()
        elseif currcondition == 1 % Fellow R
            Screen('CopyWindow', leftFixWin, aperture(2), [], rightScreenRect); %always left fix frame
            Screen('FillOval', aperture(2), [1 1 1 0], Stim_oval_RIGHT);   %right BS aperture 
            Screen('DrawTexture', window, gratingtex, [], gratingrectRIGHTeye, currorientation) %left screen R BS position
            Screen('DrawTexture', window, aperture(2), [], [], 0) %show aperture
            if currinset == 1 % RIGHT inset
                Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectRight, 0) %gray blob
                Screen('DrawTexture', window, InsetTexture, [], InsetRectRight, currorientation+90) %Inset
            end 
            ShowFix()
        elseif currcondition == 2 % L BS
            % L BS on left screen
            % R BS on left screen (fellow eye stimulation)
            % insets goes here
            Screen('CopyWindow', leftFixWin, aperture(2), [], rightScreenRect); %always left fix frame
%             Screen('FillOval', aperture(2), [1 1 1 0], Stim_oval_RIGHT); %right BS aperture
            Screen('FillOval', aperture(2), [1 1 1 0], Stim_oval_LEFT); %left BS aperture
%             Screen('DrawTexture', window, gratingtex, [], gratingrectRIGHTeye, currorientation) %left screen RIGHT BS position
            Screen('DrawTexture', window, gratingtex, [], gratingrectLEFTeye, currorientation) %left screen LEFT BS position
            Screen('DrawTexture', window, aperture(2), [], [], 0) %show aperture         
            if currinset == 1 % LEFT inset
                Screen('DrawTexture', window, maskTexture1, [], GrayBlobRectLeft, 0) %gray blob
                Screen('DrawTexture', window, InsetTexture, [], InsetRectLeft, currorientation+90) %Inset
            end
            ShowFix()
        elseif currcondition == 3 % R BS
            % Blank
            ShowFix()
        end
        
%         Screen('FillOval', window, [1 0 0], BS_oval_LEFT);
%         ShowFix()
%         % Two crosses in and lower
%         Screen('TextSize', window, 18);
%         Screen('DrawText',window, '+', center(1), 200,white);
%         Screen('DrawText',window, '+', center(1), 1050-200,white);
        
        
        vbl = Screen('Flip', window, vbl + (waitframes - 0.2  ) * ifi);
        
    end %while loop
    
%     KbStrokeWait(-1); % for debug
    
    trial_time = vbl-start_time;
%     disp(sprintf('Stim duration: %f', trial_time))
    
    
    start_time = vbl;
    
    %-----------------------------
    %%%%% mask
    %-----------------------------
    
%     while vbl-start_time < durationMask
           
        for i = randperm(5)
            
            start1mask = vbl;
            
            %RIGHT screen
            
            Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
            Screen('CopyWindow', rightFixWin, window, [], rightScreenRect); %stereo fusion helper
            
            if currcondition == 0 % Fellow L
                Screen('DrawTexture', window, maskgridtex(i), [], gratingrectLEFTeye, 0) %LEft
                Screen('DrawTexture', window, aperture(1), [], [], 0)
            elseif currcondition == 1 % Fellow R
                %Blank
%                 Screen('DrawTexture', window, maskgridtex(i), [], gratingrectLEFTeye, 0) %Left
%                 Screen('DrawTexture', window, maskgridtex(i), [], gratingrectRIGHTeye, 0) %Right
%                 Screen('DrawTexture', window, aperture(1), [], [], 0)
            elseif currcondition == 2 % L BS
                % Blank
            elseif currcondition == 3 % R BS
                Screen('DrawTexture', window, maskgridtex(i), [], gratingrectRIGHTeye, 0) %Right
                Screen('DrawTexture', window, aperture(1), [], [], 0)
            end
            
            %             Screen('FillOval', window, [1 0 0], BS_oval_RIGHT);
            ShowFix()
%             Screen('TextSize', window, 18);
%             Screen('DrawText',window, '+', center(1), 200,white);
%             Screen('DrawText',window, '+', center(1), 1050-200,white);
            
            
            % LEFT SCREEN
            
            Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
            Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
            
            if currcondition == 0 % Fellow L
                %blank
               
            elseif currcondition == 1 % Fellow R
                % Blank
                Screen('DrawTexture', window, maskgridtex(i), [], gratingrectRIGHTeye, 0) %left
                Screen('DrawTexture', window, aperture(2), [], [], 0)
            elseif currcondition == 2 % L BS
%                 Screen('DrawTexture', window, maskgridtex(i), [], gratingrectRIGHTeye, 0) %Right
                Screen('DrawTexture', window, maskgridtex(i), [], gratingrectLEFTeye, 0) %Left
                Screen('DrawTexture', window, aperture(2), [], [], 0)
            elseif currcondition == 3 % R BS
                % blank
%                 Screen('DrawTexture', window, maskgridtex(i), [], gratingrectLEFTeye, 0) %Left
%                 Screen('DrawTexture', window, aperture(2), [], [], 0)
            end
            
%             Screen('FrameOval', window, [1 0 0], BS_oval_LEFT, 10); %BS shaped oval, for debugging
            ShowFix()
%             % Two crosses in and lower
%             Screen('TextSize', window, 18);
%             Screen('DrawText',window, '+', center(1), 200,white);
%             Screen('DrawText',window, '+', center(1), 1050-200,white);
            
            vbl = Screen('Flip', window, vbl + (durationMask/5/ifi - 0.2  ) * ifi);
            
            onemaskdur = vbl - start1mask;
            disp(sprintf('One mask duration: %f', onemaskdur))
            disp(sprintf('VBL - start: %f', vbl-start_time))
            
            
        end %for mask texture N
%     end %while loop for mask
    
    % KbStrokeWait(-1);
    
    mask_time = vbl - start_time;
%     disp(sprintf('Mask duration: %f', mask_time))
    
    %------------------------
    % Make response
    % -----------------------
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
    DrawFormattedText(window,'Was there an inset?', 'center','center',[0 0 0], [],1);
    
    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
    DrawFormattedText(window,'Was there an inset?', 'center','center',[0 0 0], [],1);
    Screen('Flip', window);
    
    
    
    resp2Bmade = true;
    curr_response = 0;
    numFrames = 0;
    starttime = GetSecs;
    
    while resp2Bmade %record L or R
        
        [keyIsDown,secs, keyCode] = KbCheck(-1);
        
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
        DrawFormattedText(window,'Was there an inset?', 'center','center',[0 0 0], [],1);
        
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
        DrawFormattedText(window,'Was there an inset?', 'center','center',[0 0 0], [],1);
        Screen('Flip', window);
        
        
        
        if keyIsDown
            if keyCode(escapeKey);
                resp2Bmade = false; endtime = GetSecs; save (filename); sca;
            elseif keyCode(upKey); resp2Bmade = false; curr_response = 1; endtime = GetSecs;
            elseif keyCode(downKey); resp2Bmade = false; curr_response = 2; endtime = GetSecs;
            else
                %just go through the while loop since resp2Bmade is
                %still true
            end %end if
        end
        % if L or R has been pressed, record response
        
              
        
        % Clear screen
        subjectdata(trialN,1) = conditions(condsorder(trialN), 1); % Percept
        subjectdata(trialN,2) = currcondition; %record cond of this trial
        subjectdata(trialN,3) = currinset; % inset
        subjectdata(trialN,4) = currorientation; %record orientation  of this trial
        subjectdata(trialN,5) = curr_response; % Left or right stim more clockwise?
        subjectdata(trialN,6) = secs - starttime; %Record RT
        %     subjectdata(trialN,5) = nexttrial(3); %standard 1st or 2nd
        
        %     subjectdata(trialN,7) = endtime - starttime; % Record RT in secs
       
    end
    
    resp2Bmade = true; %reset response logical variable
    
     while resp2Bmade %record confidence
        
        [keyIsDown,secs, keyCode] = KbCheck(-1);
        
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
        DrawFormattedText(window,'How confident are you about that decision? \n \n 1 - Not at all, 3 - Completely certain', 'center','center',[0 0 0], [],1);
        
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
        DrawFormattedText(window,'How confident are you about that decision? \n \n 1 - Not at all, 3 - Completely certain', 'center','center',[0 0 0], [],1);
        Screen('Flip', window);
        
        
        
        if keyIsDown % for the training block, don't record confidence
            if keyCode(escapeKey);
                resp2Bmade = false; endtime = GetSecs; save (filename); sca;
            elseif keyCode(one); resp2Bmade = false; %curr_response = 1; endtime = GetSecs;
            elseif keyCode(two); resp2Bmade = false; %curr_response = 2; endtime = GetSecs;
            elseif keyCode(three); resp2Bmade = false; %curr_response = 3; endtime = GetSecs;
            elseif keyCode(four); resp2Bmade = false; %curr_response = 4; endtime = GetSecs;
            elseif keyCode(five); resp2Bmade = false; %curr_response = 5; endtime = GetSecs;
            else
                %just go through the while loop since resp2Bmade is
                %still true
            end %end if
        end
        % if L or R has been pressed, record response
        
              
        
%         % Clear screen
%         subjectdata(trialN,7) = curr_response; %Record confidence
%         %     subjectdata(trialN,5) = nexttrial(3); %standard 1st or 2nd
%         
%         %     subjectdata(trialN,7) = endtime - starttime; % Record RT in secs

     end
     
     % Provide Feedback
     
     
     if ((currcondition == 0 || currcondition == 1)&& currinset == 1 && curr_response == 1) || ...
             ((currcondition == 0 || currcondition == 1)&& currinset == 0 && curr_response == 2) || ...
             ((currcondition == 2 || currcondition == 3)&& currinset == 1 && curr_response == 2) || ...
             ((currcondition == 2 || currcondition == 3)&& currinset == 0 && curr_response == 2)
         % Fellow inset present and said yes
         % Fellow inset absent and said no
         % BS inset present and said no
         % BS inset absent and said no
         corrNumber = corrNumber + 1;
         if feedbackYes == 1
             Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
             Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
             DrawFormattedText(window,'Correct! :)', 'center','center',[0 0 0], [],1);
             
             Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
             Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
             DrawFormattedText(window,'Correct! :)', 'center','center',[0 0 0], [],1);
             Screen('Flip', window);
             KbStrokeWait(-1)
         end
         
         
     elseif ((currcondition == 0 || currcondition == 1) && currinset == 1 && curr_response == 2) || ...
             ((currcondition == 0 || currcondition == 1) && currinset == 0 && curr_response == 1) || ...
             ((currcondition == 2 || currcondition == 3) && currinset == 1 && curr_response == 1) || ...
             ((currcondition == 2 || currcondition == 3) && currinset == 0 && curr_response == 1)
         
         % fellow inset present and said no
         % fellow inset absent and said yes
         % bs inset present and said yes
         % bs inset absent and said yes
         if feedbackYes == 1
             Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
             Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
             DrawFormattedText(window,'Incorrect! :(', 'center','center',[0 0 0], [],1);
             
             Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
             Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
             DrawFormattedText(window,'Incorrect! :(', 'center','center',[0 0 0], [],1);
             Screen('Flip', window);
             KbStrokeWait(-1)
         end
     end



    disp(sprintf('Trial %d out of %d completed', trialN, size(conditions,1)))
     
     
     if mod(trialN,50) == 0 %if a block of 50 trials has been completed. ntrials divided by 50 should leave no remainder, ie 150/50 = 3, 50/50 = 1 etc
         Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
         Screen('CopyWindow', leftFixWin, window, [], rightScreenRect)
%          Screen('FillRect', window, grey) % make the whole screen grey
         messagetext = sprintf('Trial %d out of %d completed. \n \n Have a break! \n \n Press UP key to continue \n \n Then Space to start a trial', trialN, length(condsorder));
         DrawFormattedText(window, messagetext, 'center', 'center', [0.2 0.2 0.2],[],1);
         
         Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
         Screen('CopyWindow', rightFixWin, window, [], rightScreenRect)
         messagetext = sprintf('Trial %d out of %d completed. \n \n Have a break! \n \n Press UP key to continue \n \n Then Space to start a trial', trialN, length(condsorder));
         DrawFormattedText(window, messagetext, 'center', 'center', [0.2 0.2 0.2],[],1);

         Screen('Flip', window);
         
         while ~keyCode(upKey)
             [keyIsDown,secs, keyCode] = KbCheck;% Check the keyboard to see if a button has been pressed
         end
     end
     
     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
     Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
     ShowFix();
     DrawFormattedText(window, 'Press space to start next trial', 'center', 'center', [0 0 0],[],1);
     
     Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
     Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
     DrawFormattedText(window, 'Press space to start next trial', 'center', 'center', [0 0 0],[],1);
     ShowFix();
     % DrawFormattedText(window, messagenexttrial, 'center', 'center', white,[],[]);
     Screen('Flip', window);
     
     [secs, keyCode, deltaSecs] = KbStrokeWait(-1); %wait for space
     
     
     while ~keyCode(space) %while something other than space was pressed, don't move on. Unless it's quit demo
         
         [keyIsDown,secs, keyCode] = KbCheck(-1);% Check the keyboard to see if a button has been pressed
         %
         if keyCode(escapeKey)
             save (filename)
             sca %if esc then just quit demo
             break;
         end
         %                 if keyCode(downKey)
         %                     %record red fix thing
         %                     RedFix(ntrials,2) = 1;
         %                     disp('Down Key')
         %                 end
         %                 if keyIsDown
         %                     find(keyCode,1)
         %                 end
         
     end %end while. Move onto next trial
     
end %for trial N


catch ERR
    rethrow(ERR)
end

save (filename)
corrNumber
sca