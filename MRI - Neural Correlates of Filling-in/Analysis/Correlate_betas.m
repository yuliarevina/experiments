% Analysis of Neural Correlates of Perceptual Filling In
% Correlation of betas from different conditions of stimulus in a specific
% VOI

% Need VMP files with betas for each condition (create in BV)
% Need VOI file with region of interest (create in BV using localizer)

% Written by Yulia Revina, NTU, Singapore
% September 2018

% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------

sub_no = '06'; %subject code
nRuns = 6; %how many runs for this particular subject?
dir = 'C:/Users/HSS/Documents/GitHub/experiments/MRI - Neural Correlates of Filling-in/Analysis';
subject_dir = [dir, '/SUB' sub_no]; %specific path for the current subject
fix_cond = 1; %1 = baseline is black fixation, grey fixation is treated as a stimulus
        % 2 = baseline = grey fixation; black fixation is treated as a
        % stimulus
        
% load voi
[VOI_BS] = BVQXfile([subject_dir,'/Actual_Stim_conservative.voi']);

%filename structures
% 2 x 2 blk fix as baseline
% Block_N_intact_blkbkg_as_fix_VMP_2x2.vmp
% Block_N_BS_blkbkg_as_fix_VMP_2x2.vmp
% Block_N_blkbkg_as_fix_occluded_VMP_2x2.vmp
% Block_N_delSh_blkbkg_as_fix_VMP_2x2.vmp
% Block_N_delFuzz_blkbkg_as_fix_VMP_2x2.vmp
% Block_N_GreyFix_blkbkg_as_fix_VMP_2x2.vmp
%
% 2 x 2 grey fix as baseline
% Block_N_intact_VMP_2x2.vmp
% Block_N_BS_VMP_2x2.vmp
% Block_N_occluded_VMP_2x2.vmp
% Block_N_delSh_VMP_2x2.vmp
% Block_N_delFuzz_VMP_2x2.vmp
% Block_N_BlkFix_VMP_2x2.vmp


% How to extract VMPs with NeuroElf - general syntax
% list = vmp.VoxelStats(1,voi.VOI(voinr).Voxels,‘Tal’)

% Create vars for each condition
% There are 5-6 blocks of scans (depending on technical issues during data
% collection
% There are also two VMP maps for each condition: 1 created using grey
% screen as baseline and another using black screen as baseline.

Intact_betas = [];
BS_betas = [];
Occluded_betas = [];
DeletedSharp_betas = [];
DeletedFuzzy_betas = [];
Fixation_betas = [];

% Intact_betas = [0.1   0.23    0.45    11  0.3]
%                [0.5   0.87    1.4     8   1.8]
%                [...   ...     ...     ..   ..]
% Each column is one run, each row is one beta for as many voxels as
% necessary. Can do [:,:,1] as GreyFix prt; and [:,:,2] as BlkFix prt.


%Betas structure
% columns 1-6 = blocks 1-6
% col 7 = average of 6 blocks GLM
% cols 8-17 = first group of averged GLMs of 3 blocks, eg 123, 124, 125
% cols 18-27 = second group of 3 blocks, e.g 456, 356, 346, to be
% correlated with first group


block_group_n1 = {'123', '124', '125', '126', '134', '135', '136', '145', '146', '156'};
block_group_n2 = {'456', '356', '346', '345', '256', '246', '245', '236', '235', '234'};
% 
% % for subjects with 5 blocks, e.g sub03
% block_group_n1 = {'123', '124', '125', '12', '134', '135', '13', '145', '14', '15'};
% block_group_n2 = {'45', '35', '34', '345', '25', '24', '245', '23', '235', '234'};


if fix_cond == 1
    %load  vmp for each run individually
    for blockn = 1:nRuns
        [Intact_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_intact_blkbkg_as_fix_VMP_2x2.vmp']);
        [BS_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
        [Occluded_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
        [DelSharp_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
        [DelFuzz_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
        [Fixation_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
                
%         [test_vmp] = BVQXfile([subject_dir,'/test_vmp_t_vals.vmp']);
%         [testb_vmp] = BVQXfile([subject_dir,'/test_vmp_b_vals.vmp']);
    end
    
    %load stuff for split-half analysis
    % first groups
    for block_groups = 1:length(block_group_n1);
     [Intact_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_intact_blkbkg_as_fix_VMP_2x2.vmp']);
     [BS_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
     [Occluded_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
     [DelSharp_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
     [DelFuzz_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
     [Fixation_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
    end
    %second groups
    for block_groups = 1:length(block_group_n2);
     [Intact_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_intact_blkbkg_as_fix_VMP_2x2.vmp']);
     [BS_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
     [Occluded_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
     [DelSharp_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
     [DelFuzz_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
     [Fixation_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
    end
    
    
    
    % load vmp for all blocks averaged together
    [Intact_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_intact_blkbkg_as_fix_VMP_2x2.vmp']);
    [BS_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_BS_blkbkg_as_fix_VMP_2x2.vmp']);
    [Occluded_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
    [DelSharp_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
    [DelFuzz_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
    [Fixation_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
%     [test_vmp] = BVQXfile([subject_dir,'/test_vmp_t_vals.vmp']);
%     [testb_vmp] = BVQXfile([subject_dir,'/test_vmp_b_vals.vmp']);
    
    %view vmp data
    Intact_vmp{7}.Map.VMPData;
    tmp_img = squeeze(Intact_vmp{7}.Map.VMPData(1,:,:)); % Y, front to back
    figure; subplot(1,3,1), imagesc(tmp_img); colormap gray
    tmp_img = squeeze(Intact_vmp{7}.Map.VMPData(:,1,:)); % Z, top to bottom
    hold on, subplot(1,3,2), imagesc(tmp_img);colormap gray
    tmp_img = squeeze(Intact_vmp{7}.Map.VMPData(:,:,1)); % X, right to left
    subplot(1,3,3), imagesc(tmp_img);colormap gray
    %list = Intact_vmp.VoxelStats(1,voi.VOI(voinr).Voxels,'Tal')
else
     for blockn = 1:nRuns
        [Intact_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_intact_VMP_2x2.vmp']);
        [BS_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_BS_VMP_2x2.vmp']);
        [Occluded_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_occluded_VMP_2x2.vmp']);
        [DelSharp_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_delSh_VMP_2x2.vmp']);
        [DelFuzz_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_delFuzz_VMP_2x2.vmp']);
        [Fixation_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_BlkFix_VMP_2x2.vmp']);
%         [test_vmp] = BVQXfile([subject_dir,'/test_vmp_t_vals.vmp']);
%         [testb_vmp] = BVQXfile([subject_dir,'/test_vmp_b_vals.vmp']);
     end
    
     
     %load stuff for split-half analysis
    % first groups
    for block_groups = 1:length(block_group_n1);
     [Intact_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_intact_VMP_2x2.vmp']);
     [BS_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_BS_VMP_2x2.vmp']);
     [Occluded_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_occluded_VMP_2x2.vmp']);
     [DelSharp_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delSh_VMP_2x2.vmp']);
     [DelFuzz_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delFuzz_VMP_2x2.vmp']);
     [Fixation_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_BlkFix_VMP_2x2.vmp']);
    end
    %second groups
    for block_groups = 1:length(block_group_n2);
     [Intact_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_intact_VMP_2x2.vmp']);
     [BS_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_BS_VMP_2x2.vmp']);
     [Occluded_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_occluded_VMP_2x2.vmp']);
     [DelSharp_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delSh_VMP_2x2.vmp']);
     [DelFuzz_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delFuzz_VMP_2x2.vmp']);
     [Fixation_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_BlkFix_VMP_2x2.vmp']);
    end
     
     
     
    
    % load vmp for all blocks averaged together
    [Intact_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_intact_VMP_2x2.vmp']);
    [BS_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_BS_VMP_2x2.vmp']);
    [Occluded_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_occluded_VMP_2x2.vmp']);
    [DelSharp_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
    [DelFuzz_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
    [Fixation_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_BlkFix_VMP_2x2.vmp']);
%     [test_vmp] = BVQXfile([subject_dir,'/test_vmp_t_vals.vmp']);
%     [testb_vmp] = BVQXfile([subject_dir,'/test_vmp_b_vals.vmp']);
end
% global writedata



% maps = Intact_vmp.Map;
% mapnames = {maps(:).Name}



% tmp_img = squeeze(Intact_vmp{1}.Map.VMPData(1:58,1:40,28)); % Z, top to bottom
% figure; subplot(1,3,1), imagesc(tmp_img); colormap gray
% tmp_img = squeeze(Intact_vmp{1}.Map.VMPData(:,1,:)); % Y, front to back
% hold on, subplot(1,3,2), imagesc(tmp_img);colormap gray
% tmp_img = squeeze(Intact_vmp{1}.Map.VMPData(:,:,1)); % X, right to left
% subplot(1,3,3), imagesc(tmp_img);colormap gray


% tmp_img = squeeze(Intact_vmp{1}.Map.VMPData(:,54,:)); % Z, top to bottom
% % figure; subplot(1,3,1), imagesc(tmp_img); colormap gray
% figure; imagesc(tmp_img); colormap gray

voi_neuroElfIdx = [];
% extract vox coords from voi and convert to neuroelf idx
for blockn = [1:5,6,7:27]
    for voi_row = 1:VOI_BS.VOI.NrOfVoxels
        tmp = VOI_BS.VOI.Voxels(voi_row,:);
        [xIdx, yIdx, zIdx] = tal2native(tmp(1), tmp(2), tmp(3), 2);
        voi_neuroElfIdx(voi_row,:) = [xIdx yIdx zIdx];
        Intact_betas(voi_row,blockn) = Intact_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
        BS_betas(voi_row,blockn) = BS_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
        Occluded_betas(voi_row,blockn) = Occluded_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
        DeletedSharp_betas(voi_row,blockn) = DelSharp_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
        DeletedFuzzy_betas(voi_row,blockn) = DelFuzz_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
        Fixation_betas(voi_row,blockn) = Fixation_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%         test_betas(voi_row) = testb_vmp.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
    end
end

% % extract betas for ALL blocks together
% for voi_row = 1:VOI_BS.VOI.NrOfVoxels
%         tmp = VOI_BS.VOI.Voxels(voi_row,:);
%         [xIdx, yIdx, zIdx] = tal2native(tmp(1), tmp(2), tmp(3), 2);
%         voi_neuroElfIdx(voi_row,:) = [xIdx yIdx zIdx];
%         Intact_betas(voi_row,7) = Intact_vmp{7}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%         BS_betas(voi_row,7) = BS_vmp{7}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%         Occluded_betas(voi_row,7) = Occluded_vmp{7}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%         DeletedSharp_betas(voi_row,7) = DelSharp_vmp{7}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%         DeletedFuzzy_betas(voi_row,7) = DelFuzz_vmp{7}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%         Fixation_betas(voi_row,7) = Fixation_vmp{7}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
% %         test_betas(voi_row) = testb_vmp.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%     end

% clear objects to save memory now that we've extracted the betas

% e.g. VOI_BS.ClearObject
% e.g. Intact_vmp{1}.ClearObject


% remove duplicate betas (Voi is 1x1, data is 2x2, so some 2x2 voxels
% appear for separate 1x1 coords in TAL mode)

[C,unique_betas,~] = unique(Intact_betas(:,1), 'stable'); %these should be the same for each one so only need to calculate once. 
%Stable parameter stops them from being sorted in order (we need same order as they appear in the original matrix)


Intact_betas_unique = [];
BS_betas_unique = [];
Occluded_betas_unique = [];
DeletedSharp_betas_unique = [];
DeletedFuzzy_betas_unique = [];
Fixation_betas_unique = [];

for blockn = 1:27
        Intact_betas_unique(:, blockn) = Intact_betas(unique_betas,blockn);
        BS_betas_unique(:, blockn) = BS_betas(unique_betas,blockn);
        Occluded_betas_unique(:, blockn) = Occluded_betas(unique_betas,blockn);
        DeletedSharp_betas_unique(:, blockn) = DeletedSharp_betas(unique_betas,blockn);
        DeletedFuzzy_betas_unique(:, blockn) = DeletedFuzzy_betas(unique_betas,blockn);
        Fixation_betas_unique(:, blockn) = Fixation_betas(unique_betas,blockn);

end
% 
% % and now for ALL blocks
% Intact_betas_unique(:, 7) = Intact_betas(unique_betas,7);
% BS_betas_unique(:, 7) = BS_betas(unique_betas,7);
% Occluded_betas_unique(:, 7) = Occluded_betas(unique_betas,7);
% DeletedSharp_betas_unique(:, 7) = DeletedSharp_betas(unique_betas,7);
% DeletedFuzzy_betas_unique(:, 7) = DeletedFuzzy_betas(unique_betas,7);
% Fixation_betas_unique(:, 7) = Fixation_betas(unique_betas,7);


% do scatter plots of everything with everything and calculate R values
% do this for each block and between blocks as well


% ALL CONDS CORRELATED BETWEEN BLOCKS e.g. Intact 1 with Intact 2, BS 1
% with BS 2
% Block 1 with Block 2, 3, 4, 5, 6, ALL

%% INTACT

% Within each block
figure; plotcounter = 1;
all_correls = [];
correl_counter = 1;
for blockn = 2:7
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,1), Intact_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,1), Intact_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Intact betas Block 1'), ylabel(['Intact betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
    
end
 plotcounter = plotcounter +1; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 3:7
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,2), Intact_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,2), Intact_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Intact betas Block 2'), ylabel(['Intact betas Block ', num2str(blockn)]);
   if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +2; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 4:7
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,3), Intact_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,3), Intact_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Intact betas Block 3'), ylabel(['Intact betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +3; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 5:7
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,4), Intact_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,4), Intact_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Intact betas Block 4'), ylabel(['Intact betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +4; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 6:7
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,5), Intact_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,5), Intact_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Intact betas Block 5'), ylabel(['Intact betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +5; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 7
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,6), Intact_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,6), Intact_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Intact betas Block 6'), ylabel(['Intact betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end

all_correls_idx = find(all_correls ~= 0);
mean(all_correls(all_correls_idx))

% split-half across blocks
% e.g. 1,2,3 vs 4,5,6
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), Intact_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs Intact split-half')
mean(all_correls)


%% BS
all_correls = [];
figure; plotcounter = 1;
correl_counter = 1;
for blockn = 2:7
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,1), BS_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,1), BS_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('BS betas Block 1'), ylabel(['BS betas Block ', num2str(blockn)]);
     if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
 plotcounter = plotcounter +1; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 3:7
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,2), BS_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,2), BS_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('BS betas Block 2'), ylabel(['BS betas Block ', num2str(blockn)]);
     if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +2; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 4:7
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,3), BS_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,3), BS_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('BS betas Block 3'), ylabel(['BS betas Block ', num2str(blockn)]);
     if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +3; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 5:7
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,4), BS_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,4), BS_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('BS betas Block 4'), ylabel(['BS betas Block ', num2str(blockn)]);
     if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +4; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 6:7
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,5), BS_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,5), BS_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('BS betas Block 5'), ylabel(['BS betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +5; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 7
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,6), BS_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,6), BS_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('BS betas Block 6'), ylabel(['BS betas Block ', num2str(blockn)]);
     if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
all_correls_idx = find(all_correls ~= 0);
mean(all_correls(all_correls_idx))

% split-half across blocks
% e.g. 1,2,3 vs 4,5,6
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), BS_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS_betas_unique vs BS_betas_unique split-half')
mean(all_correls)

%% OCCLUDED
figure; plotcounter = 1;
all_correls = [];
correl_counter = 1;
for blockn = 2:7
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,1), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,1), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Occluded betas Block 1'), ylabel(['Occluded betas Block ', num2str(blockn)]);
     if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
 plotcounter = plotcounter +1; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 3:7
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,2), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,2), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Occluded betas Block 2'), ylabel(['Occluded betas Block ', num2str(blockn)]);
     if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +2; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 4:7
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,3), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,3), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Occluded betas Block 3'), ylabel(['Occluded betas Block ', num2str(blockn)]);
     if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +3; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 5:7
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,4), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,4), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Occluded betas Block 4'), ylabel(['Occluded betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +4; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 6:7
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,5), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,5), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Occluded betas Block 5'), ylabel(['Occluded betas Block ', num2str(blockn)]);
     if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +5; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 7
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,6), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,6), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Occluded betas Block 6'), ylabel(['Occluded betas Block ', num2str(blockn)]);
     if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
all_correls_idx = find(all_correls ~= 0);
mean(all_correls(all_correls_idx))

% split-half across blocks
% e.g. 1,2,3 vs 4,5,6
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), Occluded_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
     correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Occluded_betas_unique vs Occluded_betas_unique split-half')
mean(all_correls)


%% DELETED SHARP
figure; plotcounter = 1;
all_correls = [];
correl_counter = 1;
for blockn = 2:7
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,1), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,1), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelSh betas Block 1'), ylabel(['DelSh betas Block ', num2str(blockn)]);
   if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
 plotcounter = plotcounter +1; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 3:7
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,2), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,2), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelSh betas Block 2'), ylabel(['DelSh betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +2; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 4:7
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,3), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,3), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelSh betas Block 3'), ylabel(['DelSh betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +3; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 5:7
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,4), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,4), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelSh betas Block 4'), ylabel(['DelSh betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +4; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 6:7
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,5), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,5), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelSh betas Block 5'), ylabel(['DelSh betas Block ', num2str(blockn)]);
   if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +5; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 7
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,6), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,6), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelSh betas Block 6'), ylabel(['DelSh betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
all_correls_idx = find(all_correls ~= 0);
mean(all_correls(all_correls_idx))



% split-half across blocks
% e.g. 1,2,3 vs 4,5,6
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('DeletedSharp_betas_unique vs DeletedSharp_betas_unique split-half')
mean(all_correls)

%% Deleted Fuzzy
figure; plotcounter = 1;
all_correls = [];
correl_counter = 1;
for blockn = 2:7
    subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,1), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,1), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelFuzz betas Block 1'), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
 plotcounter = plotcounter +1; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 3:7
    subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,2), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,2), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelFuzz betas Block 2'), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +2; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 4:7
    subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,3), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,3), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelFuzz betas Block 3'), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +3; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 5:7
    subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,4), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,4), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelFuzz betas Block 4'), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +4; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 6:7
    subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,5), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,5), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelFuzz betas Block 5'), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +5; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 7
    subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,6), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,6), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('DelFuzz betas Block 6'), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
all_correls_idx = find(all_correls ~= 0);
mean(all_correls(all_correls_idx))


% split-half across blocks
% e.g. 1,2,3 vs 4,5,6
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('DeletedFuzzy_betas_unique vs DeletedFuzzy_betas_unique split-half')
mean(all_correls)


%% GREY FIX

figure; plotcounter = 1;
all_correls = [];
correl_counter = 1;
for blockn = 2:7
    subplot(6,6,plotcounter); scatter(Fixation_betas_unique(:,1), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,1), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Fix betas Block 1'), ylabel(['Fix betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
 plotcounter = plotcounter +1; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 3:7
    subplot(6,6,plotcounter); scatter(Fixation_betas_unique(:,2), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,2), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Fix betas Block 2'), ylabel(['Fix betas Block ', num2str(blockn)]);
   if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +2; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 4:7
    subplot(6,6,plotcounter); scatter(Fixation_betas_unique(:,3), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,3), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Fix betas Block 3'), ylabel(['Fix betas Block ', num2str(blockn)]);
    if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +3; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 5:7
    subplot(6,6,plotcounter); scatter(Fixation_betas_unique(:,4), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,4), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Fix betas Block 4'), ylabel(['Fix betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +4; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 6:7
    subplot(6,6,plotcounter); scatter(Fixation_betas_unique(:,5), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,5), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Fix betas Block 5'), ylabel(['Fix betas Block ', num2str(blockn)]);
    if blockn ~= 7
       correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
plotcounter = plotcounter +5; %skip one plot, as we just need to plot the upper right half of the correlation matrix
for blockn = 7
    subplot(6,6,plotcounter); scatter(Fixation_betas_unique(:,6), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,6), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel('Fix betas Block 6'), ylabel(['Fix betas Block ', num2str(blockn)]);
    if blockn ~= 7
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    plotcounter = plotcounter +1;
end
all_correls_idx = find(all_correls ~= 0);
mean(all_correls(all_correls_idx))


% split-half across blocks
% e.g. 1,2,3 vs 4,5,6
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
   correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Fixation_betas_unique vs Fixation_betas_unique split-half')
mean(all_correls)



%%

% ALL BLOCKS CORRELATED BETWEEN CONDS. E.g. Intact 1 with BS 1, Intact 2
% with BS 2
% Intact with BS, Occ, DelSh, DelF, Grey Fix

% BS with Intact, Occ, DelSh, DelF, Grey Fix

% Occ with Intact, BS, DelSh, DelF, Grey Fix

% DelSh with Intact, BS, Occ, DelF, Grey Fix

% DelFuzz with Intact, BS, Occ, DelSh, Grey Fix

% Grey Fix with Intact, BS, Occ, DelSh, DelF


%% BLOCK 1

figure; plotcounter = 1;
for blockn = 1:7
    figure; plotcounter = 1;
    % Intact
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), BS_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), BS_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['BS betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['Occluded betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['DelSharp betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +2;
    
    
    % BS
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), Occluded_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), Occluded_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['Occluded betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['DelSharp betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +3;
    
    % Occluded
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Occluded betas Block ', num2str(blockn)]), ylabel(['DelSharp betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Occluded betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Occluded betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +4;
    
    % Deleted Sharp
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelSharp betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +1;
    
    subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelSharp betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +5;
    
    % Deleted Fuzzy
    subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelFuzz betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    plotcounter = plotcounter +6;
end

%split half stuff
all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     figure; plotcounter = 1;
    % Intact
    %     subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), BS_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), BS_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['BS betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +1;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs BS')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), Occluded_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), Occluded_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['Occluded betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
    correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end   
disp('Intact vs Occluded')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['DelSharp betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs Del Sharp')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs Del Fuzzy')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +2;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs Fixation')
mean(all_correls)

% ````````````````````` BS
 
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    % BS
%     subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), Occluded_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), Occluded_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['Occluded betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS vs Occluded')
mean(all_correls)



all_correls = [];
correl_counter = 1;
for  blockn = 8:17
%     subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['DelSharp betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS vs Del Sharp')
mean(all_correls)


all_correls = [];
correl_counter = 1;
for  blockn = 8:17
%     subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS vs Del Fuzzy')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +3;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS vs Fixation')
mean(all_correls)



%`````````````` Occluded
all_correls = [];
correl_counter = 1;
for blockn = 8:17
    % Occluded
%     subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Occluded betas Block ', num2str(blockn)]), ylabel(['DelSharp betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
end
disp('Occluded vs Del Sharp')
mean(all_correls)



all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Occluded betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Occluded vs Del Fuzzy')
mean(all_correls)



all_correls = [];
correl_counter = 1;
for blockn = 8:17
%     subplot(6,6,plotcounter); scatter(Occluded_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Occluded betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +4;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Occluded vs Fixation')
mean(all_correls)


all_correls = [];
correl_counter = 1;
for blockn = 8:17
    % Deleted Sharp
%     subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelSharp betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +1;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Deleted Sharp vs Deleted Fuzzy')
mean(all_correls)


all_correls = [];
correl_counter = 1;
for blockn = 8:17
   
%     subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelSharp betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +5;
    correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Deleted Sharp vs Fixation')
mean(all_correls)


all_correls = [];
correl_counter = 1;
for blockn = 8:17
    
%     % Deleted Fuzzy
%     subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
%     hold on; lsline; %axis square; 
    [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
%     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelFuzz betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
%     plotcounter = plotcounter +6;
correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Deleted Fuzzy vs Fixation')
mean(all_correls)


%% BLOCK 2

%% BLOCK 3

%% BLOCK 4

%% BLOCK 5

%% BLOCK 6

%% BLOCK 7


