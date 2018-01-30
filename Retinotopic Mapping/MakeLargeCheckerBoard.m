%alternative based on same multiplier

resolution = 1910*2;
img = zeros(resolution,resolution);
nring= 60;

thetawedge = 24; %in deg


smallestwidth = 1; %px
widthmultiplier = 1.17;
% widthmultiplier = 1.13;
% nring= 37; %good for 1.17 width mult
widths = ones(1,nring);
widths(1) = smallestwidth;
for w = 2:nring
    widths(w) = widths(w-1)*widthmultiplier;
end
mysize = resolution/2;

steps = 36000;
theta = (linspace(0,2*pi,steps))';



%generate color vector
colors = ones(1,round(sum(widths)));
colors(1:smallestwidth) = 0;
flip = 1;
pastwidth = 0;
end_point = smallestwidth;
for c = 2:length(widths) %for every width
    if flip == 0  %balck
        curr_width = round(widths(c));
        end_point = end_point +pastwidth;
        colors(end_point:end_point+curr_width) = 0;
        pastwidth = curr_width;
    else
        curr_width = round(widths(c));
        end_point = end_point +pastwidth;
        colors(end_point:end_point+curr_width) = 1;
        pastwidth = curr_width;
    end
    flip = 1 - flip;
end


%generate a logical theta vector. For the black and white alternating
%wedges
thetalogical = ones(1,steps);
flip = 0;

for l = 1:length(thetalogical)
    if flip == 0
        thetalogical(l) = 0;
    end
    if mod(l,6*(steps/360)) == 0
        flip = 1 - flip;
    end
end

thetalogical = logical(thetalogical);


%generate the coordinate space
[x, y] = meshgrid(theta(thetalogical), 1:mysize);
[X,Y] = pol2cart(x,y);

X = (X + mysize+ 1); %+1 to get rid of zero values
Y = (Y + mysize+1);

% fill the coordinates with the right colors
myimage = [];
for i = 1:size(X,1) %row
    for j =1:size(X,2) %column
       myimage(round(X(i,j)),round(Y(i,j))) = colors(i);
    end
end

%do the other colors now
thetalogical = logical(1 - thetalogical);

[x, y] = meshgrid(theta(thetalogical), 1:mysize);
[X,Y] = pol2cart(x,y);

X = (X + mysize+ 1); %+1 to get rid of zero values
Y = (Y + mysize+1);

for i = 1:size(X,1) %row
    for j =1:size(X,2) %column
       myimage(round(X(i,j)),round(Y(i,j))) = 1-colors(i);
    end
end

%if making a wedge, need to fill the rest of the space as gray
%wedge starts at 72 degrees
if thetawedge ~= 360
    thetalogical = logical(ones(1,steps));
    thetalogical(72*(steps/360):72*(steps/360)+thetawedge*(steps/360)) = 0;
    [x, y] = meshgrid(theta(thetalogical), 1:mysize);
    [X,Y] = pol2cart(x,y);
    
    X = (X + mysize+ 1); %+1 to get rid of zero values
    Y = (Y + mysize+1);
    
    for i = 1:size(X,1) %row
        for j =1:size(X,2) %column
            myimage(round(X(i,j)),round(Y(i,j))) = 0.5;
        end
    end
end

xylim = resolution+1;
[x, y] = meshgrid(-xylim: 2 * xylim / (resolution+1 - 1): xylim,...
    -xylim: 2 * xylim / (resolution+1 - 1): xylim);
circle = x.^2 + y.^2 <= (resolution+1)^2;
figure; imagesc(circle);
myimage(~circle) = 0.5;


figure; imagesc(myimage); colormap gray; axis square; axis off
set(gca,'pos', [0 0 1 1]);
set(gcf, 'Position', [10 10, resolution resolution]);

checksinv = 1 - myimage;
% imwrite(myimage, 'MyCheckerboard.png', 'png', 'Transparency', 0.5)
% imwrite(checksinv, 'MyCheckerboard_inv.png', 'png', 'Transparency', 0.5)
imwrite(myimage, 'MyCheckerboard.png', 'png')
imwrite(checksinv, 'MyCheckerboard_inv.png', 'png')


%% Eccentricity

thetawedge = 360; %in deg. We want a full ring here


%generate color vector
% we need grey for every width except the last one (so we can make a large
% ring
% the "last one" depends on the resolution. So if we need 1910 resolution
% we need the width that comes up to that

for c = 1:length(widths)
    edge(c) = sum(widths(1:c));
end
lastwidth = find(edge<mysize);
lastwidth = max(lastwidth); 

colors = ones(1,round(sum(widths)))*0.5; %make the default color grey
colors(1:smallestwidth) = 0; %make the first width black
flip = 1;
pastwidth = 0;
end_point = smallestwidth;
for c = 2:lastwidth-2 %for every width except last 2
        curr_width = round(widths(c));
        end_point = end_point +pastwidth;
        colors(end_point:end_point+curr_width) = 0.5;
        pastwidth = curr_width;
end
for c = (lastwidth-1):lastwidth %do the very last one. Just make it black
    if c == lastwidth-1
        curr_width = round(widths(c));
        end_point = end_point +pastwidth;
        colors(end_point:end_point+curr_width) = 0;
        pastwidth = curr_width;
    else
        curr_width = round(widths(c));
        end_point = end_point +pastwidth;
        colors(end_point:end_point+curr_width) = 1;
        pastwidth = curr_width;
    end
end


%generate a logical theta vector. For the black and white alternating
%wedges
thetalogical = ones(1,steps);
flip = 0;

for l = 1:length(thetalogical)
    if flip == 0
        thetalogical(l) = 0;
    end
    if mod(l,6*(steps/360)) == 0
        flip = 1 - flip;
    end
end

thetalogical = logical(thetalogical);


%generate the coordinate space
[x, y] = meshgrid(theta(thetalogical), 1:mysize);
[X,Y] = pol2cart(x,y);

X = (X + mysize+ 1); %+1 to get rid of zero values
Y = (Y + mysize+1);

% fill the coordinates with the right colors
myimage = [];
for i = 1:size(X,1) %row
    for j =1:size(X,2) %column
       myimage(round(X(i,j)),round(Y(i,j))) = colors(i);
    end
end

%do the other colors now
thetalogical = logical(1 - thetalogical);

[x, y] = meshgrid(theta(thetalogical), 1:mysize);
[X,Y] = pol2cart(x,y);

X = (X + mysize+ 1); %+1 to get rid of zero values
Y = (Y + mysize+1);

for i = 1:size(X,1) %row
    for j =1:size(X,2) %column
       myimage(round(X(i,j)),round(Y(i,j))) = 1-colors(i);
    end
end

%if making a wedge, need to fill the rest of the space as gray
%wedge starts at 72 degrees
if thetawedge ~= 360
    thetalogical = logical(ones(1,steps));
    thetalogical(72*(steps/360):72*(steps/360)+thetawedge*(steps/360)) = 0;
    [x, y] = meshgrid(theta(thetalogical), 1:mysize);
    [X,Y] = pol2cart(x,y);
    
    X = (X + mysize+ 1); %+1 to get rid of zero values
    Y = (Y + mysize+1);
    
    for i = 1:size(X,1) %row
        for j =1:size(X,2) %column
            myimage(round(X(i,j)),round(Y(i,j))) = 0.5;
        end
    end
end

sum(widths(1:lastwidth));
xylim = resolution+1;
% xylim = sum(widths(1:lastwidth-1)); %going to be a bit smaller because widths are not exact multiples of resolution
[x, y] = meshgrid(-xylim: 2 * xylim / (resolution+1 - 1): xylim,...
    -xylim: 2 * xylim / (resolution+1 - 1): xylim);
circle = x.^2 + y.^2 <= (((sum(widths(1:lastwidth)))+1)*2)^2;
figure; imagesc(circle);
myimage(~circle) = 0.5;


figure; imagesc(myimage); colormap gray; axis square; axis off
set(gca,'pos', [0 0 1 1]);
set(gcf, 'Position', [10 10, resolution resolution]);

checksinv = 1 - myimage;
% imwrite(myimage, 'MyCheckerboard.png', 'png', 'Transparency', 0.5)
% imwrite(checksinv, 'MyCheckerboard_inv.png', 'png', 'Transparency', 0.5)
imwrite(myimage, 'MyCheckerboard_ecc.png', 'png')
imwrite(checksinv, 'MyCheckerboard_ecc_inv.png', 'png')


%%
%{
%generate textures
% Number of white/black circle pairs
rcycles = 15;

% Number of white/black angular segment pairs (integer)
tcycles = 30;

sizecircle = 1920; %max size of the mapping in px

% Now we make our checkerboard pattern
% code from Peter Scarfe tutorial
xylim = 2 * pi * rcycles;
[x, y] = meshgrid(-xylim: 2 * xylim / (sizecircle - 1): xylim,...
    -xylim: 2 * xylim / (sizecircle - 1): xylim);
at = atan2(y, x);
checks = ((1 + sign(sin(at * tcycles) + eps)...
    .* sign(sin(sqrt(x.^2 + y.^2)))) / 2) * (white - black) + black;
circle = x.^2 + y.^2 <= xylim^2;
checks = circle .* checks + grey * ~circle;

% Now we make this into a PTB texture
radialCheckerboardTexture  = Screen('MakeTexture', window, checks);

% Draw our texture to the screen
Screen('DrawTexture', window, radialCheckerboardTexture);

% Flip to the screen
Screen('Flip', window);

% Wait for a keypress
KbStrokeWait;



% %alternative
f = 200; %// Hz
f_c = 1; %// Hz
T = 1 / f; %// Sampling period from f

t = 0 : T : 5; %// Determine time values from 0 to 5 in steps of the sampling period
% t = fliplr(t);

A = 3*t; %// Define message
A = (pi/2).^t; %// Define message
% A = fliplr(t);

%// Define FM signal
out = sin(2*pi*(f_c + A).*t);
out = fliplr(out);

%%%%%%%%%%%%%%%%%


%alternative from $author Shripad Kondra, NBRC, India (28-09-2010) Matlab
%file exchange: circular checkerboard reversal pattern

sigma=14;
spokes=16;

SUP=500; % This parameter controls the resolution
hsup=(SUP-1)/2;
[x,y]=meshgrid([-hsup:hsup]);
[THETA,r] = cart2pol(x,y);
r=(r./(SUP/2))*pi;
% r(r<0.04)=0; % uncomment to put a dot at the centre.
% r(r>(pi+0.01))=inf; % uncomment if you want to get exact circle



multiplier = (f_c + A).*t;
f=sin(r*sigma);         % 1st concentric filter
% f = sin(r.*multiplier(1:500));
f1=sin(THETA*spokes);   % 1st radial filter
f1=f1>=0;               % binarize
f11=f.*f1;              % point-wise multiply
% f=sin(r*sigma+pi);      % 2nd concentric filter shifted by pi
% f1=sin(THETA*spokes+pi);% 2nd radial filter shifted by pi
% f1=f1>=0;               % binarize
% f12 = f.*f1;            % point-wise multiply
% f=(f11+f12)>=0;         % add the two filters and threshold
% f_inv=(f11+f12)<=0;     % add the two filters and threshold
f = f11>=0;
figure, imagesc((f)), colormap gray;



test = [0:0.01*pi:16*pi];
testsin = sin(test); %sine wave
t = 1:1:length(test);
testsintime = sin(test.*t);
testnewsin = (testsintime+1)/2; %from 0 to 1
% testnewsin = (testsin+1)/2 %from 0 to 1

%}
%% sam's code

%{
img = zeros(1910,1910);
smallestwidth = 1; %px
widthmultiplier = 1.17;
nring= 52;
widths = ones(1,nring);
widths(1) = smallestwidth;
for w = 2:nring
    widths(w) = widths(w-1)*widthmultiplier;
end
% widths = [50,100,200,400];
theta = 12;
t = 0;
flip = 1;
test = 0;
sample = 1./((2*pi*(1:1000))*(theta/45));
try
for i = 1:size(widths,2)
    
    for j = 1:widths(i)
        
        for k = 1:theta:360
            if flip ==1
                for z = 1:sample(i):theta/2
                    test(end+1) = k+z;
                    [x,y] = pol2cart(deg2rad(k+z),j+t);
                    img(size(img,1)/2+round(x),size(img,1)/2+round(y)) = 1;
                end
            else
                for z = theta/2:sample(i):theta
                    test(end+1) = k+z;
                    [x,y] = pol2cart(deg2rad(k+z),j+t);
                    img(size(img,1)/2+round(x),size(img,1)/2+round(y)) = 1;
                end
            end
        end
    end
    flip = flip *-1;

    t = t+widths(i);
end
catch
    i
    j
    k    
end
figure; imagesc(img); colormap gray; axis square; axis off
set(gca,'pos', [0 0 1 1]);
% set(gcf, 'Position', [10 10 768 768]);
set(gcf, 'Position', [10 10, 1910 1910]);
%}

%%
% % %alternative based on Freq modulation
% % f = 1910/2; %// Hz
% % f_c = 1; %// Hz
% % T = 1 / f; %// Sampling period from f
% % 
% % t = 0 : T :1; %// Determine time values from 0 to 5 in steps of the sampling period
% % % t = fliplr(t);
% % 
% % A = t; %// Define message
% % A = (pi/2).*t; %// Define message
% % A = (4*pi).^t; %// Define message
% % % A = 0;
% % % A = fliplr(t);
% % 
% % %// Define FM signal
% % out = sin(2*pi*(f_c + A).*t);
% % out = fliplr(out);
% % out = (out+1)/2;
% % 
% % %// Plot modulated signal
% % figure;
% % plot(t, out, 'b');
% % grid;
% % 
% % %
% % outtruncate = out(1:length(out));
% % outruncateround = round(outtruncate);
% % out2 = repmat(out,100,1);
% % 
