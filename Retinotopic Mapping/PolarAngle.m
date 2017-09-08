% Polar Angle Mapping
% Using stimulus images from Andrew Tyler Morgan, University of Glasgow
%
% 2017 Yulia Revina, NTU, SG

%%% toggle goggles for debugging %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
togglegoggle = 0; % 0 goggles off for debug; 1 = goggles on for real expt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bs_eye = 'right';   %% Right eye has the blind spot. Left fixation spot

% if ~IsWin
    devices = PsychHID('Devices');
% end
keyboardind = GetKeyboardIndices();
mouseind = GetMouseIndices();


KbName('UnifyKeyNames')


todaydate  = date;


subCode = input('Enter Subject Code:   ');
subAge = input('Enter Subject Age in yrs:   ');
subGender = input('Enter Subject Gender:   ');


filename = sprintf('Data_%s_%s_%s_%s.mat', todaydate, subCode, num2str(subAge), subGender);


responses = {};
resp = 1; %counter for responses

fileID = fopen('polarresp.txt','w');


ard =[]; %dummy variable in case we are not using goggles


if togglegoggle == 1;
    [ard, comPort] = InitArduino;
    disp('Arduino Initiated')
    
    goggles(bs_eye, 'both', togglegoggle,ard)
%     ToggleArd(ard,'LensOn') % need both eyes to view everything up until the actual experiment trials (and for the BS measurement)
    
    % Remember to switch this off if the code stops for any reason. Any
    % Try/Catch routines should have LensOff integrated there...
end

%% stim parameters

dir = [];

stimDur = 125; %ms

nStims = 512;

imWidth = 768;
imHeight = 768;

textcolor = [0 0 0];



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



%open screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey_bkg);
 
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

nFrames2wait4nextStim = stimDur/1000/ifi; 



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


try
%% stimuli

%load the images
% theImage = ones(1,1,3,nStims); %images are in format H x W x 3 uint8
% img = ones(1,1,3,nStims); %images are in format H x W x 3 uint8
Screen('FillRect', window, grey) % make the whole screen grey_bkg
DrawFormattedText(window, 'Loading...', 'center', 'center', textcolor, [], []);
vbl = Screen('Flip', window);
WaitSecs(1);


% Here we load in an image from file.
for imnumber = 1:nStims
    %get the location
    
%     theImageLocation = sprintf('C:/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/PA_Images/3x3-geocaching-logo-sticker_500_1.jpg');
%     3x3-geocaching-logo-sticker_500_1.jpg
    theImageLocation = sprintf('C:/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/PA_Images/PolAngImage_%d.png', imnumber);
    % load the image from location
    [img, ~, alpha] = imread(theImageLocation);
%     theImage(:,:,:,imnumber) = double(imread(theImageLocation));
    % Make the image into a texture
    
    texture1(imnumber) = Screen('MakeTexture', window, img);
    img(:, :, 4) = alpha;
    texture2(imnumber) = Screen('MakeTexture', window, img);
    Screen('FillRect', window, grey) % make the whole screen grey_bkg
%   imageTexture(imnumber) = Screen('MakeTexture', window, theImage(:,:,:,imnumber));
    DrawFormattedText(window, sprintf('Loading... %d',imnumber), 'center', 'center', textcolor, [], []);
    vbl = Screen('Flip', window);
end


% load spider web
theImageLocation = sprintf('C:/Users/HSS/Documents/GitHub/experiments/Retinotopic Mapping/SpiderWebBackground.png');
[SpiderWeb, ~, alphaspider] = imread(theImageLocation);
SpiderTex(1) = Screen('MakeTexture', window, SpiderWeb);
SpiderWeb(:,:,4) = alphaspider;
SpiderTex(2) = Screen('MakeTexture', window, SpiderWeb);

DrawFormattedText(window, 'Finished', 'center', 'center', textcolor, [], []);
vbl = Screen('Flip', window); 
    
WaitSecs(2);    
    
    
%% present instructions and wait for trigger
Screen('FillRect', window, grey) % make the whole screen grey_bkg

instructions = 'Please fixate at the center at all times \n \n Press with index finger when you see color change \n \n Standby for Scanner Trigger';
DrawFormattedText(window, instructions, 'center', 'center', textcolor, [], []);

%flip to screen
Screen('TextSize', window, 20);
vbl = Screen('Flip', window);


goggles(bs_eye, 'both',togglegoggle) %(BS eye, viewing eye)

disp('Waiting for scanner trigger...')

[secs, keyCode, deltaSecs]=    KbStrokeWait;

while ~keyCode(scannertrigger) %while not trigger
    [keyIsDown, secs, keyCode] = KbCheck;% Check the keyboard to see if a button has been pressed
end

vbl = secs; %get timestamp
KbQueueCreate(); %start listening for key presses
KbQueueStart();
start_time = secs;

%% %%%%% FIX 12 s %%%%%%%%%%%%%%%%%%%%%%%%%

while vbl - start_time < ((12/ifi - 0.2)*ifi)%time is under 12 s
    Screen('FillRect', window, grey) % make the whole screen grey_bkg
    Screen('DrawTexture', window, SpiderTex(2), [], [], 0); %Draw
    vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
end

%% %%%%%%% Images %%%%%%%%%%%%%%%%%%%%%%%

% Draw the image to the screen, unless otherwise specified PTB will draw
% the texture full size in the center of the screen.

% % texture1 = Screen('MakeTexture', w, img);
% % img(:, :, 4) = alpha;
% % texture2 = Screen('MakeTexture', w, img);
% % 
for i = 1:12 %12 repetitions of the cycle
    for imnumber = 1:nStims
        Screen('FillRect', window, grey) % make the whole screen grey_bkg
        Screen('DrawTexture', window, SpiderTex(2), [], [], 0); %Draw
        
        %         First, the image without the alpha channel.
        %         Screen('DrawTexture', window, texture1(imnumber), [], []);
        
        %         Then, the RGBA texture.
        Screen('DrawTexture', window, texture2(imnumber), [], []);
        
        %         Screen('DrawTexture', window, imageTexture(imnumber), [], [], 0); %Draw
        DrawFormattedText(window, sprintf('Image %d',imnumber), 'center', 'center', [1 0 0], [], []);
        %     Flip to the screen
        vbl = Screen('Flip', window, vbl + (nFrames2wait4nextStim - 0.2) * ifi); %flip every 125 ms
    end %stim
end %cycle
% 
start_time = vbl;
%% %%% 12s fix %%%%%%%%%%%%%%%%%%
while vbl - start_time < ((12/ifi - 0.2)*ifi)%time is under 12 s
    Screen('FillRect', window, grey) % make the whole screen grey_bkg
    Screen('DrawTexture', window, SpiderTex(2), [], [], 0); %Draw
    vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip on next frame after trigger press or after last flip of stim
end

%% the end
DrawFormattedText(window, sprintf('The End!'), 'center', 'center', [1 0 0], [], []);
vbl = Screen('Flip', window);
WaitSecs(2);

catch ERR
    rethrow(ERR)
    sca
end


sca
