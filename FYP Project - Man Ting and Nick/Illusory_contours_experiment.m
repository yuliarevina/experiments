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


bs_eye_for_this_run = 'right';   %% Right eye has the blind spot. Left fixation spot

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

bs_eye = bs_eye_for_this_run; %reset BS eye variable for the actual task

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



%% Stimuli specifications & plot for debug purposes

try
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%  Task parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     dotpositions = [-1 -0.5 0 0.5 1]; %how many degrees from the arc middle? -ve = inside illusory shape; +ve outside illusory shape
    dotpositions = [-4 -3 -2 -1 0 1 2 3 4]; %how many degrees from the arc middle? -ve = inside illusory shape; +ve outside illusory shape
%     dotpositions = [-4 -2 0 2 4]; %how many degrees from the arc middle? -ve = inside illusory shape; +ve outside illusory shape
    durationStim = 0.400; %secs
    durationDot = 0.100; %secs
    durationMask = 0.400; %secs
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%    MASKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Generate random grey ovals as in Kellman papers
    
    nOvals = 50;
    minWidth = 100; %pix
    maxWidth = 400;
    widths = minWidth + (maxWidth - minWidth).*rand(nOvals,1);
    heights = minWidth + (maxWidth - minWidth).*rand(nOvals,1);
        %  r = a + (b-a).*rand(N,1).
        
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%     PERIPHERAL STIMS         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
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
    width_of_stim = deg2pix_YR(10); % define width of kanizsa rect in degrees, try 10deg for now
    inducer_diameter = deg2pix_YR(5); %define inducer circle size (see papers for confirmation, try 3deg for now)
    
    %length of curve, BS height + some value
    arc_length_L = BS_diameter_v_l + deg2pix_YR(7); % BS height plus 10 deg (5 deg each side). Can change later
    arc_length_R = BS_diameter_v_r + deg2pix_YR(7);
    
    %radius of circle underlying the arc (needed for further geometric
    %calculations
    radius_L = (180*arc_length_L)/(pi*arc_angle);
    radius_R = (180*arc_length_R)/(pi*arc_angle);
    
    % centre of circle underlying the arc (needed for further geometric
    % calculations
    origin_of_arc_L = [BS_center_h2_l - radius_L, BS_center_v_l];
    origin_of_arc_R = [BS_center_h2_r + radius_R, BS_center_v_r];
    
    %chord legth -> absolute value of formula, otherwise get -ve number
    chord_length_L = abs(radius_L * 2 * sind(arc_angle/2));
    chord_length_R = abs(radius_R * 2 * sind(arc_angle/2));
    
    % top and bottom points of the chord (needed for base rect and other
    % calculations)
    top_point_of_chord_L = [origin_of_arc_L(1) + abs(radius_L* cosd(arc_angle/2)), BS_center_v_l - (chord_length_L/2)];
    top_point_of_chord_R = [origin_of_arc_R(1) - abs(radius_R *cosd(arc_angle/2)), BS_center_v_r - (chord_length_R/2)];
    bottom_point_of_chord_L = [origin_of_arc_L(1) + abs(radius_L * cosd(arc_angle/2)),BS_center_v_l +  (chord_length_L/2)];
    bottom_point_of_chord_R = [origin_of_arc_R(1) - abs(radius_R * cosd(arc_angle/2)),BS_center_v_r +  (chord_length_R/2)];
    
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
    baseRectL = [inducer_centre_L(3,1:2) inducer_centre_L(2,1:2)];
       
    %base rectangle for RIGHT - use inducer circle centres as the 4 coords
    baseRectR = [inducer_centre_R(1,1:2) inducer_centre_R(4,1:2)];
    
    %define base rectangles for plotting circle wedge. Width = radius,
    %height = chord
    
    baseRectL_forArc = [0 0 radius_L*2 radius_L*2]; %square with diameter 2*radius
    baseRectL_forArc = CenterRectOnPoint(baseRectL_forArc, origin_of_arc_L(1), origin_of_arc_L(2)); %centre on origin
    
    baseRectR_forArc = [0 0 radius_R*2 radius_R*2]; %square with diameter 2*radius
    baseRectR_forArc = CenterRectOnPoint(baseRectR_forArc, origin_of_arc_R(1), origin_of_arc_R(2)); %centre on origin
    
%     baseRectL_forArc = [origin_of_arc_L(1), origin_of_arc_L(2)-chord_length_L/2, origin_of_arc_L(1)+radius_L, origin_of_arc_L(2)+chord_length_L/2]; %format = x_topcorner, y_topcorner, x_bottomcorner, y_bottomcorner
%     baseRectR_forArc = [origin_of_arc_R(1)-radius_R, origin_of_arc_R(2)-chord_length_R/2, origin_of_arc_R(1), origin_of_arc_R(2)+chord_length_R/2]; %format = x_topcorner, y_topcorner, x_bottomcorner, y_bottomcorner
%     
    %define inducer circles and centre on 8 locations (4 for each eye/side)
    inducer_rect = [0 0 inducer_diameter inducer_diameter];
    inducer_circle_L_1 = CenterRectOnPoint(inducer_rect, inducer_centre_L(1,1), inducer_centre_L(1,2));
    inducer_circle_L_2 = CenterRectOnPoint(inducer_rect, inducer_centre_L(2,1), inducer_centre_L(2,2));
    inducer_circle_L_3 = CenterRectOnPoint(inducer_rect, inducer_centre_L(3,1), inducer_centre_L(3,2));
    inducer_circle_L_4 = CenterRectOnPoint(inducer_rect, inducer_centre_L(4,1), inducer_centre_L(4,2));
    
    inducer_circle_R_1 = CenterRectOnPoint(inducer_rect, inducer_centre_R(1,1), inducer_centre_R(1,2));
    inducer_circle_R_2 = CenterRectOnPoint(inducer_rect, inducer_centre_R(2,1), inducer_centre_R(2,2));
    inducer_circle_R_3 = CenterRectOnPoint(inducer_rect, inducer_centre_R(3,1), inducer_centre_R(3,2));
    inducer_circle_R_4 = CenterRectOnPoint(inducer_rect, inducer_centre_R(4,1), inducer_centre_R(4,2));
    
    %plot everything on the screen for debug
   
        
        %%%%%%%%%%%%%%%%% LEFT SCREEN
        % Left BS
        % Select left-eye image buffer for drawing:
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        
        
        % Put everything on offscreen windows for later fast plotting
        Periphery_Screen_LEFT =Screen('OpenOffscreenWindow',window, grey);
        Screen('FillRect', Periphery_Screen_LEFT, [0 0 0 0], windowRect); %draw transparency (need this, otherwise plots everything on a opaque grey screen)
        
        %draw fixation dot
        %     Screen('CopyWindow', leftFixWin, Periphery_Screen_LEFT, [], leftScreenRect);
        %     ShowFix()
        %draw a blindspot oval to test its location
        oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l];
        oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l);
        % show blind spot
        %     Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
        
        Screen('FillOval', Periphery_Screen_LEFT, [0 0 0], inducer_circle_L_1);
        Screen('FillOval', Periphery_Screen_LEFT, [0 0 0], inducer_circle_L_2);
        
        Screen('FillArc',Periphery_Screen_LEFT,[0.5 0.5 0.5],baseRectL_forArc,90-(arc_angle/2),arc_angle) %centred on 90 deg point
        
        Screen('FillOval', Periphery_Screen_LEFT, [0 0 0], inducer_circle_L_3);
        Screen('FillOval', Periphery_Screen_LEFT, [0 0 0], inducer_circle_L_4);
        
        Screen('FillRect', Periphery_Screen_LEFT, [0.5 0.5 0.5], baseRectL);
        
        %debugging marks
        %     DrawFormattedText(window, 'X', arc_middle_L(1),  arc_middle_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'Or', origin_of_arc_L(1),  origin_of_arc_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'T', top_point_of_chord_L(1),  top_point_of_chord_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'B', bottom_point_of_chord_L(1),  bottom_point_of_chord_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(1,1),  inducer_centre_L(1,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(2,1),  inducer_centre_L(2,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(3,1),  inducer_centre_L(3,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(4,1),  inducer_centre_L(4,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectL_forArc(1),  baseRectL_forArc(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectL_forArc(3),  baseRectL_forArc(4), [0 1 0], [],1);
        
        
        
        
        
        Screen('DrawTextures', window, Periphery_Screen_LEFT);
        ShowFix()
        nx
        ny
        %      DrawFormattedText(window, '*',  middle_of_base_rect_L(1),  middle_of_base_rect_L(2), [0 1 0], [],1);
        disp('leftarc')
    
        %%%%%%%%%%%%%%%%%% RIGHT SCREEN
        % RIGHT BS
        % Select left-eye image buffer for drawing:
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        
        % Put everything on offscreen windows for later fast plotting
        Periphery_Screen_RIGHT =Screen('OpenOffscreenWindow',window, grey);
        
        Screen('FillRect', Periphery_Screen_RIGHT, [0 0 0 0], windowRect);
        
        
        %    draw fixation dot
        %     Screen('CopyWindow', rightFixWin, Periphery_Screen_RIGHT, [], rightScreenRect);
        %     ShowFix()
        %draw a blindspot oval to test its location
        oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r];
        oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r);
        % show blind spot
        %     Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
        
        Screen('FillOval', Periphery_Screen_RIGHT, [0 0 0], inducer_circle_R_1);
        Screen('FillOval', Periphery_Screen_RIGHT, [0 0 0], inducer_circle_R_2);
        
        Screen('FillArc',Periphery_Screen_RIGHT,[0.5 0.5 0.5],baseRectR_forArc,270-(arc_angle/2),arc_angle) %centred on 90 deg point
    
        Screen('FillOval', Periphery_Screen_RIGHT, [0 0 0], inducer_circle_R_3);
        Screen('FillOval', Periphery_Screen_RIGHT, [0 0 0], inducer_circle_R_4);
        
        Screen('FillRect', Periphery_Screen_RIGHT, [0.5 0.5 0.5], baseRectR);
        
        %debugging marks
        %     DrawFormattedText(window, 'X', arc_middle_R(1),  arc_middle_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'X', origin_of_arc_R(1),  origin_of_arc_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'X', top_point_of_chord_R(1),  top_point_of_chord_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'X', bottom_point_of_chord_R(1),  bottom_point_of_chord_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(1,1),  inducer_centre_R(1,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(2,1),  inducer_centre_R(2,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(3,1),  inducer_centre_R(3,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(4,1),  inducer_centre_R(4,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectR_forArc(1),  baseRectR_forArc(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectR_forArc(3),  baseRectR_forArc(4), [0 1 0], [],1);
        %     Screen('FillArc',window,[1 1 1],baseRect,45,90)
        
        %     baseRect = [0 0 200 200];
        %     arc_centre = CenterRectOnPoint(baseRect, BS_center_h2_r, BS_center_v_r);
        %     Screen('FillArc',window,[1 0 0],baseRect,45,90)
        Screen('DrawTextures', window, Periphery_Screen_RIGHT);
        ShowFix()
        nx
        ny
        if Demo
            Screen('Flip', window);
            disp('rightarc')
            KbStrokeWait(-1);
        end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%     FOVEAL STIMS         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %screen center coords
    %from Show Fix function
    centre_of_stim = [xCenter yCenter];

    %initialise vars
    inducer_centre_L_fovea = [NaN NaN; NaN NaN; NaN NaN; NaN NaN];
    inducer_centre_R_fovea = [NaN NaN; NaN NaN; NaN NaN; NaN NaN];
    
    %work out arc middle with respect to rectangle as defined above
    
    middle_of_base_rect_L = [(baseRectL(1) + baseRectL(3))/2, (baseRectL(2) + baseRectL(4))/2]
    middle_of_base_rect_R = [(baseRectR(1) + baseRectR(3))/2, (baseRectR(2) + baseRectR(4))/2]
    
    
    x_offset_arc_L = arc_middle_L(1) - middle_of_base_rect_L(1); %how far is arc away from base rect middle in x?
    x_offset_arc_R = abs(arc_middle_R(1) - middle_of_base_rect_R(1)); %how far is arc away from base rect middle in x?
    
    
    
    %instead BS middle use the new arc middle coords and calculate
    %everything from there as above
    
    arc_middle_L_fovea = [centre_of_stim(1) + x_offset_arc_L, centre_of_stim(2)] % stim will centred on centre of screen (centre_of_stim(1) centre_of_stim(2)), so arc is shifted in x as prev calculated (but no shift in y)
    arc_middle_R_fovea = [centre_of_stim(1) - x_offset_arc_R, centre_of_stim(2)] % stim will centred on centre of screen (nx ny), so arc is shifted in x as prev calculated (but no shift in y)

    
    % centre of circle underlying the arc (needed for further geometric
    % calculations
    origin_of_arc_L_fovea = [arc_middle_L_fovea(1) - radius_L, arc_middle_L_fovea(2)];
    origin_of_arc_R_fovea = [arc_middle_R_fovea(1) + radius_R, arc_middle_R_fovea(2)];
    
%     %chord legth -> absolute value of formula, otherwise get -ve number
%     chord_length_L = abs(radius_L * 2 * sind(arc_angle/2));
%     chord_length_R = abs(radius_R * 2 * sind(arc_angle/2));
    
    % top and bottom points of the chord (needed for base rect and other
    % calculations)
    top_point_of_chord_L_fovea = [origin_of_arc_L_fovea(1) + abs(radius_L* cosd(arc_angle/2)), arc_middle_L_fovea(2) - (chord_length_L/2)];
    top_point_of_chord_R_fovea = [origin_of_arc_R_fovea(1) - abs(radius_R *cosd(arc_angle/2)), arc_middle_R_fovea(2) - (chord_length_R/2)];
    bottom_point_of_chord_L_fovea = [origin_of_arc_L_fovea(1) + abs(radius_L * cosd(arc_angle/2)),arc_middle_L_fovea(2) +  (chord_length_L/2)];
    bottom_point_of_chord_R_fovea = [origin_of_arc_R_fovea(1) - abs(radius_R * cosd(arc_angle/2)),arc_middle_R_fovea(2) +  (chord_length_R/2)];
    
    %inducer circle centres for LEFT
    inducer_centre_L_fovea(1,1:2) = top_point_of_chord_L_fovea; % top of chord
    inducer_centre_L_fovea(2,1:2) = bottom_point_of_chord_L_fovea; %bottom of chord
    inducer_centre_L_fovea(3,1:2) = [top_point_of_chord_L_fovea(1) - width_of_stim, top_point_of_chord_L_fovea(2)]; % same as 1, but shifted by radius in x
    inducer_centre_L_fovea(4,1:2) = [bottom_point_of_chord_L_fovea(1) - width_of_stim, bottom_point_of_chord_L_fovea(2)]; % same as 2, but shifted by radius in x
    
    %inducer circle centre for RIGHT
    inducer_centre_R_fovea(1,1:2) = top_point_of_chord_R_fovea; % top of chord
    inducer_centre_R_fovea(2,1:2) = bottom_point_of_chord_R_fovea; %bottom of chord
    inducer_centre_R_fovea(3,1:2) = [top_point_of_chord_R_fovea(1) + width_of_stim, top_point_of_chord_R_fovea(2)]; % same as 1, but shifted by radius in x
    inducer_centre_R_fovea(4,1:2) = [bottom_point_of_chord_R_fovea(1) + width_of_stim, bottom_point_of_chord_R_fovea(2)]; % same as 2, but shifted by radius in x
    
    %base rectangle for LEFT - use inducer circle centers as the 4 coords
    baseRectL_fovea = [inducer_centre_L_fovea(3,1:2) inducer_centre_L_fovea(2,1:2)]
       
    %base rectangle for RIGHT - use inducer circle centres as the 4 coords
    baseRectR_fovea = [inducer_centre_R_fovea(1,1:2) inducer_centre_R_fovea(4,1:2)]
    
    %define base rectangles for plotting circle wedge. Width = radius,
    %height = chord
    
    baseRectL_forArc_fovea = [0 0 radius_L*2 radius_L*2] %square with diameter 2*radius
    baseRectL_forArc_fovea = CenterRectOnPoint(baseRectL_forArc, origin_of_arc_L_fovea(1), origin_of_arc_L_fovea(2)); %centre on origin
    
    baseRectR_forArc_fovea = [0 0 radius_R*2 radius_R*2] %square with diameter 2*radius
    baseRectR_forArc_fovea = CenterRectOnPoint(baseRectR_forArc, origin_of_arc_R_fovea(1), origin_of_arc_R_fovea(2)); %centre on origin
    
%     baseRectL_forArc = [origin_of_arc_L(1), origin_of_arc_L(2)-chord_length_L/2, origin_of_arc_L(1)+radius_L, origin_of_arc_L(2)+chord_length_L/2]; %format = x_topcorner, y_topcorner, x_bottomcorner, y_bottomcorner
%     baseRectR_forArc = [origin_of_arc_R(1)-radius_R, origin_of_arc_R(2)-chord_length_R/2, origin_of_arc_R(1), origin_of_arc_R(2)+chord_length_R/2]; %format = x_topcorner, y_topcorner, x_bottomcorner, y_bottomcorner
%     
    %define inducer circles and centre on 8 locations (4 for each eye/side)
%     inducer_rect = [0 0 inducer_diameter inducer_diameter];
    inducer_circle_L_1_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_L_fovea(1,1), inducer_centre_L_fovea(1,2));
    inducer_circle_L_2_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_L_fovea(2,1), inducer_centre_L_fovea(2,2));
    inducer_circle_L_3_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_L_fovea(3,1), inducer_centre_L_fovea(3,2));
    inducer_circle_L_4_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_L_fovea(4,1), inducer_centre_L_fovea(4,2));
    
    inducer_circle_R_1_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_R_fovea(1,1), inducer_centre_R_fovea(1,2));
    inducer_circle_R_2_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_R_fovea(2,1), inducer_centre_R_fovea(2,2));
    inducer_circle_R_3_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_R_fovea(3,1), inducer_centre_R_fovea(3,2));
    inducer_circle_R_4_fovea = CenterRectOnPoint(inducer_rect, inducer_centre_R_fovea(4,1), inducer_centre_R_fovea(4,2));
    
    
    %%%%%%%%%%%%%%%     plot everything on the screen for debug
    % ------------------------------------------------------------------------------------------------------------------------------------------------------
    % ------------------------------------------------------------------------------------------------------------------------------------------------------
  
        %%%%%%%%%%%%%%%%% LEFT SCREEN
        % Left BS
        % Select left-eye image buffer for drawing:
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        
        
        % Put everything on offscreen windows for later fast plotting
        Fovea_Screen_LEFT =Screen('OpenOffscreenWindow',window, grey);
        Screen('FillRect', Fovea_Screen_LEFT, [0 0 0 0], windowRect);
        
        %draw fixation dot
        %     Screen('CopyWindow', leftFixWin, Fovea_Screen_LEFT, [], leftScreenRect);
        %     ShowFix()
        %draw a blindspot oval to test its location
        oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l];
        oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l);
        % show blind spot
        %     Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
        
        Screen('FillOval', Fovea_Screen_LEFT, [0 0 0], inducer_circle_L_1_fovea);
        Screen('FillOval', Fovea_Screen_LEFT, [0 0 0], inducer_circle_L_2_fovea);
        
        Screen('FillArc',Fovea_Screen_LEFT,[0.5 0.5 0.5],baseRectL_forArc_fovea,90-(arc_angle/2),arc_angle) %centred on 90 deg point
        
        Screen('FillOval', Fovea_Screen_LEFT, [0 0 0], inducer_circle_L_3_fovea);
        Screen('FillOval', Fovea_Screen_LEFT, [0 0 0], inducer_circle_L_4_fovea);
        
        Screen('FillRect', Fovea_Screen_LEFT, [0.5 0.5 0.5], baseRectL_fovea);
        
        %debugging marks
        %     DrawFormattedText(window, 'X', arc_middle_L(1),  arc_middle_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'Or', origin_of_arc_L(1),  origin_of_arc_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'T', top_point_of_chord_L(1),  top_point_of_chord_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'B', bottom_point_of_chord_L(1),  bottom_point_of_chord_L(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(1,1),  inducer_centre_L(1,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(2,1),  inducer_centre_L(2,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(3,1),  inducer_centre_L(3,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_L(4,1),  inducer_centre_L(4,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectL_forArc(1),  baseRectL_forArc(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectL_forArc(3),  baseRectL_forArc(4), [0 1 0], [],1);
        
        
        
        
        
        Screen('DrawTextures', window, Fovea_Screen_LEFT);
        
        Screen('FillRect', window, [0.5 0.5 0.5], [centre_of_stim(1)-4, centre_of_stim(2) - 4,  centre_of_stim(1) + 4, centre_of_stim(2)+4]);
        
        ShowFix()
        nx
        ny
        %      DrawFormattedText(window, '*',  middle_of_base_rect_L(1),  middle_of_base_rect_L(2), [0 1 0], [],1);
        disp('leftarc')
        
        %%%%%%%%%%%%%%%%%% RIGHT SCREEN
        % RIGHT BS
        % Select left-eye image buffer for drawing:
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        
        % Put everything on offscreen windows for later fast plotting
        Fovea_Screen_RIGHT =Screen('OpenOffscreenWindow',window, grey);
        
        Screen('FillRect', Fovea_Screen_RIGHT, [0 0 0 0], windowRect);
        
        
        %     %    draw fixation dot
        %     Screen('CopyWindow', rightFixWin, Fovea_Screen_RIGHT, [], rightScreenRect);
        %     ShowFix()
        %draw a blindspot oval to test its location
        oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r];
        oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r);
        % show blind spot
        %     Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
        
        Screen('FillOval', Fovea_Screen_RIGHT, [0 0 0], inducer_circle_R_1_fovea);
        Screen('FillOval', Fovea_Screen_RIGHT, [0 0 0], inducer_circle_R_2_fovea);
        
        Screen('FillArc',Fovea_Screen_RIGHT,[0.5 0.5 0.5],baseRectR_forArc_fovea,270-(arc_angle/2),arc_angle) %centred on 90 deg point
        
        Screen('FillOval', Fovea_Screen_RIGHT, [0 0 0], inducer_circle_R_3_fovea);
        Screen('FillOval', Fovea_Screen_RIGHT, [0 0 0], inducer_circle_R_4_fovea);
        
        Screen('FillRect', Fovea_Screen_RIGHT, [0.5 0.5 0.5], baseRectR_fovea);
        
        %debugging marks
        %     DrawFormattedText(window, 'X', arc_middle_R(1),  arc_middle_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'X', origin_of_arc_R(1),  origin_of_arc_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'X', top_point_of_chord_R(1),  top_point_of_chord_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'X', bottom_point_of_chord_R(1),  bottom_point_of_chord_R(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(1,1),  inducer_centre_R(1,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(2,1),  inducer_centre_R(2,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(3,1),  inducer_centre_R(3,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'O',  inducer_centre_R(4,1),  inducer_centre_R(4,2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectR_forArc(1),  baseRectR_forArc(2), [0 1 0], [],1);
        %     DrawFormattedText(window, 'C',  baseRectR_forArc(3),  baseRectR_forArc(4), [0 1 0], [],1);
        %     Screen('FillArc',window,[1 1 1],baseRect,45,90)
        
        %     baseRect = [0 0 200 200];
        %     arc_centre = CenterRectOnPoint(baseRect, BS_center_h2_r, BS_center_v_r);
        %     Screen('FillArc',window,[1 0 0],baseRect,45,90)
        Screen('DrawTextures', window, Fovea_Screen_RIGHT);
        ShowFix()
        nx
        ny
        if Demo
            Screen('Flip', window);
            disp('rightarc')
            KbStrokeWait(-1);
        end %if
    
catch ERR1
    sca
    rethrow('ERR1')
end


%% trials sequence

% condition = 1, 2, 3, 4, 5
% 1. BS (BS eye) (periphery)
% 2. Occluder (Fellow eye) (periphery)
% 3. Control (Fellow eye) (periphery)
% 4. Occluder (Fellow eye) (fovea)
% 5. Control (Fellow eye) (fovea)


% dot position = [- 1 -0.5 0 0.5 1] %degrees away from arc centre (inside or outside of stim)
%   -ve equals inside
%   +ve equals outside
%

%dot eye = 1 - BS; 2 - Fellow
% which eye was the dot flashed in. 
% For the BS it will always be fellow
% For occl and control peri it will always be fellow (cannot flash in BS as
% won't see it)
% For occl and control fovea it will be in BS eye half the time and in
% fellow eye half the time, to control for any effects of presenting the
% dot not in the same eye as the stimulus.


% response = [1 2]
% 1 Inside
% 2 Outside

% RT = reaction time in secs


% EXAMPLE RESULTS MATRIX
% CONDITION | DOT POSITION | DOT EYE | RESP  | RT       
%   1           -1              2        1     0.50         
%   2           -0.5            2        1     0.456        
%   3           0               2        2     0.765        
%   4           0.5             2        1     1.034        
%   5           1               1        2     0.470        
%   1           -1              2        1     0.845        
%   2           -0.5            2        2     1.09         
%   3           0               2        1     1.235            
%   4           0.5             1        2     0.654        
%   5           1               2        1     0.519        
%  ...          ...             ...    ...


rng('shuffle'); % randomize the random number generator. Otherwise

nrepetitions = 6; %show each unique condition 50 times

condsvector = [ones(1,5), 2*ones(1,5), 3*ones(1,5), 4*ones(1,5), 5 *ones(1,5)]';
condsvector = [ones(1,7), 2*ones(1,7), 3*ones(1,7), 4*ones(1,7), 5 *ones(1,7)]';
condsvector = [ones(1,9), 2*ones(1,9), 3*ones(1,9), 4*ones(1,9), 5 *ones(1,9)]';

dotpositionvector = repmat(dotpositions,1,5)';
% dotpositionvector = repmat(dotpositions,1,5)';

allconds = [condsvector dotpositionvector];

allconds(:,3:5) = NaN; %make columns for other varibles

experimentalconditions = repmat(allconds,nrepetitions,1); %all conditions for the experiment: eg each cond x 40 = 1000 trials

ntrialsofeachcond = nrepetitions * 7; %eg 10 x 5 = 50 trials in total of "blind spot"
ntrialsofeachcond = nrepetitions * 9; %eg 10 x 5 = 50 trials in total of "blind spot"
dotEyeVector = [ones(1,ntrialsofeachcond/2), 2*ones(1,ntrialsofeachcond/2)]; %make a vector of 1s and 2s


for i = 4:5 %for conditions 4 and 5 only
    dotEyeVector = dotEyeVector(randperm(length(dotEyeVector))); %shuffle the vector of 1s and 2s
    %to shuffle a vector:     YourVector(randperm(length(YourVector))
    experimentalconditions((experimentalconditions(:,1) == i),3) = dotEyeVector'; %add eye vector to the dotEye column for conds 4 and 5
end

%select the order of the conditions
%shuffle rows
condsorder = randperm(size(experimentalconditions,1)); %this is the order of the conditions for each subject

curr_response = 0; %store current response on trial n, just initializing the variable here
respmade = 0; %logical variable, response made or not yet



%% main experimental session

% present illusory shapes either peripherally or in fovea; BS, occluded or
% control
% Flash probe dot
% ask Q - was the dot inside or outside the illusory shape
%   


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



for trialN = 1:size(experimentalconditions,1)
    
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
     
     
     
     currcondition = experimentalconditions(condsorder(trialN),1);
     currdotposition = experimentalconditions(condsorder(trialN),2);
     currdoteye = experimentalconditions(condsorder(trialN),3);
%      currstandardposition = experimentalconditions(condsorder(trialN),3);
    
    if strcmp(bs_eye, 'left') %if BS eye = left
        dotpositionsinpix = deg2pix_YR(dotpositions); % -ve is lower X values and inside shape
        Periphery_Screen = Periphery_Screen_LEFT;
        Fovea_Screen = Fovea_Screen_LEFT;
    elseif strcmp(bs_eye, 'right')%if BS eye = right
        dotpositionsinpix = -deg2pix_YR(dotpositions); % -ve deg value (inside shape) is higher X values and thus inside shape (cos shape is flipped)
        Periphery_Screen = Periphery_Screen_RIGHT;
        Fovea_Screen = Fovea_Screen_RIGHT;
    end
    
    curr_occluder_offset = deg2pix_YR(2) + (deg2pix_YR(4)-deg2pix_YR(2)).*rand;
    
    disp(sprintf('Trial type: \n \n 1 = BS; 2 = OccPeri; 3 = ControlPeri; 4 = OccFov; 5 = ControlFov: \n \n %d | Dot: %d',currcondition,currdotposition))

     start_time = vbl;
     frame_counter_stim = 0;
     frame_counter_dot = 0;
    % ------------------------------
    % present stim
    % -------------------------------
    while vbl - start_time < durationStim
        % DISPLAY STIMULUS
        
        %LEFT SCREEN
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        % Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);%    draw stereo fusion helper lines
        frame_counter_stim = frame_counter_stim+1;
                
        switch currcondition
            case 1 %BS. Draw Stim on BS side. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix frame
                if strcmp(bs_eye, 'left') %if BS eye = left
                    Screen('DrawTexture', window, Periphery_Screen_LEFT) %show Stim
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    ShowFix() %blank screen
                end
               
            case 2 %Occ Peri. Draw stim on Fellow side. Periphery. Put on occluder. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    Screen('DrawTexture', window, Periphery_Screen_RIGHT) %show Stim
                    oval_rect = [0 0 deg2pix_YR(13) BS_diameter_v_r]; %right BS
                    oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r-curr_occluder_offset, BS_center_v_r); %right BS, centre on BS + (4-6) deg [random number between 4 and 6]
                    % show blind spot shaped occluder
                    Screen('FillRect', window, [0.2 0.2 0.2], oval_rect_centred);
                    ShowFix() %blank screen
                end
                
            case 3 %Control Peri. Draw stim on Fellow side. Periphery. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    Screen('DrawTexture', window, Periphery_Screen_RIGHT) %show Stim
                    ShowFix() %blank screen
                end
                
            case 4 %Occ Fov. Draw stim on Fellow side. Fovea. Put on occluder. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    Screen('DrawTexture', window, Fovea_Screen_RIGHT) %show Stim
                    oval_rect = [0 0 deg2pix_YR(13) BS_diameter_v_r]; %right BS
                    oval_rect_centred = CenterRectOnPoint(oval_rect, arc_middle_R_fovea(1)-curr_occluder_offset, arc_middle_R_fovea(2)); %right centred on arc middle
                    % show blind spot shaped occluder
                    Screen('FillRect', window, [0.2 0.2 0.2], oval_rect_centred);
                    ShowFix() %blank screen
                end
            case 5 %%Control Peri. Draw stim on Fellow side. Fovea. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    Screen('DrawTexture', window, Fovea_Screen_RIGHT) %show Stim
                    ShowFix() %blank screen
                end
        end
        
        
        
        %display BSs for debug
        if Demo
            oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r]; %right BS
            oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r); %right BS
            Screen('FrameOval', window, [0 1 0], oval_rect_centred);
            oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l]; %left BS
            oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l); %right BS
            Screen('FrameOval', window, [0 0 1], oval_rect_centred);
        end
        
        % RIGHT SCREEN
        
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        %    draw fixation dot
        Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
        
      
         switch currcondition
            case 1 %BS. Draw Stim on BS side. Flash dot on Fellow side
%                 Screen('CopyWindow', rightFixWin, window, [], rightScreenRect); %always right fix frame
                if strcmp(bs_eye, 'left') %if BS eye = left
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    Screen('DrawTexture', window, Periphery_Screen_RIGHT) %show Stim
                    ShowFix() %blank screen
                end
               
            case 2 %Occ Peri. Draw stim on Fellow side. Periphery. Put on occluder. Flash dot on Fellow side
%                 Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    Screen('DrawTexture', window, Periphery_Screen_LEFT) %show Stim
                    oval_rect = [0 0 deg2pix_YR(13) BS_diameter_v_l]; %left BS, make a rectangle as an occluder
                    oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l+curr_occluder_offset, BS_center_v_l); %left BS
                    % show rectangular occluder
                    Screen('FillRect', window, [0.2 0.2 0.2], oval_rect_centred);
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    ShowFix() %blank screen
                end
                
            case 3 %Control Peri. Draw stim on Fellow side. Periphery. Flash dot on Fellow side
%                 Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    Screen('DrawTexture', window, Periphery_Screen_LEFT) %show Stim
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    ShowFix() %blank screen
                end
                
            case 4 %Occ Fov. Draw stim on Fellow side. Fovea. Put on occluder. Flash dot on Fellow side
%                 Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    Screen('DrawTexture', window, Fovea_Screen_LEFT) %show Stim
                    oval_rect = [0 0 deg2pix_YR(13) BS_diameter_v_l]; %left BS
                    oval_rect_centred = CenterRectOnPoint(oval_rect, arc_middle_L_fovea(1)+curr_occluder_offset, arc_middle_L_fovea(2)); %left centred on arc middle
                    % show rectangular occluder
                    Screen('FillRect', window, [0.2 0.2 0.2], oval_rect_centred);
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    ShowFix() %blank screen
                end
            case 5 %%Control Peri. Draw stim on Fellow side. Fovea. Flash dot on Fellow side
%                 Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    Screen('DrawTexture', window, Fovea_Screen_LEFT) %show Stim
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    ShowFix() %blank screen
                end
         end
         
         %display BSs for debug
         if Demo
             oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r]; %right BS
             oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r); %right BS
             Screen('FrameOval', window, [0 1 0], oval_rect_centred);
             oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l]; %left BS
             oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l); %right BS
             Screen('FrameOval', window, [0 0 1], oval_rect_centred);
         end
         
         
         % present dot for the last 50 ms of stim duration
         
         if vbl - start_time >= (durationStim - durationDot)
             %calculate dot coords and screen side
             frame_counter_dot = frame_counter_dot+1;
             
             if currcondition == 1 || currcondition == 2 || currcondition == 3 %if peripheral
                 
                 if strcmp(bs_eye, 'left') %if BS eye = left
                     dotpositionsinpix = deg2pix_YR(currdotposition); % -ve is lower X values and inside shape
                     dotcoords = [arc_middle_L(1) + dotpositionsinpix; arc_middle_L(2)];
                     Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT (fellow eye screen for dot)
                 elseif strcmp(bs_eye, 'right')%if BS eye = right
                     dotpositionsinpix = -deg2pix_YR(currdotposition); % -ve deg value (inside shape) is higher X values and thus inside shape (cos shape is flipped)
                     dotcoords = [arc_middle_R(1) + dotpositionsinpix; arc_middle_R(2)];
                     Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
                 end
          
             else %foveal conditions
                 
                  if strcmp(bs_eye, 'left') %if BS eye = left
                     dotpositionsinpix = deg2pix_YR(currdotposition); % -ve is lower X values and inside shape
                     dotcoords = [arc_middle_L_fovea(1) + dotpositionsinpix; arc_middle_L_fovea(2)];
                     
                     if currdoteye == 1 %BS eye
                         Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
                     else %if 2 (fellow) or NaN just present to fellow as normal
                         Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
                     end
                     
                 elseif strcmp(bs_eye, 'right')%if BS eye = right
                     dotpositionsinpix = -deg2pix_YR(currdotposition); % -ve deg value (inside shape) is higher X values and thus inside shape (cos shape is flipped)
                     dotcoords = [arc_middle_R_fovea(1) + dotpositionsinpix; arc_middle_R_fovea(2)];
                     
                     if currdoteye == 1 %BS
                         Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
                     else
                         Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
                     end
                     
                 end
            
             end
             
         %present dot
         dot_rect = [0 0 10 10]; %dot size
         dot_rect_centred = CenterRectOnPoint(dot_rect, dotcoords(1),dotcoords(2)); %
         Screen('FillOval', window, [1 0 0], dot_rect_centred);   
             
         end %if last 50ms 
         
        
         
         vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi);
         
                
                
                
% %         if currcondition == 1 %draw right BS at right BS location, RIGHT BS coords on RIGHT side of the screen
% %             Screen('CopyWindow', rightFixWin, aperture(1), [], rightScreenRect); %Always Right fix frame because this is right screen
% %             Screen('FillOval', aperture(1), [1 1 1 0], Stim_oval_RIGHT); %right BS aperture
% %             Screen('DrawTexture', window, gratingtex, [], gratingrectRIGHTeye, orientation(2)) % FULL GRATING %Right screen -> RIGHT BS position
% %             Screen('DrawTexture', window, aperture(1), [], [], 0) %right aperture mask
% %             ShowFix()
% %         elseif currcondition == 2 %fellow eye; draw left BS at left side (but still on right screen)
% %             Screen('CopyWindow', rightFixWin, aperture(2), [], rightScreenRect); %Always Right fix frame because this is right screen
% %             Screen('FillOval', aperture(2), [1 1 1 0], Stim_oval_LEFT); %Left BS location
% %             Screen('DrawTexture', window, gratingtex, [], gratingrectLEFTeye, orientation(2)) % FULL GRATING %Right screen -> LEFT side for BS position
% %             Screen('DrawTexture', window, aperture(2), [], [], 0)
% %             ShowFix()
% %         else % fellow eye with occluder (annulus condition). Identical to fellow eye cond but put an occluder the size of the BS on the middle
% %             Screen('CopyWindow', rightFixWin, aperture(2), [], rightScreenRect); %Always Right fix frame because this is right screen
% %             Screen('FillOval', aperture(2), [1 1 1 0], Stim_oval_LEFT); %Left BS location
% %             Screen('DrawTexture', window, gratingtex, [], gratingrectLEFTeye, orientation(2)) % FULL GRATING %Right screen -> LEFT side for BS position
% %             Screen('DrawTexture', window, aperture(2), [], [], 0)
% %             Screen('FillOval', window, [0.5 0.5 0.5], BS_oval_LEFT) %add grey annulus the size of the BS
% %             ShowFix()
% %         end
% %         
       
        
    end% while
    
     frame_counter_stim;
     frame_counter_dot;
    
     if Demo
         KbStrokeWait(-1);
     end
    
    % display mask
    
    %generate random widths and heights
    widths = minWidth + (maxWidth - minWidth).*rand(nOvals,1);
    heights = minWidth + (maxWidth - minWidth).*rand(nOvals,1);
    
    %generate random centre positions within the rectangle defined by inducer
    %centres
    
    
    %initialize vars
    oval_positions_R_fovea = [1:nOvals; 1:nOvals]';
    oval_positions_L_fovea = [1:nOvals; 1:nOvals]';
    oval_positions_R = [1:nOvals; 1:nOvals]';
    oval_positions_L = [1:nOvals; 1:nOvals]';
    
    
    % use base rectangles from above
    
    makebiggerbyNpix = 100; %add some pixels to the base rectangle so the ovals appear more spread out
    
    oval_positions_R_fovea(:,1) = [(baseRectR_fovea(1)-makebiggerbyNpix) + ((baseRectR_fovea(3)+makebiggerbyNpix) - (baseRectR_fovea(1)-makebiggerbyNpix)).*rand(nOvals,1)]; %x coords
    oval_positions_R_fovea(:,2) = [(baseRectR_fovea(2)-makebiggerbyNpix) + ((baseRectR_fovea(4)+makebiggerbyNpix) - (baseRectR_fovea(2)-makebiggerbyNpix)).*rand(nOvals,1)]; %y coords
    
    oval_positions_L_fovea(:,1) = [(baseRectL_fovea(1)-makebiggerbyNpix) + ((baseRectL_fovea(3)+makebiggerbyNpix) - (baseRectL_fovea(1)-makebiggerbyNpix)).*rand(nOvals,1)]; %x coords
    oval_positions_L_fovea(:,2) = [(baseRectL_fovea(2)-makebiggerbyNpix) + ((baseRectL_fovea(4)+makebiggerbyNpix) - (baseRectL_fovea(2)-makebiggerbyNpix)).*rand(nOvals,1)]; %y coords
    
    
    oval_positions_R(:,1) = [(baseRectR(1)-makebiggerbyNpix) + ((baseRectR(3)+makebiggerbyNpix) - (baseRectR(1)-makebiggerbyNpix)).*rand(nOvals,1)]; %x coords
    oval_positions_R(:,2) = [(baseRectR(2)-makebiggerbyNpix) + ((baseRectR(4)+makebiggerbyNpix) - (baseRectR(2)-makebiggerbyNpix)).*rand(nOvals,1)]; %y coords
    
    oval_positions_L(:,1) = [(baseRectL(1)-makebiggerbyNpix) + ((baseRectL(3)+makebiggerbyNpix) - (baseRectL(1)-makebiggerbyNpix)).*rand(nOvals,1)]; %x coords
    oval_positions_L(:,2) = [(baseRectL(2)-makebiggerbyNpix) + ((baseRectL(4)+makebiggerbyNpix) - (baseRectL(2)-makebiggerbyNpix)).*rand(nOvals,1)]; %y coords
    
  
%     baseRectR_fovea
%     baseRectL_fovea
%     baseRectR
%     baseRectL
    
    
    %generate all the base rectangles for all ovals
    
    baseRectGreyOval = [zeros(nOvals,1), zeros(nOvals,1), widths, heights ];
    baseRectGreyOval_centred_R_fovea = CenterRectOnPointd(baseRectGreyOval, oval_positions_R_fovea(:,1), oval_positions_R_fovea(:,2));
    baseRectGreyOval_centred_L_fovea = CenterRectOnPointd(baseRectGreyOval, oval_positions_L_fovea(:, 1), oval_positions_L_fovea(:, 2));
    baseRectGreyOval_centred_R = CenterRectOnPointd(baseRectGreyOval, oval_positions_R(:,1), oval_positions_R(:,2));
    baseRectGreyOval_centred_L = CenterRectOnPointd(baseRectGreyOval, oval_positions_L(:,1), oval_positions_L(:,2));
    
        
    % generate random shades of grey (50 shades of grey for 50 ovals, for
    % example)
    
    minGrey = 0;
    maxGrey = 1;
    fiftyshadesofgrey = minGrey + (maxGrey - minGrey).*rand(nOvals,1); %generate greys between min and max
        
    %draw to screen
    
     %LEFT SCREEN
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        % Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);%    draw stereo fusion helper lines
        frame_counter_stim = frame_counter_stim+1;
                
        switch currcondition
            case 1 %BS. Draw Stim on BS side. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix frame
                if strcmp(bs_eye, 'left') %if BS eye = left
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L(i,:));
                    end
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R(i,:));
                    end
                    ShowFix() %blank screen
                end
                
            case 2 %Occ Peri. Draw stim on Fellow side. Periphery. Put on occluder. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L(i,:));
                    end
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R(i,:));
                    end
                    ShowFix() %blank screen
                end
                
            case 3 %Control Peri. Draw stim on Fellow side. Periphery. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L(i,:));
                    end
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R(i,:));
                    end
                    ShowFix() %blank screen
                end
                
            case 4 %Occ Fov. Draw stim on Fellow side. Fovea. Put on occluder. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L_fovea(i,:));
                    end
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R_fovea(i,:));
                    end
                    ShowFix() %blank screen
                end
            case 5 %%Control Fov. Draw stim on Fellow side. Fovea. Flash dot on Fellow side
                Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
                if strcmp(bs_eye, 'left') %if BS eye = left
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L_fovea(i,:));
                    end
                    ShowFix() %blank screen
                elseif strcmp(bs_eye, 'right')%if BS eye = right
                    for i = 1:nOvals
                        Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R_fovea(i,:));
                    end
                    ShowFix() %blank screen
                end
        end
        
        
        
        %display BSs for debug
        if Demo
            oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r]; %right BS
            oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r); %right BS
            Screen('FrameOval', window, [0 1 0], oval_rect_centred);
            oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l]; %left BS
            oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l); %right BS
            Screen('FrameOval', window, [0 0 1], oval_rect_centred);
        end
    
    
    fiftyshadesofgrey(1:10);
    
    
    
    
    % RIGHT SCREEN
    
    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    %    draw fixation dot
    Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
    
    switch currcondition
        case 1 %BS. Draw Stim on BS side. Flash dot on Fellow side
%             Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix frame
            if strcmp(bs_eye, 'left') %if BS eye = left
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L(i,:));
                end
                ShowFix() %blank screen
            elseif strcmp(bs_eye, 'right')%if BS eye = right
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R(i,:));
                end
                ShowFix() %blank screen
            end
            
        case 2 %Occ Peri. Draw stim on Fellow side. Periphery. Put on occluder. Flash dot on Fellow side
%             Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
            if strcmp(bs_eye, 'left') %if BS eye = left
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L(i,:));
                end
                ShowFix() %blank screen
            elseif strcmp(bs_eye, 'right')%if BS eye = right
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R(i,:));
                end
                ShowFix() %blank screen
            end
            
        case 3 %Control Peri. Draw stim on Fellow side. Periphery. Flash dot on Fellow side
%             Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
            if strcmp(bs_eye, 'left') %if BS eye = left
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L(i,:));
                end
                ShowFix() %blank screen
            elseif strcmp(bs_eye, 'right')%if BS eye = right
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R(i,:));
                end
                ShowFix() %blank screen
            end
            
        case 4 %Occ Fov. Draw stim on Fellow side. Fovea. Put on occluder. Flash dot on Fellow side
%             Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
            if strcmp(bs_eye, 'left') %if BS eye = left
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L_fovea(i,:));
                end
                ShowFix() %blank screen
            elseif strcmp(bs_eye, 'right')%if BS eye = right
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R_fovea(i,:));
                end
                ShowFix() %blank screen
            end
        case 5 %%Control Fov. Draw stim on Fellow side. Fovea. Flash dot on Fellow side
%             Screen('CopyWindow', leftFixWin, window, [], rightScreenRect); %always left fix fram
            if strcmp(bs_eye, 'left') %if BS eye = left
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_L_fovea(i,:));
                end
                ShowFix() %blank screen
            elseif strcmp(bs_eye, 'right')%if BS eye = right
                for i = 1:nOvals
                    Screen('FillOval', window, fiftyshadesofgrey(i), baseRectGreyOval_centred_R_fovea(i,:));
                end
                ShowFix() %blank screen
            end
    end
    
    %display BSs for debug
    if Demo
        oval_rect = [0 0 BS_diameter_h2_r BS_diameter_v_r]; %right BS
        oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_r, BS_center_v_r); %right BS
        Screen('FrameOval', window, [0 1 0], oval_rect_centred);
        oval_rect = [0 0 BS_diameter_h2_l BS_diameter_v_l]; %left BS
        oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2_l, BS_center_v_l); %right BS
        Screen('FrameOval', window, [0 0 1], oval_rect_centred);
    end
    fiftyshadesofgrey(1:10);
    
    % display for mask duration
    
    vbl = GetSecs;
    vbl = Screen('Flip', window, vbl + (waitframes - 0.2  ) * ifi);
    vbl = Screen('Flip', window, vbl + ((durationMask/ifi) - 0.2  ) * ifi);
    
    %      vbl = Screen('Flip', window, vbl + (durationMask/ifi - 0.2  ) * ifi);
    
    if Demo
        KbStrokeWait(-1);
    end
    
    
    %record response
    
    %------------------------
    % Make response
    % -----------------------
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
    DrawFormattedText(window,'Was the dot INSIDE or OUTSIDE illusory shape?', 'center','center',[0 0 0], [],1);
    
    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
    Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
    DrawFormattedText(window,'Was the dot INSIDE or OUTSIDE illusory shape?', 'center','center',[0 0 0], [],1);
    Screen('Flip', window);
    
    
    
    resp2Bmade = true;
    curr_response = 0;
    numFrames = 0;
    starttime = GetSecs;
    
    while resp2Bmade %record L or R
        [keyIsDown,secs, keyCode] = KbCheck(-1);
        Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
        Screen('CopyWindow', leftFixWin, window, [], rightScreenRect);
        DrawFormattedText(window,'Was the dot INSIDE or OUTSIDE illusory shape?', 'center','center',[0 0 0], [],1);
        
        Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
        Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
        DrawFormattedText(window,'Was the dot INSIDE or OUTSIDE illusory shape?', 'center','center',[0 0 0], [],1);
        Screen('Flip', window);
        
        
        if keyIsDown
            if keyCode(escapeKey);
                resp2Bmade = false; endtime = GetSecs; save (filename); sca;
            elseif keyCode(leftKey); resp2Bmade = false; curr_response = 1; endtime = GetSecs;
            elseif keyCode(rightKey); resp2Bmade = false; curr_response = 2; endtime = GetSecs;
            else
                %just go through the while loop since resp2Bmade is
                %still true
            end %end if
        end
        % if L or R has been pressed, record response
        
        % EXAMPLE RESULTS MATRIX
        % CONDITION | DOT POSITION | | RESP  | RT
        %   1           -1              1     0.50
        %   2           -0.5            1     0.456
        
        
        subjectdata(trialN,1) = currcondition; %record cond of this trial
        subjectdata(trialN,2) = currdotposition; %record orientation of comparison of this trial
        subjectdata(trialN,3) = currdoteye; %record which eye was the dot flashed in
        subjectdata(trialN,4) = curr_response; % which side was the control stim on?
        subjectdata(trialN,5) = secs - starttime; %Record RT
           
              
    end %while
    
    resp2Bmade = true; %reset response logical variable
    disp(sprintf('Trial %d out of %d completed', trialN, size(experimentalconditions,1)))
    
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
    
    
    
    
end %for trial

save (filename)
sca



catch ERR2
    ERR2
    ERR2.stack
    save (filename)
    sca
end% big try loop