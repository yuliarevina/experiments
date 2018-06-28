% FYP Project experiment script.
% Do illusory contours go through the blind spot and occluder?


% Yulia Revina, NTU, Singapore, 2018


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

outside_BS = 5; %deg of visual angle
outside_BS = round(deg2pix_YR(outside_BS)); %in pixels for our screen

brightness = 0.1;
% brightness = 0.7; % for debugging
textcolor = [0 0 0];
    
% timing
goggle_delay = 0.35; %seconds to keep lens closed after stim offset, to account for slow fade out of stim

% GAMMA CORRECTION
% load CLUT_Station4_1152x864_100Hz_27_Apr_2016.mat

% ASK FOR SUBJECT DETAILS

subCode = input('Enter Subject Code:   ');
subAge = input('Enter Subject Age in yrs:   ');
subGender = input('Enter Subject Gender:   ');


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

PsychImaging('AddTask', 'LeftView', 'DisplayColorCorrection', 'LookupTable');
PsychImaging('AddTask', 'RightView', 'DisplayColorCorrection', 'LookupTable');


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
grey_bkg = grey



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



% % % !!!!!!!!!!!!!! %CHANGE this to NEW CLUT !!!!!!!!!!!!!!!!!!!!!!

load CLUT_Station4_1152x864_100Hz_27_Apr_2016.mat
PsychColorCorrection('SetLookupTable', window, clut, 'LeftView');

load CLUT_Station2_1152x864_100Hz_27_Apr_2016.mat
% clut = 1-clut; %for debug
PsychColorCorrection('SetLookupTable', window, clut, 'RightView');


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

disp('BS cleared')

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

try
    %BS coords
    % BS_center_h2_l, BS_center_v_l
    % BS_center_h2_r, BS_center_v_r
    
    
    % Stimulus made up of 4 inducer circles and a "kanizsa rectangle"
    % superimposed. Except at the BS side, there will be a curve. To define
    % this, we will use a circle wedge with a predefined radius and angle
    % to make an arc (curve)
    % 
    %             @
    %         @   | @
    %     @       |  @
    % @           |   * arc middle (will also be the BS centre)
    %     @       |  @ 
    %         @   | @
    %             @
    %
    % | = chord of the wedge
    % inducers will be placed at top of chord, bottom of chord and on the
    % other side at some predefined distance
    % finally, need to plot an illusory rectangle with the inducer centres as the 4
    % coords. This will go on top of the circle wedge.
    
    
    %arc middle will be the BS centre
    arc_middle_L = [BS_center_h2_l, BS_center_v_l];
    arc_middle_R = [BS_center_h2_r, BS_center_v_r];
    
    arc_angle = 45; %try a 45 deg angle, maybe can change later
    width_of_stim = deg2pix_YR(10) % define width of kanizsa rect in degrees, try 10deg for now
    inducer_diameter = deg2pix_YR(3) %define inducer circle size (see papers for confirmation, try 3deg for now)
    
    %length of curve, BS height + some value
    arc_length_L = BS_diameter_v_l + deg2pix_YR(2); % BS height plus 2 deg (one deg each side). Can change later
    arc_length_R = BS_diameter_v_r + deg2pix_YR(2);
    
    %radius of circle underlying the arc (needed for further geometric
    %calculations
    radius_L = (180*arc_length_L)/(pi*arc_angle);
    radius_R = (180*arc_length_R)/(pi*arc_angle);
    
    % centre of circle underlying the arc (needed for further geometric
    % calculations
    origin_of_arc_L = [BS_center_h2_l - radius_L, BS_center_v_l];
    origin_of_arc_R = [BS_center_h2_r + radius_R, BS_center_v_r];
    
    %chord legth -> absolute value of formula, otherwise get -ve number
    chord_length_L = abs(radius_L * 2 * sin(arc_angle/2));
    chord_length_R = abs(radius_R * 2 * sin(arc_angle/2));
    
    % top and bottom points of the chord (needed for base rect and other
    % calculations)
    top_point_of_chord_L = [origin_of_arc_L(1) + abs(radius_L* cos(arc_angle/2)), BS_center_v_l + (chord_length_L/2)];
    top_point_of_chord_R = [origin_of_arc_R(1) - abs(radius_R *cos(arc_angle/2)), BS_center_v_r + (chord_length_R/2)];
    bottom_point_of_chord_L = [origin_of_arc_L(1) + abs(radius_L * cos(arc_angle/2)),BS_center_v_l -  (chord_length_L/2)];
    bottom_point_of_chord_R = [origin_of_arc_R(1) - abs(radius_R * cos(arc_angle/2)),BS_center_v_r -  (chord_length_R/2)];
    
    %inducer circle centres for LEFT
    inducer_centre_L(1,1:2) = top_point_of_chord_L; % top of chord
    inducer_centre_L(2,1:2) = bottom_point_of_chord_L; %bottom of chord
    inducer_centre_L(3,1:2) = [top_point_of_chord_L(1) - width_of_stim, top_point_of_chord_L(2)]; % same as 1, but shifted by radius in x
    inducer_centre_L(4,1:2) = [bottom_point_of_chord_L(1) - width_of_stim, bottom_point_of_chord_L(2)]; % same as 2, but shifted by radius in x
    
    %inducer circle centre for RIGHT
    inducer_centre_R(1,1:2) = top_point_of_chord_R; % top of chord
    inducer_centre_R(2,1:2) = bottom_point_of_chord_R; %bottom of chord
    inducer_centre_R(3,1:2) = [top_point_of_chord_R(1) + width_of_stim, top_point_of_chord_R(2)]; % same as 1, but shifted by radius in x
    inducer_centre_R(4,1:2) = [bottom_point_of_chord_R(1) + width_of_stim, bottom_point_of_chord_R(2)]; % same as 2, but shifted by radius in x
    
    %base rectangle for LEFT - use inducer circle centers as the 4 coords
    baseRectL = [inducer_centre_L(3,1:2) inducer_centre_L(2,1:2)]
       
    %base rectangle for RIGHT - use inducer circle centres as the 4 coords
    baseRectR = [inducer_centre_R(1,1:2) inducer_centre_R(1,1:2)]
    
    %define base rectangles for plotting circle wedge. Width = radius,
    %height = chord
    baseRectL_forArc = [origin_of_arc_L(1), origin_of_arc_L(2)-chord_length_L/2, origin_of_arc_L(1)+radius_L, origin_of_arc_L(2)+chord_length_L/2]; %format = x_topcorner, y_topcorner, x_bottomcorner, y_bottomcorner
    baseRectR_forArc = [origin_of_arc_R(1)-radius_R, origin_of_arc_R(2)-chord_length_R/2, origin_of_arc_R(1), origin_of_arc_R(2)+chord_length_R/2]; %format = x_topcorner, y_topcorner, x_bottomcorner, y_bottomcorner
    
    %define inducer circles and centre on 8 locations (4 for each eye/side)
    inducer_rect = [0 0 inducer_diameter inducer_diameter];
    inducer_circle_L_1 = CenterRectOnPoint(inducer_rect, inducer_centre_L(1,1), inducer_centre_L(1,2));
    inducer_circle_L_2 = CenterRectOnPoint(inducer_rect, inducer_centre_L(2,1), inducer_centre_L(2,2));
    inducer_circle_L_3 = CenterRectOnPoint(inducer_rect, inducer_centre_L(3,1), inducer_centre_L(3,2));
    inducer_circle_L_4 = CenterRectOnPoint(inducer_rect, inducer_centre_L(4,1), inducer_centre_L(4,2));
    
    %plot everything on the screen for debug
    
    
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
    
    Screen('FillArc',window,[1 0 0],baseRectL_forArc,90-(arc_angle/2),arc_angle) %centred on 90 deg point
    
    DrawFormattedText(window, 'X', arc_middle_L(1),  arc_middle_L(2), [0 1 0], [],1);
    DrawFormattedText(window, 'X', origin_of_arc_L(1),  origin_of_arc_L(2), [0 1 0], [],1);
    DrawFormattedText(window, 'X', top_point_of_chord_L(1),  top_point_of_chord_L(2), [0 1 0], [],1);
    DrawFormattedText(window, 'X', bottom_point_of_chord_L(1),  bottom_point_of_chord_L(2), [0 1 0], [],1);
    
    disp('leftarc')
    
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
    Screen('FillArc',window,[1 0 0],baseRectR_forArc,90-(arc_angle/2),arc_angle) %centred on 90 deg point
    DrawFormattedText(window, 'X', arc_middle_R(1),  arc_middle_R(2), [0 1 0], [],1);
    DrawFormattedText(window, 'X', origin_of_arc_R(1),  origin_of_arc_R(2), [0 1 0], [],1);
    DrawFormattedText(window, 'X', top_point_of_chord_R(1),  top_point_of_chord_R(2), [0 1 0], [],1);
    DrawFormattedText(window, 'X', bottom_point_of_chord_R(1),  bottom_point_of_chord_R(2), [0 1 0], [],1);
    
    
%     Screen('FillArc',window,[1 1 1],baseRect,45,90)
    
%     baseRect = [0 0 200 200];
%     arc_centre = CenterRectOnPoint(baseRect, BS_center_h2_r, BS_center_v_r);
%     Screen('FillArc',window,[1 0 0],baseRect,45,90)
    
    
    
    Screen('Flip', window);
    disp('rightarc')
    KbStrokeWait(-1);
catch ERR1
    sca
    rethrow('ERR1')
end

sca
end% big try loop