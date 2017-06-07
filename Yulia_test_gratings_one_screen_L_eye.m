% Test script for moving gratings with occlusion etc.
% Yulia Revina 2017

% clear all; %don't want to do this for the real expt otherwise it will delete the blindspot measurements

todaydate = date;

stereoModeOn = 0; %don't need this for goggles, only for the 2 screen setup
stereoMode = 4;        % 4 for split screen, 10 for two screens
makescreenshotsforvideo = 0;


bs_eye = 'left';   %% Left eye has the blind spot. Left fixation spot

distance2screen = 42; % how many centimeters from eye to screen? To make this portable on different machines

outside_BS = 5; %deg of visual angle
outside_BS = round(deg2pix_YR(outside_BS)); %in pixels for our screen


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

% Screen('Preference', 'SkipSyncTests', 1); %also remove this for the real expt. This is just for programming and testing the basic script on windows
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
grey_bkg = white*0.10


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


% Set the blend function for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


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



% Need mouse control for blind spot measurements
sinceLastClick = 0;
mouseOn = 1;
lastKeyTime = GetSecs;
SetMouse(xCenter,yCenter,window);
WaitSecs(.1);
[mouseX, mouseY, buttons] = GetMouse(window);

%% Fix frame

% Fixation point on the RIGHT
fp_offset = 200;
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


%% ---------------------------------------
% Set up Arduino for Goggles use
% ________________________________________
[ard, comPort] = InitArduino;
disp('Arduino Initiated')

ToggleArd(ard,'LensOn') % need both eyes to view everything up until the actual experiment trials (and for the BS measurement)

% Remember to switch this off if the code stops for any reason. Any
% Try/Catch routines should have LensOff integrated there...


try
%% ---------------
%  Intro screen  |
%-----------------
%show fix
Screen('TextSize', window, 20);
Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);

instructions = 'Hello and welcome \n \n to the demo experiment for perceptual filling-in \n \n Press any key to continue';
DrawFormattedText(window, instructions, 'center', 'center', white, [], []);

%flip to screen
Screen('Flip', window);
KbStrokeWait;

%% -----------------
% Measure blind spot if we dont have the measurements already
% ------------------------------

if ~exist('BS_diameter_h') || ~exist('BS_diameter_v')
    %show fix
    Screen('TextSize', window, 20);
    Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
    % instructions
    DrawFormattedText(window, 'Let''s measure the blindspot! \n \n Press any key...', 'center', 'center', white, [], []);
    Screen('Flip', window);
    KbStrokeWait;
    ToggleArd(ard,'RightOff') % close R eye so we can look with our L and measure BS
    measure_BS_h_YR_1screen    %horizontal
    measure_BS_v_YR_1screen    %vertical
    ToggleArd(ard,'LensOn') %put goggles back on
end


%draw a blindspot oval to test its location
oval_rect = [0 0 BS_diameter_h BS_diameter_v];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h, BS_center_v);

%show fix
Screen('TextSize', window, 20);
Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);

% show blind spot
Screen('FillOval', window, uint8(white), oval_rect_centred);
DrawFormattedText(window, 'This is the location of BS', 'center', 'center', white, [],[]);

Screen('Flip', window);
KbStrokeWait;

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
%   5. RT using number of frames elapsed
%   6. RT using GetSecs; %should be similar to above, just for debugging
%   mostly
subjectdata = nan(size(allcondscombos,1), 6);
curr_response = 0; %store current response on trial n



%% ------------------------
% stimulus parameters     |
% -------------------------

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


gratingType = 'sine';
gratingSize = 1024 ;
cyclespersecond = 3;

% stimRect = [ 1 1 40 gratingSize];

midCS  = 3;
% cyclesPerDeg = [ .4 .45 .5 .55 .6]; %edit this
cyclesPerDeg = [ .25 .30 .35 .40 .45]; 

constant_tempFreq = 1;

maxContrast = .75;
% maxContrast = .5;

bar_width = 1.73; %1.73 deg like in gerrit's prev expts
bar_width = round(deg2pix_YR(bar_width));
% bar_length = BS_vert_diameter+2*5deg_visual_angle
bar_length = BS_diameter_v+2*outside_BS; % +50 for testing

% define our timings here, let's not hard code it later (bad!)
stimDur = .8;
isi     = .5;

%% -------------------------------
% Stimulus preparation  - Grating|
% --------------------------------

cyclesPerWholeGrating = pix2deg_YR(gratingSize) .* cyclesPerDeg;
periods = gratingSize./cyclesPerWholeGrating;

%not using this here
% % %get a one and 3 quarter cycle near the middle of the whole grating
% % % to set symmetrical xoffsets later
% % mean_cycles = round(cyclesPerWholeGrating(midCS)/2); %+ [1 3]./4;

% Define Half-Size of the grating image.
texsize=gratingSize / 2;

% This is the visible size of the grating. It is twice the half-width
% of the texture plus one pixel to make sure it has an odd number of
% pixels and is therefore symmetric around the center of the texture:
visiblesize=2*texsize+1;


% Grating from Gerrit's script. We don't really need the temporal cosine
% bit... but haven't had time to edit this. It works in any case. Just use
% one value of t
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
%                 grating(p,t,:) = grey + tcos(t)*maxContrast*inc*sin(fr*x);
                grating(p,t,:) = (grey + tcos(t)*maxContrast*inc*sin(fr*x)) * 0.2;
        end
        gratingtex(p,t) = Screen('MakeTexture', window, squeeze(grating(p,t,:)), [], 1);
    end %for
end %for

%% -------------------
% Stim prep - masks |
% --------------------
% need to make the occluders
% 1. White occluder
% 2. Deleted sharp edge (grey occluder)
% 3. Deleted fuzzy edge (grey gaussian occluder)

% size of the occluders is the same as the blindspot (as measured earlier)
BSh = BS_diameter_v; %blindspot height
BSw = BS_diameter_h; %blindspot width

% Make a base Rect
baseTestRect = [0 0 30 BSh+60];
% gaussRect = [10 30 BSw+10 BSh+40];

% make fuzzy edge oval
[x, y] = meshgrid(-BSw:1:BSw, -BSh:1:BSh);

% parameters for the gaussian blob
a1 = 3.5; %amplitude
b1 = 0;
b2 = 0;
c1 = (BSw-5)/2; % standard deviation, just under half the size of the BS. Seems to look nice
c2 = (BSh-5)/2; % SD in the other orientation since we have an oval

trim = 0.05;

%complete formula for oval gaussian
gauss = a1.*exp(-(((x-b1)./c1).^2+((y-b2)./c2).^2));

% %quick circular gaussian with reduced parameters
% gauss = exp( -(((x.^2)+(y.^2)) ./ (2* sigma^2)) ); % formula for 2D gaussian


%best to trim the gaussian otherwise it displays a bit rectangular...
gauss(gauss < trim) = 0; %trim anything below trim value ie just change to zero
gauss(gauss>1) = 1; % "flatten" the peak. Change anything bigger than 1 to 1. We need the end matrix to be between 0 and 1

%This time we create a two layer texture fill
% the first layer with the background color and then place the gauss
% texure in the second 'alpha' layer

contrast = 1;
[s1, s2] = size(gauss);
mask = ones(s1, s2, 2) .* grey_bkg; %just makes grey bkg
mask(:, :, 2)= gauss; %makes transparency following the gaussian vals

maskTexture = Screen('MakeTexture', window, mask); %make into a texture


[w, h]=size(gauss); %get the size of our gaussian matrix
gaussRect = [0 0 h w]; % make the corresponding base rect
centreBaseRect = [baseTestRect(3), baseTestRect(4)]./ 2; %get the centre of our stim rect
gaussRect = CenterRectOnPointd(gaussRect, centreBaseRect(1), centreBaseRect(2));%center it on the baserect for the stimulus

          
% positions of 5 demo bars
squareXpos = [screenXpixels * 0.10 screenXpixels * 0.25 screenXpixels * 0.45 screenXpixels * 0.65 screenXpixels * 0.85];
% make base rect
baseRect = [0 0 bar_width bar_length]; %width 1.73 deg = 37 px (on station 2 CRT)
% destination rects for 5 bars
dstRect = nan(5, 4); %5 rows of stim, 4 columns: x,y x1,y1
% destination rects centered

%occluder Rect
occluderRect = [0 0 BSw BSh];
maxDiameter = max(occluderRect) * 1.01;

% 
for i = 1:5
    dstRect(i, :) = CenterRectOnPointd(baseRect, squareXpos(i), yCenter);
end


% We need to present the stim over the blindspot. Get coords of the
% blindspot as measured previously. 
dstRectStim_BS_r = CenterRectOnPointd(dstRect(1, :),BS_center_h,BS_center_v);



occluderRectCentre_Demo = CenterRectOnPointd(occluderRect, squareXpos(3), yCenter);
greyoccluderRectCentre_Demo = CenterRectOnPointd(occluderRect, squareXpos(4), yCenter);
fuzzyoccluderRectCentre_Demo = CenterRectOnPointd(occluderRect, squareXpos(5), yCenter);
occluderRectCentre_Expt = CenterRectOnPointd(occluderRect, BS_center_h,BS_center_v);

% fuzzyRect = [0 0 BSw+10 BSh+10]; %make the fuzzy rect a bit bigger cos it needs to spread out its fuzziness a bit

% fuzzy mask rect
fuzzyRectCentre_Demo = CenterRectOnPointd(gaussRect, squareXpos(5), yCenter);
fuzzyRectCentre_Expt = CenterRectOnPointd(gaussRect, BS_center_h,BS_center_v);




% occluderRectCentre = CenterRectOnPointd(occluderRect, squareXpos(i), yCenter);

%make differently positioned source rects
% Make our rectangle coordinates
% allRects = nan(4, 3);






% oval_rect_centred is our BS oval
% BS_center_h, BS_center_v is the centre





% New_fuzzyRect = CenterRectOnPointd(fuzzyRectCentre,BS_center_h,BS_center_v);

%_________________________________________________________
%%% Debugging the gaussian grey mask
%_________________________________________________________


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
                   
        %show fix
        Screen('TextSize', window, 20);
        Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
        
        
        for i = 1:5
            
            % Motion
            shiftperframe = cyclespersecond * periods(i) * waitduration;
            
            
            % Shift the grating by "shiftperframe" pixels per frame:
            % the mod'ulo operation makes sure that our "aperture" will snap
            % back to the beginning of the grating, once the border is reached.
            xoffset = mod(incrementframe*shiftperframe,periods(i));
            % incrementframe=incrementframe+1;
            
            
            % Define shifted srcRect that cuts out the properly shifted rectangular
            % area from the texture: Essentially make a different srcRect every frame which is shifted by some amount
            srcRect=[0, xoffset, bar_width, xoffset + bar_length];
            
%           
            
            Screen('DrawTexture', window, gratingtex(i,1), srcRect, dstRect(i, :)); %gratingtex(i,1) high amplitude ie high contrast
            %put on the occluders
            if i >= 3 || i <= 5
                %then put on masks on the last 3 stims (1st is intact, 2nd is BS, 3rd is occluded, 4th & 5th is deleted sharp and fuzzy)
                
                switch i
                    case 3
                        Screen('FillOval', window, white*0.7, occluderRectCentre_Demo, maxDiameter); %'white' occluder of 0.7 greyness
                        Screen('FrameOval', window, [0 0 0], occluderRectCentre_Demo, 3);
                    case 4
                        Screen('FillOval', window, grey_bkg, greyoccluderRectCentre_Demo, maxDiameter); %grey occluder
                    case 5
                        Screen('DrawTexture', window, maskTexture, [], fuzzyRectCentre_Demo);
                        Screen('FrameOval', window, [1 0 0], fuzzyoccluderRectCentre_Demo, 3); %plot a red oval just for reference when debugging
                end   %switch
            end  %if
        end %for
        
        % Screen('FillRect', window, black, srcRect(:,:));
        % srcRect(1) = CenterRectOnPointd(baseRect, xCenter, yCenter);
        % Screen('DrawTextures', window, gratingtex(:,t), srcRect);
        % Screen('DrawTexture', window, gratingtex(midCS,t), srcRect , targetRect);
        % Screen('DrawTexture', window, gratingtex(midCS,t), srcRect);
        % Screen('DrawTexture', window, gratingtex(1,t), srcRect(:,1));
        % Screen('FillRect', window, black, srcRect(:,1));
        % Screen('DrawTextures', window, gratingtex(1,t), [], srcRect);
        % Screen('Flip', window);
        
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
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
    
    if keyCode(escapeKey)
        % GetImage call. Alter the rect argument to change the location of the screen shot
        imageArray = Screen('GetImage', window); %omitting rect argument means the whole screen is taken
        
        % imwrite is a Matlab function, not a PTB-3 function
        imwrite(imageArray, 'myscreenshot.jpg');
        
        exitDemo = true; %move onto the proper experiment
        % sca %close psychtoolbox window
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
%show fix
Screen('TextSize', window, 20);
Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
DrawFormattedText(window, Instructions2, 'center', 'center', white, [],[]);
Screen('Flip', window);
try
    while ~keyCode(space) %while the space bar has not been pressed....
        [keyIsDown,secs, keyCode] = KbCheck;
    end %while
      
    
    % Show control
    % show comparison
    % Wait for response
    % Record response
    % Wait for spacebar
    % start new trial
 
  
       
    % Right eye blindspot, Left Fellow eye, Fix on the LEFT, Grating on the
    % RIGHT
    subjectdata(:,4) = 1; % LEFT eye was the fellow eye
    
   %show fix
    Screen('TextSize', window, 20);
    Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
    Screen('CopyWindow', leftFixWin, window, [], windowRect);
    DrawFormattedText(window, 'LEFT eye blindspot, \n \n RIGHT Fellow eye, \n \n Fix on the RIGHT', 'center', 'center', white,[],[]);
    Screen('Flip', window);
    
    KbStrokeWait;
    
    %show fix
    Screen('TextSize', window, 20);
    Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
    vbl = Screen('Flip', window);
    
        
    % Motion
    shiftperframe = cyclespersecond * periods(i) * waitduration;
    
    
    % Shift the grating by "shiftperframe" pixels per frame:
    % the mod'ulo operation makes sure that our "aperture" will snap
    % back to the beginning of the grating, once the border is reached.
    xoffset = mod(incrementframe*shiftperframe,periods(i));
        
    
    % Define shifted srcRect that cuts out the properly shifted rectangular
    % area from the texture: Essentially make a different srcRect every frame which is shifted by some amount
    srcRect=[0, xoffset, bar_width, xoffset + bar_length];
    
    stimdurframes = round(0.8/ifi);
         
    framenumber = 1;
    whicheye = 'right';
    
    nexttrial = allcondscombos(condsorder(1),:);
    switch nexttrial(1)
        case 1
            messagenexttrial = 'Next: Intact';
        case 2
            messagenexttrial = 'Next: Blindspot';
            whicheye = 'left';
        case 3
            messagenexttrial = 'Next: Occluded';
        case 4
            messagenexttrial = 'Next: Deleted Sharp';
        case 5
            messagenexttrial = 'Next: Deleted Fuzzy';
    end
    
      
    
     
    
    %show fix
    Screen('TextSize', window, 20);
    Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
        
    
    % DrawFormattedText(window, messagenexttrial, 'center', 'center', white,[],1);
       
    
    Screen('Flip', window);
    
    KbStrokeWait;
    
    
    for ntrials = 1:length(condsorder)
                
        ourtime = 0;
        incrementframe = 0;
        
        %get timestamp
        vbl = Screen('Flip', window);
        
        start_time = vbl;
        
        % _________________________________________________
        % SHOW THE CONTROL
        
        ToggleArd(ard,'LeftOff') % turn left lens off
        
        while vbl - start_time < 0.8
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
            Screen('TextSize', window, 20);
            Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
            
            
            %        %   fix point
            %           Screen('FillOval', window, uint8(white), l_fix_cord1);
            %            Screen('FillOval', window, uint8(black), l_fix_cord2);
            % display intact at SF of 0.3 ir gratingtex(2)
            Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
            %             Screen('Flip', window);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi);
%             ourtime = ourtime + ifi;
            incrementframe = incrementframe + 1;
                    if makescreenshotsforvideo
                          imageArray = Screen('GetImage', window);
                          filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
                          imwrite(imageArray, filenameimage);
                          framenumber = framenumber+1;
                    end
        end    %while
        
        
        % _________________________________________________
        % SHOW BLANK SCREEN FOR 500 ms
        
        ToggleArd(ard,'LensOn') %all on for the ISI
        % blank ISI
               
        % do this ONCE outside the loop
        %show fix
        Screen('TextSize', window, 20);
        Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        %        then do another flip to clear this half a sec later
        vbl = Screen('Flip', window, vbl + (0.5/ifi - 0.2) * ifi);
      
        if makescreenshotsforvideo
            for imageframes = 1:30 %for 30 frames (0.5s)
                imageArray = Screen('GetImage', window);
                filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
                imwrite(imageArray, filenameimage);
                framenumber = framenumber+1;
            end
        end
       
        incrementframe = 0;
        
        thistrial = allcondscombos(condsorder(ntrials),:); %determine the trial. Conds order has the trial order. Go through it one by one until ntrials
        
                
               
        start_time = vbl;
        stimdurframes = round(0.8/ifi); % 48 frames on 60 hz
        
        % ___________________________________________________________________________________
        % SHOW THE COMPARISON STIM
        if strcmp(whicheye, 'right'); %compare strings
            % BS trial so open right lens
            ToggleArd(ard,'LeftOff') %close left
        else
            ToggleArd(ard,'RightOff') %close right
        end
        
        while vbl - start_time < 0.8
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
            
                        
            
            %show fix
            Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
            
            
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
                    Screen('FillOval', window, white*0.7, occluderRectCentre_Expt, maxDiameter); %'white' occluder of 0.7 greyness
                    Screen('FrameOval', window, [0 0 0], occluderRectCentre_Expt, 3);
                case 4 %Deleted sharp
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %
                    %grey mask
                    Screen('FillOval', window, grey_bkg, occluderRectCentre_Expt, maxDiameter); %grey occluder
                case 5 %Deleted fuzzy
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    Screen('DrawTexture', window, gratingtex(thistrial(2),1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %fuzzy mask
                    Screen('DrawTexture', window, maskTexture, [], fuzzyRectCentre_Expt);
            end %switch
            
            Screen('DrawingFinished', window);
            
            % fix point
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2  ) * ifi);
           
            incrementframe = incrementframe + 1;
            
        end %while 
        
        try
            resp2Bmade = true;
            curr_response = 0;
            numFrames = 0;
            starttime = GetSecs;
            
            ToggleArd(ard,'LensOn') %both eyes back on
                        
            while resp2Bmade == true;
                                
                numFrames = numFrames + 1;
                
                
                %show fix
                Screen('TextSize', window, 20);
                Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
                
                DrawFormattedText(window, 'Make response \n \n L = 1st was denser R = 2nd was denser', 'center', 'center', white, [],[]);
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
                
                [keyIsDown,secs, keyCode] = KbCheck;%
                
                % leftKey = KbName('LeftArrow');
                % rightKey = KbName('RightArrow');
                
                endtime = 0;
                
                if keyIsDown
                    if keyCode(escapeKey);
                        resp2Bmade = false; endtime = GetSecs; save (filename); sca; ToggleArd(ard,'AllOff'); ShutdownArd(ard,comPort);
                        disp('Arduino is off')
                    elseif keyCode(leftKey); resp2Bmade = false; curr_response = 1; save (filename); endtime = GetSecs;
                    elseif keyCode(rightKey); resp2Bmade = false; curr_response = 2; save (filename); endtime = GetSecs;
                    else
                        %just go through the while loop since resp2Bmade is
                        %still true
                    end %end if
                    
                    % if L or R has been pressed, record response
                    % Clear screen
                    subjectdata(ntrials,3) = curr_response; % LEFT eye was the fellow eye
                    subjectdata(ntrials,1) = thistrial(1); %record cond of this trial
                    subjectdata(ntrials,2) = thistrial(2); %record SF of this trial
                    subjectdata(ntrials,5) = numFrames*ifi; % Record RT in secs
                    subjectdata(ntrials,6) = endtime - starttime; % Record RT in secs
                    
                end
                
                if makescreenshotsforvideo
                    for imageframes = 1:100 %for 100 frames
                        imageArray = Screen('GetImage', window);
                        filenameimage = sprintf('screenshots\\myscreenshot%d.jpg', framenumber);
                        imwrite(imageArray, filenameimage);
                        framenumber = framenumber+1;
                    end
                end
                                         
            end %while
                                    
        catch keyerr
            save filename
            sca
            rethrow(keyerr)
            ToggleArd(ard,'AllOff');
            ShutdownArd(ard,comPort);
            disp('Arduino is off')
        end
                
        
        try
            if ntrials ~=250
                nexttrial = allcondscombos(condsorder(ntrials+1),:);
                switch nexttrial(1)
                    case 1
                        messagenexttrial = 'Next: Intact';
                        whicheye = 'right';
                    case 2
                        messagenexttrial = 'Next: Blindspot';
                        whicheye = 'left';
                    case 3
                        messagenexttrial = 'Next: Occluded';
                        whicheye = 'right';
                    case 4
                        messagenexttrial = 'Next: Deleted Sharp';
                        whicheye = 'right';
                    case 5
                        messagenexttrial = 'Next: Deleted Fuzzy';
                        whicheye = 'right';
                end
            end
            %show fix
            Screen('TextSize', window, 20);
            Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
            
            if mod(ntrials,50) == 0 %if a block of 50 trials has been completed. ntrials divided by 50 should leave no remainder, ie 150/50 = 3, 50/50 = 1 etc
                messagetext = sprintf('Trial %d out of %d completed. \n \n Have a break, have a kitkat! \n \n Press UP key to continue \n \n Then Space to start a trial', ntrials, length(condsorder));
                DrawFormattedText(window, messagetext, 'center', 'center', white,[],[]);
                Screen('Flip', window);
                while ~keyCode(upKey)
                    [keyIsDown,secs, keyCode] = KbCheck;% Check the keyboard to see if a button has been pressed
                end
            end
            
            %  DrawFormattedText(window, messagenexttrial, 'center', 'center', white,[],[]);
            
            %show fix
            Screen('TextSize', window, 20);
            Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
            Screen('Flip', window);
            
            [secs, keyCode, deltaSecs] = KbStrokeWait; %wait for space
            
            while ~keyCode(space) %while something other than space was pressed, don't move on. Unless it's quit demo
                
                [keyIsDown,secs, keyCode] = KbCheck;% Check the keyboard to see if a button has been pressed
                %
                if keyCode(escapeKey)
                    save (filename)
                    sca %if esc then just quit demo
                    ToggleArd(ard,'AllOff');
                    ShutdownArd(ard,comPort);
                    disp('Arduino is off')
                    break;
                end
            end %end while. Move onto next trial
        catch whileerr
            sca
            ToggleArd(ard,'AllOff');
            ShutdownArd(ard,comPort);
            disp('Arduino is off')
            rethrow(whileerr)
        end
    end %for
    
catch ERR3
    sca
    rethrow(ERR3)
    disp('Experiment error! Plz check your code!')
    %Close goggles
    %shut down ARDUINO
    ToggleArd(ard,'AllOff');
    ShutdownArd(ard,comPort);
    disp('Arduino is off')
end



save (filename)
%Close goggles
% Shut down ARDUINO
ToggleArd(ard,'AllOff');
ShutdownArd(ard,comPort);
disp('Arduino is off')
sca
catch OverallErr
    ToggleArd(ard,'AllOff')
    disp('Check goggles are off')
    ShutdownArd(ard,comPort);
    disp('Arduino is off')
    rethrow(OverallErr)
end