% dir = 'C:\';
dateofstudy = '30-Jan-2018';
subject = '1';
nConditions = 5;
fname=sprintf('%s_Localizer_sequences.txt', dateofstudy);
data=load(fname);  % condition sequence in main stream of images
data=data';
vols=zeros(65,3);
k=1; l=6;  % start vol and end vol (TR2) for first trial in stream
z = 1;
for i=1:32  %% 32 pairs of fix+stim
    
     % first fixation in block (12s)
        vols(z,1)=k;
        vols(z,2)=l;
        vols(z,3)=0;  %% code fixation
        z=z+1;
        
        % control increment
        k=k+6; l=l+6;
        
        vols(z,1)=k;
        vols(z,2)=l;
        vols(z,3)=data(i);  %% code stim
        z=z+1;
        
        % control increment
        k=k+6; l=l+6;
end

%last extra fix
vols(z,1)=k;
vols(z,2)=l;
vols(z,3)=0;  %% code fixation


condition_names={'Fix','1. Target both eyes','2. Target BS eye','3. Target Fellow Eye','4. Surround both eyes'};

color(1,:)=[128 128 128];
color(2,:)=[75 255 165];
color(3,:)=[40 150 255];
color(4,:)=[118 84 107];
color(5,:)=[122 107 79];
% color(6,:)=[58 58 68];
% color(7,:)=[72 130 72];
% color(8,:)=[20 50 150];
% color(9,:)=[40 84 128];
% color(10,:)=[0 0 255];
% color(11,:)=[255 0 0];
% color(12,:)= [0 255 0];

outname=sprintf('%s_%s_Localizer.prt', dateofstudy, subject);
fid=fopen(outname,'w');

fprintf(fid, 'FileVersion:\t2\n\n\n');
fprintf(fid, 'ResolutionOfTime:\tVolumes\n\nExperiment:\tBS_Localizer\n\nBackgroundColor:\t0\t0\t0\n');
fprintf(fid, 'TextColor:\t255\t255\t255\nTimeCourseColor:\t255\t255\t255\nTimeCourseThick:\t3\nReferenceFuncColor:\t0\t0\t80\nReferenceFuncThick:\t3\n');
fprintf(fid, '\nNrOfConditions:\t%d\n\n', nConditions);


% fixation trials, group together
fprintf(fid,'%s\n', char(condition_names{1}));
fprintf(fid,'%d\n', 33);   %%% 12 fixation blocks (6 in mapping blocks)

locs=find(vols(:,3)==0); %% fixation trials


for i=1:length(locs)  % blocks in between
    if i == 1;
        fprintf(fid,'%d\t%d\n', (i), ((vols(locs(i),2))));
    elseif fprintf(fid,'%d\t%d\n', (vols(locs(i),1)), (vols(locs(i),2))); %Brainvoyager minus 2 vols
    end
end

fprintf(fid,'Color:\t%d\t%d\t%d\n\n', 128 , 128, 128);


for ss = 2:5
    % Stim 1 trials, group together
    fprintf(fid,'%s\n', char(condition_names{ss}));
    fprintf(fid,'%d\n', 8);   %%% 12 fixation blocks (6 in mapping blocks)
    
    locs=find(vols(:,3)==ss-1); %% stim trials
    
    
    for i=1:length(locs)  % blocks in between
        
         fprintf(fid,'%d\t%d\n', (vols(locs(i),1)), (vols(locs(i),2))); %Brainvoyager minus 2 vols
        
    end
    % condition color code
    fprintf(fid,'Color:\t%d\t%d\t%d\n\n', color(ss,1), color(ss,2), color(ss,3));
end