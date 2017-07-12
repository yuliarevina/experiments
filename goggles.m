% function to toggle goggles
% needs blindspot eye and viewing eye (eye which is currently viewing the stimulus)

% bs_eye = 'right' or 'left'
% viewing_eye = 'BS', 'fellow', 'both', 'neither'

% BS = blind spot eye
% fellow = non blindspot eye
% both = stimulus viewing binoculalry
% neither = goggles closed completely

% Yulia Revina, NTU, Singapore, 2017


function goggles(bs_eye, viewing_eye)
try    
    if togglegoggle == 1;
        if strcmp(bs_eye,'right')
            if strcmp(viewing_eye,'BS')
                %left off
                ToggleArd(ard,'LeftOff') % close left eye so we can look with our right and measure BS
            elseif strcmp (viewing_eye, 'fellow')
                % Right off
                ToggleArd(ard,'RightOff')
            elseif strcmp(viewing_eye, 'both')
                % Lens On
                ToggleArd(ard,'LensOn')
            elseif strcmp(viewing_eye, 'neither')
                % All off
                ToggleArd(ard,'AllOff')
            else %error
                %please define which eye is looking
                disp('eye viewing is undefined!')
            end
        elseif strcmp(bs_eye,'left')
            if strcmp(viewing_eye,'BS')
                % right off
                ToggleArd(ard,'RightOff')
            elseif strcmp (viewing_eye, 'fellow')
                % left off
                ToggleArd(ard,'LeftOff')
            elseif strcmp(viewing_eye, 'both')
                % lens on
                ToggleArd(ard,'LensOn')
            elseif strcmp(viewing_eye, 'neither')
                %all off
                ToggleArd(ard,'AllOff')
            else %error
                %please define which eye is looking
                disp('eye viewing is undefined!')
            end
        else %error
            %please define which eye is the BS eye
            disp('blind spot eye is undefined!')
        end
       
    end

catch errGoggles
    rethrow(errGoggles)
end
end