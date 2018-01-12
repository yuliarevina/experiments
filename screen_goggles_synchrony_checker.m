% Check if monitor and goggles are synchronized at MRI. In other words,
% there should be no perceptual delay between goggles opening and screen
% turning on, since we do not want participants to see/not see the stimulus
% at the wrong time.

%from earlier tests the screen seems to turn on a little bit after the
%goggles

% test red screen when goggles open and black screen when goggles are
% closed. With perfect synchrony, you should never see the black screen.
% Test various delays in ms to see which works the best. As the other
% alternative is to mess about with the photometer.


% Written by Yulia Revina, NTU, Singapore. January 2018.

delays = [0 0.05 0.1 0.2 0.3 0.4 0.5]; %delays to check in ms

% stims to switch every TR ie 2s. Might help to see if there is an
% asynchrony in TR as well

switchfreq = 2; %in s



%% set up


%%%% STEREO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stereoModeOn = 0; %don't need this for goggles, only for the 2 screen setup
stereoMode = 4;        % 4 for split screen, 10 for two screens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% GOGGLES ON/OFF for debugging %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
togglegoggle = 1; % 0 goggles off for debug; 1 = goggles on for real expt
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get some hardware info %%%%%%%%%%%%%%%%%%%%%%%

devices = PsychHID('Devices');
keyboardind = GetKeyboardIndices();
mouseind = GetMouseIndices();

% define keyboards used by subject and experimenter
% run KbQueueDemo(deviceindex) to test various indices
if IsWin
    deviceindexSubject = [0]; %possibly MRI keypad
else
    deviceindexSubject = [9]; %possibly MRI keypad
end
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


block = 1;
stim = 1;


todaydate = date;


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
% screenNumber = 1;  % puts stimulus on external screen

white = WhiteIndex(screenNumber);  %value of white for display screen screenNumber
black = BlackIndex(screenNumber);  %value of white for display screen screenNumber
grey = GrayIndex(screenNumber);  %value of white for display screen screenNumber
% grey_bkg = grey*brightness/10
grey_bkg = black


% Open an on screen window and color it grey

if stereoModeOn
%     [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], [], [], stereoMode); % StereoMode 4 for side by side
    if IsWin
        screenNumber = 0;%on windows screen 0 is the whole extended screen across two monitors
    end
    
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], [], [], stereoMode); % StereoMode 4 for side by side
    leftScreenRect = windowRect;
    rightScreenRect = windowRect;
    if stereoMode == 10
%         Screen('OpenWindow', screenNumber-1, 128, [], [], [], stereoMode);
        Screen('OpenWindow', screenNumber, grey_bkg, [], [], [], stereoMode);
    end
else %just open one window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
end


% Set the blend function for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% % if ~IsWin || debugmode == 0
% % % % correct non-linearity from CLUT
% %     oldCLUT = Screen('LoadNormalizedGammaTable', screenNumber, clut);
% %     disp('CLUT loaded')
% % end

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

%% ---------------------------------------
% Set up Arduino for Goggles use
% ________________________________________

if togglegoggle == 1;
    [ard, comPort] = InitArduino;
    disp('Arduino Initiated')
    
    goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye) need both eyes to view everything up until the actual experiment trials (and for the BS measurement)
        
    % Remember to switch this off if the code stops for any reason. Any
    % Try/Catch routines should have LensOff integrated there...
else
    ard =[];
end


%% ---------------
%  Intro screen  |
%-----------------

if stereoModeOn
    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
end

% ShowFix()

instructions = 'Hello. Press any key';
DrawFormattedText(window, instructions, 'center', 'center', [1 1 1], [], []);

if stereoModeOn
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    
%     ShowFix()
    
    instructions = 'Hello and welcome \n \n to the experiment for perceptual filling-in \n \n Press any key to continue';
    DrawFormattedText(window, instructions, 'center', 'center', [1 1 1], [], []);
end

%flip to screen
vbl = Screen('Flip', window);
KbStrokeWait([-1]);



try
goggles(bs_eye, 'both',togglegoggle,ard) %(BS eye, viewing eye)

Screen('TextSize', window, 40);
if stereoModeOn
    Screen('SelectStereoDrawBuffer', window, 1);  %RIGHT
end
DrawFormattedText(window, 'Waiting for scanner trigger...', 'center', 'center', [1 1 1],[],[]);
if stereoModeOn
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    DrawFormattedText(window, 'Waiting for scanner trigger...', 'center', 'center', [1 1 1],[],[]);
end
Screen('Flip', window);
disp('Waiting for scanner trigger...')

[secs, keyCode, deltaSecs]=    KbStrokeWait([-1]);%get timestamp

while ~keyCode(scannertrigger)
    [keyIsDown, secs, keyCode] = KbCheck([-1]);% Check the keyboard to see if a button has been pressed
end
if stereoModeOn
    Screen('SelectStereoDrawBuffer', window, 0);  %LEFT
    DrawFormattedText(window, 'Trigger detected', 'center', 'center', [1 1 1],[],[]);
end
disp('Trigger detected')
DisableKeysForKbCheck(scannertrigger); % now disable the scanner trigger


timestart = secs; %time elapsed since trigger press
vbl= secs; %get trigger press for timing of block 1


% wait for scanner trigger


for i = 1:length(delays)

    currtime = GetSecs - timestart;
    disp(currtime)
   
    
    for a = 1:5 %do 5 repetitions
        Screen('FillRect', window, [1 0 0]); % make the whole screen red
        Screen('TextSize', window, 60);
        DrawFormattedText(window, sprintf('Goggles after screen. Delay: %f', delays(i)), 'center', 'center', [1 1 1],[],[]); %show what delay is
        %on right now
        disp(sprintf('Delay: %f', delays(i)))
        vbl = Screen('Flip', window, vbl + (waitframes - 0.2) * ifi); %flip red (just one frame, 16.6ms)
        currtime = GetSecs - timestart;
        disp(currtime)
        WaitSecs(delays(i)); %wait before ON goggles
        goggles(bs_eye,'both',togglegoggle,ard);
        Screen('FillRect', window, [0 1 0], [300 300 600 600]); % make the whole screen green
        vbl = Screen('Flip', window, vbl + (((switchfreq)/ifi) - 0.2) * ifi); %flip black on after Switch Freq = 2s
        currtime = GetSecs - timestart;
        disp(currtime)
        WaitSecs(delays(i)); %wait before OFF goggles
        goggles(bs_eye,'neither',togglegoggle,ard);
        Screen('FillRect', window, [1 0 0]); % make the whole screen red
        vbl = Screen('Flip', window, vbl + (((switchfreq-ifi)/ifi) - 0.2) * ifi); %turn green screen off after 2s
        currtime = GetSecs - timestart;
        disp(currtime)
    end

end


 % GOGGLES ON TIME 0
    goggles(bs_eye,'both',togglegoggle,ard); %goggles ON
    WaitSecs(delays(i));
    vbl = GetSecs;
for i = 1:length(delays)

    currtime = GetSecs - timestart;
    disp(currtime)
   
    
    
    for a = 1:5 %do 5 repetitions
        Screen('FillRect', window, [1 0 0]); % make the whole screen red
        Screen('TextSize', window, 60);
        DrawFormattedText(window, sprintf('Goggles before screen. Delay: %f', delays(i)), 'center', 'center', [1 1 1],[],[]); %show what delay is
        %on right now
        disp(sprintf('Delay: %f', delays(i)))
        
        % SCREEN ON TIME 0 + delay
        vbl = Screen('Flip', window, vbl + ((waitframes - 0.2) * ifi)); %flip red on for just one frame
        currtime = GetSecs - timestart;
        disp(currtime)
        
        Screen('FillRect', window, [0 1 0],[300 300 600 600]); % make the whole screen green

        % GOGGLES OFF TIME 2
        WaitSecs((((switchfreq-delays(i))/ifi) - 0.2) * ifi); %wait 2 seconds - delay (we already waited delay seconds with the screen flip).
        goggles(bs_eye,'neither',togglegoggle,ard); %goggles off
        % SCREEN ON TIME 2 + delay
        vbl = Screen('Flip', window, vbl + (((switchfreq-ifi)/ifi) - 0.2) * ifi); %flip on green screen after (2s) after red screen came on
        currtime = GetSecs - timestart;
        disp(currtime)   
        
        Screen('FillRect', window, [1 0 0]); % make the whole screen red
        % GOGGLES ON TIME 4
        WaitSecs((((switchfreq-delays(i))/ifi) - 0.2) * ifi); %wait 2 seconds - delay
        goggles(bs_eye,'both',togglegoggle,ard); %goggles ON again
        % SCREEN ON TIME 4 + delay
        vbl = Screen('Flip', window, vbl + (((switchfreq)/ifi) - 0.2) * ifi); %turn green screen off after 2s after last screen change
        currtime = GetSecs - timestart;
        disp(currtime)
    end

end

catch
if togglegoggle
    goggles(bs_eye,'neither',togglegoggle,ard);
    ShutdownArd(ard,comPort)
end
sca    
    
end
if togglegoggle
    goggles(bs_eye,'neither',togglegoggle,ard);
    ShutdownArd(ard,comPort)
end
sca

