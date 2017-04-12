% Test script for moving gratings with occlusion etc.
% Yulia Revina 2017

% clear all; %don't want to do this for the real expt otherwise it will delete the blindspot measurements

stereoModeOn = 1;
stereoMode =4;        % 4 for split screen, 10 for two screens
makescreenshotsforvideo = 0;


bs_eye = 'right';   %% Right eye has the blind spot. Left fixation spot

%This is how to select each screen

% %  % Select left-eye image buffer for drawing:
%    Screen('SelectStereoDrawBuffer', w, 0);  %LEFT
%        % draw fixation dot 
%        Screen('CopyWindow', leftFixWin, w, [], leftScreenRect);	  
%    % Select right-eye image buffer for drawing:
%    Screen('SelectStereoDrawBuffer', w, 1);   %RIGHT
%         % draw fixation dot 
%        Screen('CopyWindow', rightFixWin, w, [], rightScreenRect);	  
% 
%    Screen('Flip',w);

%% -------------------------------
% set up screen and psychtoolbox |
% --------------------------------

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

Screen('Preference', 'SkipSyncTests', 1); %also remove this for the real expt. This is just for programming and testing the basic script on windows

% This script    calls Psychtoolbox commands available only in OpenGL-based 
% versions of the Psychtoolbox. (So far, the OS X Psychtoolbox is the
% only OpenGL-base Psychtoolbox.)  The Psychtoolbox command AssertPsychOpenGL will issue
% an error message if someone tries to execute this script on a computer without
% an OpenGL Psychtoolbox
AssertOpenGL;

Priority(1);

screens = Screen('Screens');  % Gives (0 1) if there is an external monitor attached or just (0) for no external
screenNumber = max(screens);  % puts stimulus on external screen
% screenNumber = 1;


white = WhiteIndex(screenNumber);  %value of white for display screen screenNumber
black = BlackIndex(screenNumber);  %value of white for display screen screenNumber
grey = GrayIndex(screenNumber);  %value of white for display screen screenNumber


% Open an on screen window and color it grey

if stereoModeOn
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], [], [], stereoMode); % StereoMode 4 for side by side
    leftScreenRect = windowRect;
    rightScreenRect = windowRect; 
    if stereoMode == 10
        Screen('OpenWindow', screenNumber-1, 128, [], [], [], stereoMode);    
    end
else %just open one window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
end


% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);


sinceLastClick = 0;
mouseOn = 1;
lastKeyTime = GetSecs;
SetMouse(xCenter,yCenter,window);
WaitSecs(.1);
[mouseX, mouseY, buttons] = GetMouse(window);

%% Fix frame
% Fixation point

fp_offset = 200;

% frame
frameSize = 900;


leftFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
rightFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
[center(1), center(2)] = RectCenter(windowRect);
fix_r1 = 8;
fix_r2 = 4; 
fix_cord1 = [center-fix_r1 center+fix_r1] ;
fix_cord2 = [center-fix_r2 center+fix_r2] ;
l_fix_cord1 = [center-fix_r1 center+fix_r1] + [fp_offset 0 fp_offset 0];
l_fix_cord2 = [center-fix_r2 center+fix_r2] + [fp_offset 0 fp_offset 0];
r_fix_cord1 = [center-fix_r1 center+fix_r1] - [fp_offset 0 fp_offset 0];
r_fix_cord2 = [center-fix_r2 center+fix_r2] - [fp_offset 0 fp_offset 0];
Screen('FillOval', leftFixWin, uint8(white), l_fix_cord1);
Screen('FillOval', leftFixWin, uint8(black), l_fix_cord2);
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

 


%% ------------------------
% stimulus parameters     |
% -------------------------

bs_eye = 'right';   %% Right eye has the blind spot. Left fixation spot

% black_screen = 0;

gratingType = 'sine';
gratingSize = 1024 ;
% cyclePerDegree = 0.25;
cyclespersecond = 3;

% outside_BS = 5;
% outside_BS = round(deg2pix(outside_BS));
% stimRect = [ 1 1 40 gratingSize];

midCS  = 3;
cyclesPerDeg = [ .4 .45 .5 .55 .6]; %edit this
constant_tempFreq = 1;

maskSigma = deg2pix(.5) ;

maxContrast = .75;


bar_width = 1.73;
bar_width = round(deg2pix(bar_width));

% % Lines
% gap = 80;
% lineWidth = 3;
% lineLength = 60;
% 
% 
% stimDur = .8;
% isi     = .5;
% 
% fp_offset = 200;
% 
% % frame
% frameSize = 900;


% Conditions and SFs
% Conditions:   1. Intact
%               2. Blindspot
%               3. Occluded
%               4. Deleted sharp
%               5. Deleted Fuzzy

% SFs:          1. 0.25
%               2. 0.30 (this is the control SF)
%               3. 0.35
%               4. 0.40
%               5. 0.45



%% -------------------------------
% Stimulus preparation  - Grating|
% --------------------------------

cyclesPerWholeGrating = pix2deg(gratingSize) .* cyclesPerDeg;
periods = gratingSize./cyclesPerWholeGrating;

%get a one and 3 quarter cycle near the middle of the whole grating
% to set symmetrical xoffsets later
mean_cycles = round(cyclesPerWholeGrating(midCS)/2); %+ [1 3]./4;

% Define Half-Size of the grating image.
texsize=gratingSize / 2;

% This is the visible size of the grating. It is twice the half-width
% of the texture plus one pixel to make sure it has an odd number of
% pixels and is therefore symmetric around the center of the texture:
visiblesize=2*texsize+1;


% Grating
for p = 1:length(periods)
    f = 1/periods(p);
    fr = f*2*pi;   
    inc = white-grey;
    x = meshgrid(0:gratingSize-1, 1);
    % temporal cosine
    tcos_frames = round(1/cyclespersecond/ifi);
    tcos = cos((1:tcos_frames)./tcos_frames * 2*pi);   %% DEBUG: not quit right yet. this is only
    for t = 1:tcos_frames
        switch gratingType
            case 'square'
                grating(p,t,:) = grey + tcos(t)*maxContrast*inc*sign(sin(fr*x));
            case 'sine'
                grating(p,t,:) = grey + tcos(t)*maxContrast*inc*sin(fr*x);
        end
        gratingtex(p,t) = Screen('MakeTexture', window, squeeze(grating(p,t,:)), [], 1);
    end %for
end %for

% % Motion
% shiftperframe = cyclespersecond * periods(midCS) * ifi;
% direction = 1;
% xoffset = 0;




%% --------------------
% Recording responses |
% ---------------------

numberofreps = 10; %how many repetitions of each type of trial?
allcondscombos = CombVec(1:5,1:5)'; %generate all combinations of conditions and SFs, eg 1 1, 1 2, 1 3, ... 3 3, 3 4 etc
allcondscombos(:,[1,2]) = allcondscombos(:,[2,1]); %swap columns because it's easier for me to look at that way haha
allcondscombos = repmat(allcondscombos,numberofreps,1); % multiply the combinations by how many times we want to repeat them.
% This will be the full matrix for the whole expt for this subject (for one
% run possibly. Depending on how we wannna split it up).

%shuffle rows
condsorder = randperm(size(allcondscombos,1)); %this is the order of the conditions for each subject

%make a subject data matrix
% ntrials rows
% 4 cols
%   1. Condition (1-5)
%   2. SF (1-5)
%   3. Response (which one was denser) 1st or 2nd
%   4. Which eye had the control stim. Ie which eye was the FELLOW EYE (1 or 2 for L or R)
subjectdata = nan(size(allcondscombos,1), 4);
curr_response = []; %store current response on trial n


%% ---------------
%  Intro screen  |
%-----------------


% vbl = Screen('Flip', w, vbl+ifi-slack);
%    Screen('SelectStereoDrawBuffer', w, 0);  %LEFT
%    Screen('CopyWindow', leftFixWin, w, [], leftScreenRect);
%    Screen('SelectStereoDrawBuffer', w, 1);   %RIGHT
%    Screen('CopyWindow', rightFixWin, w, [], rightScreenRect);	
%    vbl = Screen('Flip', w, vbl+ifi-slack);
   
   instructions = 'Hello and welcome \n \n to the demo experiment for perceptual filling-in \n \n Press any key to continue';
% LEFT SCREEN
Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
Screen('TextSize', window, 20);
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
DrawFormattedText(window, instructions, 'center', 'center', white, [], 1);

% RIGHT SCREEN
Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
Screen('TextSize', window, 20);
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
DrawFormattedText(window, instructions, 'center', 'center', white, [], 1);



%flip both to screen
Screen('Flip', window);
KbStrokeWait;


moviename = 'demomovie.mov';
% movie1 = Screen('CreateMovie', window, 'demomovie.mov', 512, 512, 30);


%% -----------------
% Measure blind spot if we dont have the measurements already
% ------------------------------

if ~exist('BS_diameter_h') || ~exist('BS_diameter_v')
    Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
    Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
    DrawFormattedText(window, 'Let''s measure the blindspot! \n \n Press any key...', 'center', 'center', white, [], 1);
    Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
    Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
    DrawFormattedText(window, 'Let''s measure the blindspot! \n \n Press any key...', 'center', 'center', white, [], 1);
    Screen('Flip', window);
    KbStrokeWait;
    measure_BS_h_YR    %horizontal
    measure_BS_v_YR
end


%draw a blindspot oval to test its location
% outside_BS = 5; %5 deg of bar length outside BS
% outside_BS = round(deg2pix(outside_BS));
% targetPoint = [BS_center_h, mean(upper_v) + (BS_diameter_v/2 - outside_BS)/2];

oval_rect = [0 0 BS_diameter_h BS_diameter_v];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h, BS_center_v);
% testRect = [0 0 10 10];
% testRect_centr = CenterRectOnPoint(testRect, BS_center_h, BS_center_v);

Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
Screen('FillOval', window, uint8(white), oval_rect_centred);
DrawFormattedText(window, 'This is the location of BS', 'center', 'center', white, [],1);
Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
DrawFormattedText(window, 'This is the location of BS', 'center', 'center', white, [], 1);

Screen('Flip', window);
KbStrokeWait;


%% -------------------
% Stim prep - masks |
% --------------------
% need to make the occluders
% 1. White occluder
% 2. Deleted sharp edge (grey occluder)
% 3. Deleted fuzzy edge (grey gaussian occluder)

% size of the occluders is the same as the blindspot (as measured earlier)

% for testing, let's say BS size is 50 x 80 pix (w x h) (mine was like 50px horizontally measured on station2)
BSh = BS_diameter_v; %blindspot height
BSw = BS_diameter_h; %blindspot width

% Make a base Rect of 200 by 250 pixels
baseTestRect = [0 0 30 BSh+60];
% gaussRect = [10 30 BSw+10 BSh+40];

% make fuzzy edge oval (gaussian mask?). 
[x, y] = meshgrid(-BSw:1:BSw, -BSh:1:BSh);

% parameters for the gaussian blob
a1 = 3.5; %amplitude
b1 = 0;
b2 = 0;
c1 = (BSw-5)/2;
% c1 = (BSw-5)/3*1.38;
% c2 = c1*1.58;
c2 = (BSh-5)/2;
trim = 0.05;

%complete formula for oval gaussian
gauss = a1.*exp(-(((x-b1)./c1).^2+((y-b2)./c2).^2));
%quick circular gaussian with reduced parameters
% gauss = exp( -(((x.^2)+(y.^2)) ./ (2* sigma^2)) ); % formula for 2D gaussian

%best to trim the gaussian otherwise it displays a bit rectangular...
gauss(gauss < trim) = 0; %trim anything below trim value ie just change to zero
gauss(gauss>1) = 1; % "flatten" the peak. Change anything bigger than 1 to 1. We need the end matrix to be between 0 and 1
% gauss(gauss < trim) = 0; 


new_gauss= gauss;
% figure;imagesc(new_gauss), colormap gray
% axis image

%This time we create a two layer texture fill
% the first layer with the background color and then place the spiral
% texure in the second 'alpha' layer

contrast = 1;
[s1, s2] = size(new_gauss);
% mask = nan([1,3]);
mask = ones(s1, s2, 2) .* grey; %just makes grey bkg
mask(:, :, 2)= new_gauss; %makes transparency following the gaussian vals

maskTexture = Screen('MakeTexture', window, mask); %make into a texture

%%% Debugging the gaussian grey mask
[w, h]=size(gauss); %get the size of our gaussian matrix
gaussRect = [0 0 h w]; % make the corresponding base rect
centreBaseRect = [baseTestRect(3), baseTestRect(4)]./ 2; %get the centre of our stim rect
gaussRect = CenterRectOnPointd(gaussRect, centreBaseRect(1), centreBaseRect(2));%center it on the baserect for the stimulus

% try
%     Screen('FillRect', window, [1 0 0], baseTestRect);
%     Screen('DrawTexture', window, maskTexture, [], gaussRect);
%     Screen('Flip', window) 
%     KbStrokeWait;
% catch ERR1
%     sca
%     disp('Error in displaying gaussian')
%     rethrow(ERR1)
% end

%% -----------------------------------------------
% Present stimuli - altogether here for debugging |
%-------------------------------------------------

% Query duration of one monitor refresh interval:
    ifi=Screen('GetFlipInterval', window);
   
% Translate that into the amount of seconds to wait between screen
% redraws/updates: 
    waitframes = 1; % update every frame?
    
 % Translate frames into seconds for screen update interval:
    waitduration = waitframes * ifi; % just = ifi if we update on every frame
    

% Perform initial Flip to sync us to the VBL and for getting an initial
% VBL-Timestamp as timing baseline for our redraw loop:
    vbl=Screen('Flip', window);

    
 % The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
space = KbName('space');
    
    

incrementframe = 0;
direction = 1;
xoffset = 0;

framenumber = 1;
exitDemo = false; %demo = stims presented side by side just for checking
while exitDemo == false
 % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck;
    
    % KbStrokeWait; %wait for key press   
try
% make base rect
% bar_length = BS_vert_diameter+2*5deg_visual_angle
outside_BS = 5;
outside_BS = round(deg2pix(outside_BS));
bar_length = BS_diameter_v+2*outside_BS;
% baseRect = [0 0 30 bar_length];
baseRect = [0 0 bar_width bar_length]; %width 1.73 deg = 40 px (but check distances and visual angles)
% srcRect = baseRect;
occluderRect = [0 0 BSw BSh];
% fuzzyRect = [0 0 BSw+10 BSh+10]; %make the fuzzy rect a bit bigger cos it needs to spread out its fuzziness a bit
maxDiameter = max(occluderRect) * 1.01;
dstRect = nan(5, 4); %5 rows of stim, 4 columns: x,y x1,y1

squareXpos = [screenXpixels * 0.10 screenXpixels * 0.25 screenXpixels * 0.45 screenXpixels * 0.65 screenXpixels * 0.85];
% occluderRectCentre = CenterRectOnPointd(occluderRect, squareXpos(i), yCenter);

%make differently positioned source rects
% Make our rectangle coordinates
allRects = nan(4, 3);


Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);

Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);


for i = 1:5
    
% Motion
shiftperframe = cyclespersecond * periods(i) * waitduration;

    
% Shift the grating by "shiftperframe" pixels per frame:
        % the mod'ulo operation makes sure that our "aperture" will snap
        % back to the beginning of the grating, once the border is reached.
 xoffset = mod(incrementframe*shiftperframe,periods(i));
%         incrementframe=incrementframe+1;
        
        
% Define shifted srcRect that cuts out the properly shifted rectangular
% area from the texture: Essentially make a different srcRect every frame which is shifted by some amount      
srcRect=[0, xoffset, 30, xoffset + 300];       



    dstRect(i, :) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
%     Screen('DrawTextures', window, gratingtex(i,t), srcRect(:,i));


        Screen('DrawTexture', window, gratingtex(i,1), srcRect, dstRect(i, :)); %gratingtex(i,1) high amplitude ie high contrast
        %put on the occluders
        if i >= 3 || i <= 5
            %then put on masks on the last 3 stims (1st is intact, 2nd is BS, 3rd is occluded, 4th & 5th is deleted sharp and fuzzy)
            occluderRectCentre = CenterRectOnPointd(occluderRect, squareXpos(i), yCenter);
            fuzzyRectCentre = CenterRectOnPointd(gaussRect, squareXpos(i), yCenter);
            switch i
                case 3
                    Screen('FillOval', window, white*0.7, occluderRectCentre, maxDiameter); %'white' occluder of 0.7 greyness
                    Screen('FrameOval', window, [0 0 0], occluderRectCentre, 3);
                case 4
                    Screen('FillOval', window, grey, occluderRectCentre, maxDiameter); %grey occluder
                case 5
                    Screen('DrawTexture', window, maskTexture, [], fuzzyRectCentre);
%                     Screen('FrameOval', window, [1 0 0],occluderRectCentre, 3); %plot a red oval just for reference when debugging
            end   %wswitch    
        end  %if 
end %for
        
%     Screen('FillRect', window, black, srcRect(:,:));

% srcRect(1) = CenterRectOnPointd(baseRect, xCenter, yCenter);
%   Screen('DrawTextures', window, gratingtex(:,t), srcRect);
% Screen('DrawTexture', window, gratingtex(midCS,t), srcRect , targetRect);
% Screen('DrawTexture', window, gratingtex(midCS,t), srcRect);
% Screen('DrawTexture', window, gratingtex(1,t), srcRect(:,1));
% Screen('FillRect', window, black, srcRect(:,1));
% Screen('DrawTextures', window, gratingtex(1,t), [], srcRect);
Screen('Flip', window); 
incrementframe=incrementframe+1;

if makescreenshotsforvideo
            imageArray = Screen('GetImage', window);
             filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
             imwrite(imageArray, filenameimage);
            framenumber = framenumber+1; 
end
catch ERR
    sca %just close psychtoolbox if something errors above. No need to Ctrl+Alt+Del
    disp('Error in displaying stimuli!')
    rethrow(ERR)
end %try catch

% Flip 'waitframes' monitor refresh intervals after last redraw.
%    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

if keyCode(escapeKey)
          % GetImage call. Alter the rect argument to change the location of the screen shot
            imageArray = Screen('GetImage', window); %omitting rect argument means the whole screen is taken

            % imwrite is a Matlab function, not a PTB-3 function
            imwrite(imageArray, 'myscreenshot.jpg');
            
        exitDemo = true; %move onto the proper experiment
%         sca %close psychtoolbox window
end %if
% Screen('AddFrameToMovie', window);

end %while

% Screen('FinalizeMovie', movie1);
%% --------------------------------------------------------
% Stim presentation for the real experiment ie one by one |
% ---------------------------------------------------------

% Subject to press spacebar to start the trial
% Control intact stimulus will be presented with SF of 0.3? for x seconds
% Comparison stimulus will be presented in a random condition with a random
% SF. 5 conditions. 5 SFs






Instructions2 = 'Press spacebar to start each trial';
Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
DrawFormattedText(window, Instructions2, 'center', 'center', white, [],1);
Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
DrawFormattedText(window, Instructions2, 'center', 'center', white,[],1);
Screen('Flip', window);
try
while ~keyCode(space) %while the space bar has not been pressed....
     [keyIsDown,secs, keyCode] = KbCheck;
        
end %while
Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
DrawFormattedText(window, 'Trials will be here', 'center', 'center', white,[],1);
Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
DrawFormattedText(window, 'Trials will be here', 'center', 'center', white,[],1);
Screen('Flip', window);

WaitSecs(1);
% sca


% Programme the fixation point
% Show control
% show comparison
% Wait for response
% Record response
% Wait for spacebar
% start new trial

% % Fixation point
leftFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
rightFixWin = Screen('OpenOffScreenWindow',window, grey, windowRect); 
fp_offset = 200;
[center(1), center(2)] = RectCenter(windowRect);
fix_r1 = 8;
fix_r2 = 4; 
fix_cord1 = [center-fix_r1 center+fix_r1] ;
fix_cord2 = [center-fix_r2 center+fix_r2] ;
l_fix_cord1 = [center-fix_r1 center+fix_r1] + [fp_offset 0 fp_offset 0];
l_fix_cord2 = [center-fix_r2 center+fix_r2] + [fp_offset 0 fp_offset 0];
r_fix_cord1 = [center-fix_r1 center+fix_r1] - [fp_offset 0 fp_offset 0];
r_fix_cord2 = [center-fix_r2 center+fix_r2] - [fp_offset 0 fp_offset 0];
% % % Left side
% %     Screen('FillOval', window, uint8(white), l_fix_cord1);
% %     Screen('FillOval', window, uint8(black), l_fix_cord2);
% % % Right side
% %     Screen('FillOval', window, uint8(white), l_fix_cord1);
% %     Screen('FillOval', window, uint8(black), l_fix_cord2);
    
Screen('FillOval', leftFixWin, uint8(white), l_fix_cord1);
Screen('FillOval', leftFixWin, uint8(black), l_fix_cord2);
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
    
%Display it 
Screen('Flip', window);

KbStrokeWait;

% Right eye blindspot, Left Fellow eye, Fix on the LEFT, Grating on the
% RIGHT
subjectdata(:,4) = 1; % LEFT eye was the fellow eye

Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
DrawFormattedText(window, 'LEFT eye blindspot, \n \n RIGHT Fellow eye, \n \n Fix on the RIGHT', 'center', 'center', white,[],1);
Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
DrawFormattedText(window, 'LEFT eye blindspot, \n \n RIGHT Fellow eye, \n \n Fix on the RIGHT', 'center', 'center', white,[],1);
Screen('Flip', window);

KbStrokeWait;

   % Select right-eye image buffer for drawing:
   Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
        % draw fixation dot 
   Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);	  


% We need to present the stim over the blindspot. Get coords of the
% blindspot as measured previously. Here for the demo let's just present it
% where the opposing fix point is


% oval_rect_centred is our BS oval
% BS_center_h, BS_center_v is the centre

%centre of fix
centreRfix = [(l_fix_cord1(1) + l_fix_cord1(3))/2, (l_fix_cord1(2) + l_fix_cord1(4))/2];
%centre our dstRect in this point
% dstRectStim_BS_r = CenterRectOnPointd(dstRect(1, :), centreRfix(1), centreRfix(2));
dstRectStim_BS_r = CenterRectOnPointd(dstRect(1, :),BS_center_h,BS_center_v);
% dstRectStim_BS_r = r_fix_cord1;
% New_occluderRect = CenterRectOnPointd(occluderRect, centreRfix(1), centreRfix(2));
New_occluderRect = oval_rect_centred;
% New_fuzzyRect = CenterRectOnPointd(fuzzyRectCentre, centreRfix(1), centreRfix(2)); %make the fuzzy rect a bit bigger cos it needs to spread out its fuzziness a bit
New_fuzzyRect = CenterRectOnPointd(fuzzyRectCentre,BS_center_h,BS_center_v);
         

% Motion
shiftperframe = cyclespersecond * periods(i) * waitduration;

    
% Shift the grating by "shiftperframe" pixels per frame:
% the mod'ulo operation makes sure that our "aperture" will snap
% back to the beginning of the grating, once the border is reached.
 xoffset = mod(incrementframe*shiftperframe,periods(i));
%incrementframe=incrementframe+1;
        
        
% Define shifted srcRect that cuts out the properly shifted rectangular
% area from the texture: Essentially make a different srcRect every frame which is shifted by some amount      
srcRect=[0, xoffset, 30, xoffset + 300];

stimdurframes = round(0.8/ifi);
% ourtime = 0;
% 
vbl = Screen('Flip', window);
% vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
framenumber = 1;
whichscreen = 'left';

nexttrial = allcondscombos(condsorder(1),:); 
    switch nexttrial(1)
        case 1
            messagenexttrial = 'Next: Intact';
        case 2
            messagenexttrial = 'Next: Blindspot';
            whichscreen = 'right';
        case 3
            messagenexttrial = 'Next: Occluded';
        case 4
            messagenexttrial = 'Next: Deleted Sharp';
        case 5
            messagenexttrial = 'Next: Deleted Fuzzy';
    end
    
    Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
  DrawFormattedText(window, messagenexttrial, 'center', 'center', white,[],1);
    Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
  Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
    DrawFormattedText(window, messagenexttrial, 'center', 'center', white,[],1);
    
    
%      % fix point
%         Screen('FillOval', window, uint8(white), l_fix_cord1);
%         Screen('FillOval', window, uint8(black), l_fix_cord2);
        
        
     Screen('Flip', window);
     
KbStrokeWait;


    for ntrials = 1:length(condsorder)
          
             
%         vbl = Screen('Flip', window);
        ourtime = 0;
        incrementframe = 0;
      while ourtime < 0.8
          % Motion
            shiftperframe = cyclespersecond * periods(3) * waitduration;
    
            % Shift the grating by "shiftperframe" pixels per frame:
            % the mod'ulo operation makes sure that our "aperture" will snap
            % back to the beginning of the grating, once the border is reached.
            xoffset = mod(incrementframe*shiftperframe,periods(3));
            %incrementframe=incrementframe+1;
        
            % Define shifted srcRect that cuts out the properly shifted rectangular
            % area from the texture: Essentially make a different srcRect every frame which is shifted by some amount      
            srcRect=[0, xoffset, 30, xoffset + 300];
                  
         Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
          Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
        Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
%        % fix point
%         Screen('FillOval', window, uint8(white), l_fix_cord1);
%         Screen('FillOval', window, uint8(black), l_fix_cord2);
     % display intact at SF of 0.3 ir gratingtex(2)
        Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
        Screen('Flip', window);
%         vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
      ourtime = ourtime + ifi;
        incrementframe = incrementframe + 1;
        if makescreenshotsforvideo
        imageArray = Screen('GetImage', window);
         filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
            imwrite(imageArray, filenameimage);
            framenumber = framenumber+1; 
        end
      end    %while     
        
      % blank ISI
       Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
          Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
        Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
%         Screen('FillOval', window, uint8(white), l_fix_cord1);
%         Screen('FillOval', window, uint8(black), l_fix_cord2);
        Screen('Flip', window);
        WaitSecs(0.5);
        if makescreenshotsforvideo
        for imageframes = 1:30 %for 30 frames (0.5s)
            imageArray = Screen('GetImage', window);
              filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
          imwrite(imageArray, filenameimage);
          framenumber = framenumber+1; 
        end
        end
        % display comparison
        
         ourtime = 0;
        incrementframe = 0;
        
         thistrial = allcondscombos(condsorder(ntrials),:); %determine the trial. Conds order has the trial order. Go through it one by one until ntrials
        
         
         % this is defined earlier
%          if thistrial(1) == 2
%              %blindspot
%              whichscreen = 'right';
%          else
%              whichscreen = 'left';
%          end


%fixation
Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
  Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
  Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
  
  if strcmp(whichscreen,'right')
     Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
     Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
else
    Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
    Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
end
  
      while ourtime < 0.8
         % Motion
            shiftperframe = cyclespersecond * periods(3) * waitduration;
    
            % Shift the grating by "shiftperframe" pixels per frame:
            % the mod'ulo operation makes sure that our "aperture" will snap
            % back to the beginning of the grating, once the border is reached.
            xoffset = mod(incrementframe*shiftperframe,periods(3));
            %incrementframe=incrementframe+1;
        
            % Define shifted srcRect that cuts out the properly shifted rectangular
            % area from the texture: Essentially make a different srcRect every frame which is shifted by some amount      
            srcRect=[0, xoffset, 30, xoffset + 300];
       
            Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
  Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
  Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
  
  if strcmp(whichscreen,'right')
     Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
     Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
else
    Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
    Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
end
  
            
            
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
                 Screen('FillOval', window, white*0.7, New_occluderRect, maxDiameter); %'white' occluder of 0.7 greyness
                 Screen('FrameOval', window, [0 0 0], New_occluderRect, 3);
            case 4 %Deleted sharp
                %present the grating of the SF stored in thistrial(2) to
                %the LEFT EYE
%                
                %grey mask
                Screen('FillOval', window, grey, New_occluderRect, maxDiameter); %grey occluder
            case 5 %Deleted fuzzy 
                %present the grating of the SF stored in thistrial(2) to
                %the LEFT EYE
                Screen('DrawTexture', window, gratingtex(thistrial(2),1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                %fuzzy mask
                Screen('DrawTexture', window, maskTexture, [], New_fuzzyRect);
        end %switch
        
        % fix point
    
%         Screen('FillOval', window, uint8(white), l_fix_cord1);
%         Screen('FillOval', window, uint8(black), l_fix_cord2);
%         vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        Screen('Flip', window);
       ourtime = ourtime + ifi;
        incrementframe = incrementframe + 1;
        if makescreenshotsforvideo
           filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
        imageArray = Screen('GetImage', window);
                      imwrite(imageArray, filenameimage);
            framenumber = framenumber+1; 
        end
      end %while  
      
      
      
        % remove comparison
        Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
  DrawFormattedText(window, 'Make response \n \n L = 1st was denser R = 2nd was denser', 'center', 'center', white, [],1);
  Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
  Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
  
%         Screen('FillOval', window, uint8(white), l_fix_cord1);
%         Screen('FillOval', window, uint8(black), l_fix_cord2);
        DrawFormattedText(window, 'Make response \n \n L = 1st was denser R = 2nd was denser', 'center', 'center', white, [],1);
%         vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
         Screen('Flip', window);
         if makescreenshotsforvideo
            for imageframes = 1:60 %for 60 frames (1s)
            imageArray = Screen('GetImage', window);
             filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
                      imwrite(imageArray, filenameimage);
            framenumber = framenumber+1; 
            end
         end
%         
try     
%      sprintf('KeyIsdown before KbStrokeCheck: %d', keyIsDown)
%      sprintf('KeyCode before: %d', find(keyCode==1))
  [secs, keyCode, deltaSecs] = KbStrokeWait; %wait for response
                
%   leftKey = KbName('LeftArrow');
% rightKey = KbName('RightArrow');
  
    

  if keyCode(escapeKey); sca;
  elseif keyCode(leftKey); curr_response = 1;
  elseif keyCode(rightKey); curr_response = 2;
  else
      while ~keyCode(leftKey) && ~keyCode(rightKey) %while something other than Left or Right key
           % keep checking the keyboard
            [keyIsDown,secs, keyCode] = KbCheck;%
            if keyCode(escapeKey); sca; 
            elseif keyCode(leftKey); curr_response = 1;
            elseif keyCode(rightKey); curr_response = 2;
            end
      end %while
  end %end if

  
  
  % if L or R has been pressed, record response
  % Clear screen
   subjectdata(ntrials,3) = curr_response; % LEFT eye was the fellow eye
   subjectdata(ntrials,1) = thistrial(1); %record cond of this trial
   subjectdata(ntrials,2) = thistrial(2); %record SF of this trial
   Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
  Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
  Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
%   
%    Screen('FillOval', window, uint8(white), l_fix_cord1);
%    Screen('FillOval', window, uint8(black), l_fix_cord2);
   Screen('Flip', window);
   if makescreenshotsforvideo
   for imageframes = 1:100 %for 100 frames
            imageArray = Screen('GetImage', window);
             filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
                      imwrite(imageArray, filenameimage);
            framenumber = framenumber+1; 
   end
   end
  
%         if keyIsDown
%             DrawFormattedText(window, 'Key Press!!', 'center', 'center', white);
% %             vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
%              Screen('Flip', window); WaitSecs(1)
%         end
%         if keyCode(space)
%             disp('Space is pressed!')
%             DrawFormattedText(window, 'Space Press!!', 'center', 'center', white);
%             Screen('Flip', window); WaitSecs(1)
%         elseif keyIsDown
%             DrawFormattedText(window, ['Key Press!! ' sprintf('Something else was pressed: %d', find(keyCode==1))], 'center', 'center', white);
%             sprintf('Something else was pressed: %d', find(keyCode==1))
%             Screen('Flip', window);WaitSecs(1)
%         else
%             disp('Nothing was pressed!');
%             sprintf('KeyCode: %d', find(keyCode==1))
%             sprintf('KeyIsdown: %d', keyIsDown)
%             DrawFormattedText(window, 'No Key Press!!', 'center', 'center', white);
%             Screen('Flip', window); WaitSecs(1)
%         end

  

catch keyerr
     sca
     rethrow(keyerr)
end
 

 
 try
     
    nexttrial = allcondscombos(condsorder(ntrials+1),:); 
    switch nexttrial(1)
        case 1
            messagenexttrial = 'Next: Intact';
            whichscreen = 'left';
        case 2
            messagenexttrial = 'Next: Blindspot';
            whichscreen = 'right';
        case 3
            messagenexttrial = 'Next: Occluded';
            whichscreen = 'left';
        case 4
            messagenexttrial = 'Next: Deleted Sharp';
            whichscreen = 'left';
        case 5
            messagenexttrial = 'Next: Deleted Fuzzy';
            whichscreen = 'left';
    end
   
        % fix point
        Screen('SelectStereoDrawBuffer', window, 1);   %RIGHT
  Screen('CopyWindow', rightFixWin, window, [], rightScreenRect);
   DrawFormattedText(window, messagenexttrial, 'center', 'center', white,[],1);
  Screen('SelectStereoDrawBuffer', window, 0);   %LEFT
  Screen('CopyWindow', leftFixWin, window, [], leftScreenRect);
   DrawFormattedText(window, messagenexttrial, 'center', 'center', white,[],1);
%   
%         Screen('FillOval', window, uint8(white), l_fix_cord1);
%         Screen('FillOval', window, uint8(black), l_fix_cord2);
        
        Screen('Flip', window);
     
     
     [secs, keyCode, deltaSecs] = KbStrokeWait; %wait for space
     
        while ~keyCode(space) %while something other than space was pressed, don't move on. Unless it's quit demo
           
%            KbStrokeWait;
            [keyIsDown,secs, keyCode] = KbCheck;% Check the keyboard to see if a button has been pressed
%                    
            if keyCode(escapeKey)
              sca %if esc then just quit demo
              break;
            end
        end %end while. Move into next trial 
 catch whileerr
    sca
     rethrow(whileerr)
 end 
 end %for

catch ERR3
     sca
     rethrow(ERR3)
end

sca