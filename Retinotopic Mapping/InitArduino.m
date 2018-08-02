function [ard, comPort] = InitArduino(comPort,BaudRate)
%Specify the comPort by InitArduino('comPort')
%Make sure to output arduino handle and the comPort for the other functions
%Specify Baudrate as an integer/value -- InitArduino('comPort',1000)
%If you leave comPort blank, we'll take the default ports listed below.
try
    %% Initialize Arduino
    if nargin < 1
        if IsWin == 1
            comPort = 'COM3'; BaudRate = 9600;
        elseif ismac == 1
            comPort = '/dev/ttyS32'; BaudRate = 9600;
        else %Linux
            
            %Linux is much more complicated. We first need to make sure that
            %the USB for Arduino is detected. This is /dev/ttyACM0 in
            %stations1-3
            [status, cmdout] = system('ls /dev/tty*');
            %Check to see if directory exist
            CheckDir = strfind(cmdout,'/dev/ttyACM0');
            if isempty(CheckDir) == 1 %Cannot find USB
                error('Is USB connected? Please check using ls /dev/tty*. Arduino should show up as /dev/ttyACM0. If not, unplug and plug in again.')
            else %Found Arduino USB
                %We need to create symbolic link using Sudo. Please enter station password for SUDO
                fprintf('Establishing symbolic link with Arduino.\n')
                CheckSerialDir = strfind(cmdout,'/dev/ttyS60');
                if isempty(CheckSerialDir) == 1 %Not such serial port, so we can use it
                    system('sudo -k ln /dev/ttyACM0 /dev/ttyS60');
                else %We found a similar port. Let's remove it then restablish the link
                    fprintf('Serial port S60 found. Removing it so we can restablish connection with Arduino.\n');
                    fclose(ard); %closing ard in case it wasn't closed properly
                    system('sudo rm /dev/ttyS60');
                    fprintf('\nEstablishing symbolic link with Arduino.\n');
                    system('sudo -k ln /dev/ttyACM0 /dev/ttyS60');
                end
                
                %Now we can open the serial port with arduino
                comPort = '/dev/ttyS60'; BaudRate = 9600;
            end
        end
    end
    
    %Open port
    ard = serial(comPort,'BaudRate',BaudRate); %Create serial communication object
    fopen(ard); %Open arduino object
    
    %Warning message
    fprintf('\nPlease ensure that your pins are connected properly \n and that power is turned on.\n\n');
    
catch ERR
    system('sudo rm /dev/ttyS60'); rethrow(ERR);
    
end

end