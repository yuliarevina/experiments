function ShutdownArd(arduinoname,comPort)
%this function basically shuts down the arduino
%Usage: ShutdownArd(arduinoname,comPort)

ToggleArd(arduinoname,'AllOff'); %Send signal to shut down everything on Arduino
fclose(arduinoname); %Close serial link between MATLAB and Arduino

if strcmpi(comPort,'/dev/ttyS60') == 1 %If linux was used
    %We will remove the symbolic link
    fprintf('Shutting down on Linux. \nRemoving Symbolic link.');
    system('sudo rm /dev/ttyS60');
end


end