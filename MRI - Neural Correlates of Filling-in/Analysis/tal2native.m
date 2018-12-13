% Function to convert TAL coordinates (e.g. from a VOI file) to native
% coordinates index used by NeuroElf

% Requires:
% 1] Tal coordinates in X, Y, Z format (these can be from VOI, same as system
% coords in BV 3D Vol Tools box, but not same as BV internal coordinate
% system it uses when you save the file and read it in NeuroElf.
% 2] Voxel resolution:  1 = 1mm vox
%                       2 = 2mm vox
%                       3 = 3mm (standard in most datasets, seems to be
%                       the default when creating a VTC regardless of whether
%                       you scanned as 2x2x2mm or whatever)

% EXAMPLE
% For 3 x 3 x 3 mm voxel resolution of VMP file

% TAL [128 to -128] .* [X, Y, Z]
% VMP(TAL Y, TAL Z, TAL X)
% VMR BV  X = 58
%         Y = 40
%         Z = 46
%
% VMR TAL X = 46
%         Y = 58
%         Z = 40
%
% NeuroElf index [58(x) x 40(y) x 46(z)] = [TAL Y, TAL Z, TAL X]
% Therefore we need to convert TAL X,Y,Z to [46 x 58 x 40]
% TAL X = NEUROELF Z
% TAL Y = NEUROELF X
% TAL Z = NEUROELF Y

% E.g. TAL X = 0, NEUROELF = index 23/46 = VMP[:,:,23]
% E.g. TAL X = 69, NEUROELF = index 1/46 = VMP[:,:,1]
% E.g. TAL X = -69, NEUROELF = index 46/46 = VMP[:,:,46]
% 
% E.g. TAL Y = 0, NEUROELF = index 24/58 = VMP[24,:,:]
% E.g. TAL Y = 71, NEUROELF = index 1/58 = VMP[1,:,:]
% E.g. TAL Y = -103, NEUROELF = index 58/58 = VMP[58,:,:]
%
% E.g. TAL Z = 0, NEUROELF = index 26/40 = VMP[:,26,:]
% E.g. TAL Z = 76, NEUROELF = index 1/40 = VMP[:,1,:]
% E.g. TAL Z = -44, NEUROELF = index 40/40 = VMP[:,40,:]
%
%
%
%
%
% Written by Yulia Revina, NTU, Singapore. 2018.



function [xIdx yIdx zIdx] = tal2native(xtal, ytal, ztal, voxSize)

% X coords bounding box goes from 59 to 197 in native coords
%                           from 69 to -69 in TAL coords
%                               from 1 to 46 in NeuroElf index

% Y coords bounding box goes from 
%
%

% Z coords bounding box goes from
%
%

%formula is basically (yourTalCoord - startTalCoord - 1)/(-resolution)
% -3 is needed to shift things slightly, cos basically Tal 69 is not saved
% in the file, BV just says this is X start, but really it starts from 60
% (BV) or 68 (TAL). Neuroelf index 0, if such were to exist. Check this
% later though, in case 197 is the one that's cut off instead???! So
% confusing!!

neuroElfIdx_TalX = round((xtal - 69 -1)/(-voxSize)); %calculate the equivalent neuroElf index for specific tal coord

neuroElfIdx_TalY = round((ytal - 71 -1)/(-voxSize));

neuroElfIdx_TalZ = round((ztal - 76 -1)/(-voxSize));


%convert to [X,Y,Z] format to plug into VMP dataset. Remember, this is
%equivalent to Y,Z,X in Tal, so we swap things around here into the order
%neuroElf will prefer. I just call it X,Y,Z here, but it is not the same as
%TAL X,Y,Z.
xIdx = neuroElfIdx_TalY;
yIdx = neuroElfIdx_TalZ;
zIdx = neuroElfIdx_TalX;


end