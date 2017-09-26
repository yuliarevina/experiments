% Test script for moving gratings with occlusion etc.
% Yulia Revina 2017

% clear all; %don't want to do this for the real expt otherwise it will delete the blindspot measurements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get some hardware info %%%%%%%%%%%%%%%%%%%%%%%

devices = PsychHID('Devices');
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


DisableKeysForKbCheck([]) % listen for all keys at the start




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subnum = 0 %enter subject number
thisrun = 2 %change run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block = 1;
stim = 1;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


todaydate = date;

stereoModeOn = 0; %don't need this for goggles, only for the 2 screen setup
stereoMode = 4;        % 4 for split screen, 10 for two screens
makescreenshotsforvideo = 0;

%%% toggle goggles for debugging %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
togglegoggle = 1; % 0 goggles off for debug; 1 = goggles on for real expt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% DEMO ON/OFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Demo = 0; %show the debug bars at the start?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


bs_eye = 'right';   %% Left eye has the blind spot. Left fixation spot


% ASK FOR SUBJECT DETAILS

subCode = input('Enter Subject Code:   ');
subAge = input('Enter Subject Age in yrs:   ');
subGender = input('Enter Subject Gender:   ');

%%%%%%%%%%%%%%%% load sequence of stims % creat files
load(sprintf('sub%s_MRI_stim_seq.mat', num2str(subnum)))
filename = sprintf('Data_%s_%s_%s_%s.mat', todaydate, subCode, num2str(subAge), subGender);
filenametxt = sprintf('Data_%s_%s_%s_%s.txt', todaydate, subCode, num2str(subAge), subGender);
fileID = fopen(filenametxt,'w');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


distance2screen = 42; % how many centimeters from eye to screen? To make this portable on different machines

outside_BS = 5; %deg of visual angle
outside_BS = round(deg2pix_YR_MRI(outside_BS)); %in pixels for our screen

brightness = 0.1;
% brightness = 0.7; % for debugging
textcolor = [0 0 0];

% timing
goggle_delay = 0.35; %seconds to keep lens closed after stim offset, to account for slow fade out of stim
fix_black = 12; %seconds
fix_grey = 6; %seconds
stim_dur = 12; %seconds


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
% grey_bkg = grey*brightness/10
grey_bkg = black


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


% Set the blend function for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

if ~IsWin
% % correct non-linearity from CLUT
oldCLUT = Screen('LoadNormalizedGammaTable', screenNumber, clut);
end

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


%% ---------------------------------------
% Set up Arduino for Goggles use
% ________________________________________

if togglegoggle == 1;
    [ard, comPort] = InitArduino;
    disp('Arduino Initiated')
    
    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye) need both eyes to view everything up until the actual experiment trials (and for the BS measurement)
        
    % Remember to switch this off if the code stops for any reason. Any
    % Try/Catch routines should have LensOff integrated there...
end

try
%% ---------------
%  Intro screen  |
%-----------------
ShowFix()

instructions = 'Hello and welcome \n \n to the experiment for perceptual filling-in \n \n Press any key to continue';
DrawFormattedText(window, instructions, 'center', 'center', textcolor, [], []);

%flip to screen
Screen('Flip', window);
KbStrokeWait([-1]);

%% -----------------
% Measure blind spot if we dont have the measurements already
% ------------------------------

if (~exist('BS_diameter_h') || ~exist('BS_diameter_v'))
    %show fix
    Screen('TextSize', window, 20);
    ShowFix();
%     Screen('DrawText',window, '+', l_fix_cord1(1), l_fix_cord1(2)-8,white);
    % instructions
    DrawFormattedText(window, 'Let''s measure the blindspot! \n \n Press the A and B buttons to move the flickering marker \n \n until it completely disappears for you \n \n Press C to confirm your response \n \n Take your time, this step is very important! \n \n Press any key...', 'center', 'center', textcolor, [], []);
    Screen('Flip', window);
    KbStrokeWait([-1]); 
    goggles(bs_eye, 'BS',togglegoggle,ard) %(BS eye, viewing eye)

    if ~IsWin
        HideCursor(1,0)
    else
        HideCursor()
    end
    measure_BS_h_YR_1screen_MRI    %horizontal
    measure_BS_v_YR_1screen_MRI    %vertical
    measure_BS_h2_YR_1screen_MRI   %measure horizontal again based on the midline of vertical (bcos BS is not exactly centered on horiz merid)
    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)
    ShowCursor()
end


%draw a blindspot oval to test its location
oval_rect = [0 0 BS_diameter_h2 BS_diameter_v];
oval_rect_centred = CenterRectOnPoint(oval_rect, BS_center_h2, BS_center_v);

ShowFix()

% show blind spot
Screen('FillOval', window, [0.2 0.2 0.2], oval_rect_centred);
DrawFormattedText(window, 'This is the location of blindspot \n \n Check you cannot see it \n \n by closing your RIGHT eye and fixating on the +', 'center', 'center', textcolor, [],[]);

Screen('Flip', window);
KbStrokeWait([-1]);

%% --------------------
% Recording responses |
% ---------------------
% nRuns = 6;
% nSeqs = 5;
% nStimsInSeq = 6;
% 
% allperms = perms([1:6]);
% 
% runseq = nan(nSeqs,nStimsInSeq,nRuns);
% 
% totalnSeqs= nSeqs*nRuns; %5 seqs x 8 runs
% 
% % a = 1;
% % b = 120;
% % r = round((b-a).*rand(numberofseqs,1) + a); % generate random n's from 1 to 120 with repetition
% r = randperm(size(allperms,1),totalnSeqs); %generate 40 unique numbers from 1 to 120
% 
% % generate unique sequences for all runs
% allseqs = allperms(r,:);
% 
% counter = 1;
% for run = 1:nRuns
%     runseq(:,:,run) = allseqs(counter:counter+nSeqs-1,:); %e.g 1:6, 7:11
%     counter = counter+nSeqs;
% end


% runseq(:,:,2) = allseqs(6:10,:); %run2
% runseq(:,:,3) = allseqs(11:15,:); % etc
% runseq(:,:,4) = allseqs(16:20,:);
% runseq(:,:,5) = allseqs(21:25,:);
% runseq(:,:,6) = allseqs(26:30,:);
% runseq(:,:,7) = allseqs(31:35,:);
% runseq(:,:,8) = allseqs(36:40,:);

% numberofreps = 10; %how many repetitions of each type of trial?

% allcondscombos = CombVec(1:5,1:5)'; %generate all combinations of conditions and SFs, eg 1 1, 1 2, 1 3, ... 3 3, 3 4 etc
% allcondscombos(:,[1,2]) = allcondscombos(:,[2,1]); %swap columns because it's easier for me to look at that way haha
% allcondscombos = repmat(allcondscombos,numberofreps,1); % multiply the combinations by how many times we want to repeat them.
% This will be the full matrix for the whole expt for this subject (for one
% run possibly. Depending on how we wannna split it up).

%shuffle rows
% condsorder = randperm(size(allcondscombos,1)); %this is the order of the conditions for each subject

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


% subjectdata = nan(size(allcondscombos,1), 6);
% curr_response = 0; %store current response on trial n



responses = {};
resp = 1; %counter for responses



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

maxContrast = .75; %original
% maxContrast = 1;

bar_width = 1.73; %1.73 deg like in gerrit's prev expts
bar_width = round(deg2pix_YR_MRI(bar_width));
% bar_length = BS_vert_diameter+2*5deg_visual_angle
bar_length = BS_diameter_v+2*outside_BS; % +50 for testing

% define our timings here, let's not hard code it later (bad!)
stimDur = .8;
isi     = .5;

%% -------------------------------
% Stimulus preparation  - Grating|
% --------------------------------

cyclesPerWholeGrating = pix2deg_YR_MRI(gratingSize) .* cyclesPerDeg;
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
%                 grating(p,t,:) = (grey + tcos(t)*maxContrast*inc*sin(fr*x)) * 0.2;
%                 grating2(p,t,:) = (grey + maxContrast*inc*sin(fr*x)) ; %removed the tcos. We need the same contrast every frame
                  grating2(p,t,:) = ((grey + maxContrast*inc*sin(fr*x))) * brightness ; % scaled by 1/5th because screen is a 5th of the
%                 original luminance
        end
        gratingtex(p,t) = Screen('MakeTexture', window, squeeze(grating2(p,t,:)), [], 1);
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
BSw = BS_diameter_h2; %blindspot width

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
dstRectStim_BS_r = CenterRectOnPointd(dstRect(1, :),BS_center_h2,BS_center_v);



occluderRectCentre_Demo = CenterRectOnPointd(occluderRect, squareXpos(3), yCenter);
greyoccluderRectCentre_Demo = CenterRectOnPointd(occluderRect, squareXpos(4), yCenter);
fuzzyoccluderRectCentre_Demo = CenterRectOnPointd(occluderRect, squareXpos(5), yCenter);
occluderRectCentre_Expt = CenterRectOnPointd(occluderRect, BS_center_h2,BS_center_v);

% fuzzyRect = [0 0 BSw+10 BSh+10]; %make the fuzzy rect a bit bigger cos it needs to spread out its fuzziness a bit

% fuzzy mask rect
fuzzyRectCentre_Demo = CenterRectOnPointd(gaussRect, squareXpos(5), yCenter);
fuzzyRectCentre_Expt = CenterRectOnPointd(gaussRect, BS_center_h2,BS_center_v);




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
if Demo == 1
while exitDemo == false
    % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck([-1]);
    
    % KbStrokeWait; %wait for key press
    try
                   
        ShowFix()
        
        
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
                        Screen('FillOval', window, white*0.7*brightness, occluderRectCentre_Demo, maxDiameter); %'white' occluder of 0.7 greyness
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
end %demo
% Screen('FinalizeMovie', movie1);


%% BLOCK
    
    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)    
        
    %get timestamp
    Screen('TextSize', window, 20);
    DrawFormattedText(window, 'Waiting for scanner trigger...', 'center', 'center', textcolor,[],[]);
    Screen('Flip', window);
    disp('Waiting for scanner trigger...')
    
    [secs, keyCode, deltaSecs]=    KbStrokeWait([-1]);
    
    while ~keyCode(scannertrigger)
        [keyIsDown, secs, keyCode] = KbCheck([-1]);% Check the keyboard to see if a button has been pressed
    end
    
     disp('Trigger detected')
    DisableKeysForKbCheck(scannertrigger); % now disable the scanner trigger
    

timestart = secs; %time elapsed since trigger press
vbl= secs; %get trigger press for timing of block 1
KbQueueCreate(deviceindexSubject);
% KbQueueCreate(deviceindexExperimenter);

KbQueueStart(deviceindexSubject);
% KbQueueStart(deviceindexExperimenter);

for block = 1:nSeqs
    
    disp(sprintf('Block %d', block));
    % Grey fix 6s
    % Stim
    % and repeat
    % end of last seq we need an extra 6s grey fix
%     vbl =  Screen('Flip', window);
%     startblock = GetSecs;
    
    
    for stim = 1:nStimsInSeq
        

%         KbQueueStart();

        %show stims interleaved by 6s fix
        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%% FIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
        % ADD TASK on fix pt

        curr_frame = 1;
        start_time = vbl;

        totalframes = fix_grey/ifi;
        taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand); % task can appear 1s after trial start and no later than 1s before end of trial (to give time for resp)
        
        respmade = 0;
        
        startSecs = 0; %so we have this variable defined in case sub pressed button before the task even starts
 
 
 
        goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)  
        
        time_zero = vbl;
        if stim == 1
            startblock = vbl; %if the start of a block, record first flip of stim onset
        end
        
        while vbl - start_time < ((fix_grey/ifi - 0.2)*ifi)%time is under 12 s
            
            Screen('FillRect', window, grey) % make the whole screen grey_bkg
            
            % --------- flash fix pt ------------------------------------------------
            if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/ifi) %if between taskframe and taskframe + 1s
                %show alternative fix
                if curr_frame == taskframe %if the very first frame
                    startSecs = GetSecs();
                    disp('Task!')%rough onset of alternative fix
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
            end %----------------------------------------------------------
            
            DrawFormattedText(window, '6s fixation...', 'center', 'center', black,[],[]);
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
            curr_frame = curr_frame + 1; %increment frame counter
            
            %        then do another flip to clear this half a sec later
            %         KbQueueStop();
            %check for ESC key
            
%             vbl = Screen('Flip', window, vbl + (fix_grey/ifi - 0.2) * ifi);
                      
            
            % record responses
           [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
%            [pressed, firstPress]=KbQueueCheck(deviceindexExperimenter);
            [keyIsDown, secs, keyCode] = KbCheck([-1]);
            pressedKeys = KbName(firstPress); %which key
            timeSecs = firstPress(find(firstPress)); %what time
            if pressed %report the keypress for the experimenter to see
                % Again, fprintf will give an error if multiple keys have been pressed
                
                fprintf('"%s" typed at time %.3f seconds  %d  Fix  \r\n', KbName(firstPress), timeSecs - startSecs, block);
                fprintf(fileID,'"%s" typed at time %.3f seconds  %d  Fix  \r\n', KbName(firstPress), timeSecs - startSecs, block);
                
%                 fprintf('"%s" typed at time %.3f seconds\n', KbName(firstPress), timeSecs - startSecs);
                RT = timeSecs - startSecs;
                responses{resp,1}= block;
                responses{resp,2} = 'Fix';
                responses{resp,3} = pressedKeys;
                responses{resp,4} = RT;
                respmade = 1;
            else
               
            end
            % end of response recording
            
             % Check the keyboard to see if a button has been pressed
            [keyIsDown,secs, keyCode] = KbCheck([-1]);
            
            
            if max(strcmp(pressedKeys,'ESCAPE')) || keyCode(escapeKey)
                save(filename)
                goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
                if togglegoggle == 1
                    ShutdownArd(ard,comPort);
                end
                %             close goggles
                %             save any data
                pressedKeys
                disp('Escape this madness!!')
                sca
                fclose(fileID);
                save(filename)
            end
        end %while
        
        if ~respmade %if no response whatsoever
            RT = NaN;
            responses{resp,1}= block;
            responses{resp,2} = 'Fix';
            responses{resp,3} = 'No response';
            responses{resp,4} = RT;
        end
        resp = resp + 1; %update resp counter
        

        time_elapsed = vbl - time_zero;
        time_elapsed2 = vbl - startblock;
        time_elapsed3 = vbl - timestart;
        disp(sprintf('    Time elapsed for 6s fix:  %.5f seconds from first flip',time_elapsed));
        disp(sprintf('    Time elapsed for 6s fix:  %.5f seconds from startblock',time_elapsed2));
        disp(sprintf('    Time elapsed for 6s fix:  %.5f seconds from scannertrigg',time_elapsed3));
        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%% STIMULUS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        whicheye = 'fellow';
        
%         nexttrial = allcondscombos(condsorder(1),:);
        switch runseq(block,stim,thisrun)
            case 1
                messagenexttrial = 'Next: Intact';
                disp(messagenexttrial);
            case 2
                messagenexttrial = 'Next: Blindspot';
                whicheye = 'BS';
                disp(messagenexttrial);
            case 3
                messagenexttrial = 'Next: Occluded';
                disp(messagenexttrial);
            case 4
                messagenexttrial = 'Next: Deleted Sharp';
                disp(messagenexttrial);
            case 5
                messagenexttrial = 'Next: Deleted Fuzzy';
                disp(messagenexttrial);
            case 6
                messagenexttrial = 'Next: Black 12s fix';
                disp(messagenexttrial);
                whicheye = 'both';
        end
        
        
        
        %goggles
       if strcmp(whicheye, 'fellow'); %compare strings
            goggles(bs_eye, 'fellow',togglegoggle,ard) %(BS eye, viewing eye)
       elseif strcmp(whicheye, 'BS')
            goggles(bs_eye, 'BS',togglegoggle,ard) %(BS eye, viewing eye)
       else
            goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)
       end
%         Screen('FillRect', window, grey_bkg) % make the whole screen grey_bkg
%         ShowFix()
%         vbl = Screen('Flip', window);
        start_time = vbl;
        incrementframe = 0;
        
        
        curr_frame = 1;
        start_time = vbl;
        
        totalframes = 12/ifi;
        taskframe = round(1/ifi + ((totalframes-(1/ifi))-1/ifi).*rand);
        
        respmade = 0;
        
        
        while (vbl - start_time) < ((stim_dur/ifi - 0.2)*ifi) 
           

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
            
            
            Screen('FillRect', window, grey_bkg) % make the whole screen grey_bkg

            
            
            if curr_frame > taskframe - 1 && curr_frame < (taskframe + 1/ifi) %if between taskframe and taskframe + 1s
                %show alternative fix
                if curr_frame == taskframe %if the very first frame
                    startSecs = GetSecs(); %rough onset of alternative fix
                    disp('Task!')
                end
                AlternativeShowFixRed() %red
%                 disp(num2str(curr_frame))
                %                                 disp(num2str(taskframe))
%                 disp('alternative')
                
            else
                ShowFix() %white
%                 disp(num2str(curr_frame))
                %                                 disp(num2str(taskframe))
%                 disp('normal')
            end
            
            
%             Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
            
            
            switch runseq(block,stim,thisrun)
                case 1 %intact
                    Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %
                    %we don't need to do anything else
                case 2 %Blindspot - special case, we need to present to the other eye!
                    Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %present the grating of the SF stored in thistrial(2) to
                    %the RIGHT EYE
                    %
                    %we don't need to do anything else
                case 3 %Occluded
                    Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %
                    %pop on the occluder
                    Screen('FillOval', window, white*0.5*brightness, occluderRectCentre_Expt, maxDiameter); %'white' occluder of 0.7 greyness
                    Screen('FrameOval', window, [(white*0.5*brightness)/2], occluderRectCentre_Expt, 3);
                case 4 %Deleted sharp
                    Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %
                    %grey mask
                    Screen('FillOval', window, grey_bkg, occluderRectCentre_Expt, maxDiameter); %grey occluder
                case 5 %Deleted fuzzy
                    Screen('DrawTexture', window, gratingtex(2,1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %present the grating of the SF stored in thistrial(2) to
                    %the LEFT EYE
                    %                     Screen('DrawTexture', window, gratingtex(thistrial(2),1), srcRect, dstRectStim_BS_r); %gratingtex(i,1) high amplitude ie high contrast
                    %fuzzy mask
                    Screen('DrawTexture', window, maskTexture, [], fuzzyRectCentre_Expt);
                case 6 % black fix
                    % we dont need to do anything else. Just blank screen
                    % for 12 seconds
            end %switch
            
            Screen('DrawingFinished', window);
            
            % fix point
            
            vbl = Screen('Flip', window, vbl + (waitframes - 0.2  ) * ifi);
            

            curr_frame = curr_frame + 1; %increment frame counter for task
            incrementframe = incrementframe + 1; %increment frame counter for motion
            
            % record responses
            [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
%             [pressed, firstPress]=KbQueueCheck(deviceindexExperimenter);
            [keyIsDown, secs, keyCode] = KbCheck([-1]);
            pressedKeys = KbName(firstPress); %which key
            timeSecs = firstPress(find(firstPress)); %what time
            if pressed %report the keypress for the experimenter to see
                % Again, fprintf will give an error if multiple keys have been pressed
                fprintf('"%s" typed at time %.3f seconds %d  %d  \r\n', KbName(firstPress), timeSecs - startSecs,block, stim);
                fprintf(fileID,'"%s" typed at time %.3f seconds  %d  %d  \r\n', KbName(firstPress), timeSecs - startSecs,block,stim);
                
%                 fprintf('"%s" typed at time %.3f seconds\n', KbName(firstPress), timeSecs - startSecs);
                RT = timeSecs - startSecs;
                responses{resp,1}= block;
                responses{resp,2} = stim;
                responses{resp,3} = pressedKeys;
                responses{resp,4} = RT;
                respmade = 1;
                
            end
            % end of response recording
            
              % Check the keyboard to see if a button has been pressed
            [keyIsDown,secs, keyCode] = KbCheck([-1]);
            
            
            if  max(strcmp(pressedKeys,'ESCAPE')) || keyCode(escapeKey)
                save(filename)
                goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
                if togglegoggle == 1
                   ShutdownArd(ard,comPort);
                end
%               close goggles
%               save any data
                pressedKeys
                disp('Escape this madness!!')
                sca
                fclose(fileID);
                save(filename)
            end
            
            
            
            
        end %while
        
        if ~respmade %if no response was made at all
            RT = NaN;
            responses{resp,1}= block;
            responses{resp,2} = stim;
            responses{resp,3} = 'No response';
            responses{resp,4} = RT;
        end
        resp = resp + 1; %update resp counter
        
        

        time_elapsed = vbl - start_time;
        time_elapsed2 = GetSecs - start_time;
        disp(sprintf('    Time elapsed for stimulus:  %.5f seconds using VBL - start',time_elapsed));
        disp(sprintf('    Time elapsed for stimulus:  %.5f seconds using GetSecs - start',time_elapsed2));
        disp(sprintf('    N frames:  %.5f',incrementframe-1));

    end
    
    %for last block add one last 6s fix
    if block == 5
        goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)       
 
        Screen('FillRect', window, grey) % make the whole screen grey_bkg
        ShowFix()
        DrawFormattedText(window, '6s fixation...', 'center', 'center', black,[],[]);
        vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi);
        time_zero = vbl;
        %        then do another flip to clear this half a sec later
%         KbQueueStop();
        %check for ESC key
      
        vbl = Screen('Flip', window, vbl + (fix_grey/ifi - 0.2) * ifi);
        [pressed, firstPress]=KbQueueCheck(deviceindexSubject);
%         [pressed, firstPress]=KbQueueCheck(deviceindexExperimenter);
       
        
        pressedKeys = KbName(firstPress);
        
        
         % Check the keyboard to see if a button has been pressed
            [keyIsDown,secs, keyCode] = KbCheck([-1]);
        
        if max(strcmp(pressedKeys,'ESCAPE')) || keyCode(escapeKey)
            save(filename)
            goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
            if togglegoggle == 1
                ShutdownArd(ard,comPort);
            end
%             close goggles
%             save any data
            pressedKeys
            disp('Escape this madness!!')
            sca
            save(filename);
            fclose(fileID);
        end
        time_elapsed = vbl - time_zero;
        disp(sprintf('    Time elapsed for 6s fix:  %.5f seconds',time_elapsed));
    end
       
%          
    totalblocktime(block) = vbl - startblock;
    disp(sprintf('    Time elapsed for block:  %.5f seconds \n \n',totalblocktime));       
end
KbQueueStop(deviceindexSubject);
% KbQueueStop(deviceindexExperimenter);
totalexpttime = sum(totalblocktime);
disp(sprintf('    Time elapsed for experiment:  %.5f seconds',totalexpttime));  
timeend = GetSecs;
totalexpttime2 = timeend -timestart;
disp(sprintf('    Time elapsed for experiment:  %.5f seconds (Using GetSecs)',totalexpttime));  
     
%     disp(sprintf('Trial %d out of %d completed.', ntrials, length(condsorder)))
% close goggles
goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
if togglegoggle == 1
    ShutdownArd(ard,comPort);
end
      
catch overallerror
    goggles(bs_eye, 'neither',togglegoggle,ard) %(BS eye, viewing eye)
    save(filename)
if togglegoggle == 1
    ShutdownArd(ard,comPort);
end
    save(filename)
    rethrow(overallerror)
    sca
    disp('Something is wrong!')
    fclose(fileID);
end

sca; save(filename)
fclose(fileID);