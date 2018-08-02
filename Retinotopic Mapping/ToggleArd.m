function ToggleArd(arduinoname,varargin)
%Call this function using ToggleArd(arduinoname,'COMMAND');
%Please ensure that you ran InitArduino before running this function.
%Otherwise we don't know what object 'ard' is 
%Here are the COMMANDS to call to arduino:
%AirOn, AirOff
%LeftOn, LeftOff, RightOn, RightOff, LensOff
%AllOff

%Variables for signals
AirOff = 'a'; AirOn = 'b'; LeftOn = 'l'; LeftOff = 'm'; RightOn = 'r'; RightOff = 's'; LensOff = 'z'; LensOn = 'c'; AllOff = 'x';

%Each input is stored in the column
if size(varargin,2) < 1 %If no command specified, error
    error('No command specified. Aborting');
elseif size(varargin,2) >= 2 %If user provides more than 2 inputs each time this function is called, error.
    error('More than 1 command specified. Aborting');
end

%We compare with the input with the strings, case-insensitive.
if strcmpi(varargin{1},'AirOn') == 1
    fprintf(arduinoname,'%c',AirOn);
elseif strcmpi(varargin{1},'AirOff') == 1
    fprintf(arduinoname,'%c',AirOff);
elseif strcmpi(varargin{1},'LeftOn') == 1
    fprintf(arduinoname,'%c',LeftOn);
elseif strcmpi(varargin{1},'LeftOff') == 1
    fprintf(arduinoname,'%c',LeftOff);
elseif strcmpi(varargin{1},'RightOn') == 1
    fprintf(arduinoname,'%c',RightOn);
elseif strcmpi(varargin{1},'RightOff') == 1
    fprintf(arduinoname,'%c',RightOff);
elseif strcmpi(varargin{1},'LensOn') == 1
    fprintf(arduinoname,'%c',LensOn);
elseif strcmpi(varargin{1},'LensOff') == 1
    fprintf(arduinoname,'%c',LensOff);
elseif strcmpi(varargin{1},'AllOff') == 1
    fprintf(arduinoname,'%c',AllOff);
else
    error('Unknown command. Typo perhaps?'); %If there is a typo because no other strings matched, error.
end

end