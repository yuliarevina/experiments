[ard, comPort] = InitArduino;
disp('Arduino Initiated')

pause(2)

try
    ToggleArd(ard,'LensOn')
    pause(2)
    ToggleArd(ard,'AllOff')
    pause(2)
    ToggleArd(ard,'RightOn')
    pause(2)
    ToggleArd(ard,'RightOff')
    pause(2)
    ToggleArd(ard,'LeftOn')
    pause(2)
    ToggleArd(ard,'LeftOff')
    pause(2)
    ToggleArd(ard,'AllOff')

catch
ShutdownArd(ard,comPort);
disp('Arduino is off')
end

ShutdownArd(ard,comPort);
disp('Arduino is off')