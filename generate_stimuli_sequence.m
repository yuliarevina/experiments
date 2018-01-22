% generate sequences of stimuli for each subject

% Run this once for each subject and keep the mat file safe. It is read in
% by the experiment script at the start

% Yulia Revina, NTU, Singapore

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enter the subject number you wish to generate sequence for
subnum = 10; %subject number??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nRuns = 6;
nSeqs = 5;
nStimsInSeq = 6;

% %shortened version for debug
% nRuns = 2;
% nSeqs = 2;
% nStimsInSeq = 6;

rng('shuffle')

allperms = perms([1:6]);

runseq = nan(nSeqs,nStimsInSeq,nRuns);

totalnSeqs= nSeqs*nRuns; %5 seqs x 8 runs

% a = 1;
% b = 120;
% r = round((b-a).*rand(numberofseqs,1) + a); % generate random n's from 1 to 120 with repetition
r = randperm(size(allperms,1),totalnSeqs); %generate 40 unique numbers from 1 to 120

% generate unique sequences for all runs
allseqs = allperms(r,:);

counter = 1;
for run = 1:nRuns
    runseq(:,:,run) = allseqs(counter:counter+nSeqs-1,:); %e.g 1:6, 7:11
    counter = counter+nSeqs;
end

save(sprintf('sub%s_MRI_stim_seq.mat', num2str(subnum)), 'nRuns', 'nSeqs', 'nStimsInSeq', 'allperms', 'runseq', 'totalnSeqs', 'r', 'allseqs')