% dir = 'C:\';
dateofstudy = '30-Jan-2018';
subject = '1';
nConditions = 7;
fname=sprintf('sub%s_MRI_stim_seq.mat',subject);
data=load(fname,'runseq');  % condition sequence in main stream of images. Loads into a structure. Data.runseq
% data=reshape(data.runseq, [1, 30, 6]);
% vols=zeros(61,3);
% k=1; l=3;  % start vol and end vol (TR2) for first trial in stream
% z = 1;
for run = 1:size(runseq,3)
    z = 1;
    vols=zeros(61,3);
    k=1; l=3;  % start vol and end vol (TR2) for first trial in stream
    datarun = data.runseq(:,:,run);
    datarun = reshape(datarun', [30,1]);
    for i=1:30  %% 30 pairs of fix+stim
        
        % first fixation in block (12s)
        vols(z,1)=k;
        vols(z,2)=l;
        vols(z,3)=0;  %% code fixation
        z=z+1;
        
        % control increment
        k=k+3; l=l+6; %3 TRs = 6s fix
        
        vols(z,1)=k;
        vols(z,2)=l;
        vols(z,3)=datarun(i);  %% code stim
        z=z+1;
        
        % control increment
        k=k+6; l=l+3; %6 TRs = 12s
    end
    
    %last extra fix
    vols(z,1)=k;
    vols(z,2)=l;
    vols(z,3)=0;  %% code fixation
    
    
    condition_names={'Fix','1. Intact','2. Blind spot','3. Occluded','4. Deleted Sharp', '5. Deleted Fuzzy', '6. Black Fix'};
    
    color(1,:)=[128 128 128];
    color(2,:)=[75 255 165];
    color(3,:)=[40 150 255];
    color(4,:)=[118 84 107];
    color(5,:)=[122 107 79];
    color(6,:)=[58 58 68];
    color(7,:)=[72 130 72];
    % color(8,:)=[20 50 150];
    % color(9,:)=[40 84 128];
    % color(10,:)=[0 0 255];
    % color(11,:)=[255 0 0];
    % color(12,:)= [0 255 0];
    
    outname=sprintf('Run%d_sub%s_MainExpt.prt', run, subject);
    fid=fopen(outname,'w');
    
    fprintf(fid, 'FileVersion:\t2\n\n\n');
    fprintf(fid, 'ResolutionOfTime:\tVolumes\n\nExperiment:\tPerceptualFillingIn\n\nBackgroundColor:\t0\t0\t0\n');
    fprintf(fid, 'TextColor:\t255\t255\t255\nTimeCourseColor:\t255\t255\t255\nTimeCourseThick:\t3\nReferenceFuncColor:\t0\t0\t80\nReferenceFuncThick:\t3\n');
    fprintf(fid, '\nNrOfConditions:\t%d\n\n', nConditions);
    
    
    % fixation trials, group together
    fprintf(fid,'%s\n', char(condition_names{1}));
    fprintf(fid,'%d\n', 31);   %%% 12 fixation blocks (6 in mapping blocks)
    
    locs=find(vols(:,3)==0); %% fixation trials
    
    
    for i=1:length(locs)  % blocks in between
        if i == 1;
            fprintf(fid,'%d\t%d\n', (i), ((vols(locs(i),2))));
        elseif fprintf(fid,'%d\t%d\n', (vols(locs(i),1)), (vols(locs(i),2))); %Brainvoyager minus 2 vols
        end
    end
    
    fprintf(fid,'Color:\t%d\t%d\t%d\n\n', 128 , 128, 128);
    
    
    for ss = 2:7
        % Stim 1 trials, group together
        fprintf(fid,'%s\n', char(condition_names{ss}));
        fprintf(fid,'%d\n', 5);   %%% 12 fixation blocks (6 in mapping blocks)
        
        locs=find(vols(:,3)==ss-1); %% stim trials
        
        
        for i=1:length(locs)  % blocks in between
            
            fprintf(fid,'%d\t%d\n', (vols(locs(i),1)), (vols(locs(i),2))); %Brainvoyager minus 2 vols
            
        end
        % condition color code
        fprintf(fid,'Color:\t%d\t%d\t%d\n\n', color(ss,1), color(ss,2), color(ss,3));
    end
end %run