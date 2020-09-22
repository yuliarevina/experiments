% Analysis of Neural Correlates of Perceptual Filling In
% Correlation of betas from different conditions of stimulus in a specific
% VOI

% Need VMP files with betas for each condition (create in BV)
% Need VOI file with region of interest (create in BV using localizer)

% Written by Yulia Revina, NTU, Singapore
% September 2018

% -------------------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------

sub_no = '26'; %subject code
nRuns = 6; %how many runs for this particular subject?
dir = 'C:/Users/HSS/Documents/GitHub/experiments/MRI - Neural Correlates of Filling-in/Analysis';
subject_dir = [dir, '/SUB' sub_no]; %specific path for the current subject
fix_cond = 1; %1 = baseline is black fixation, grey fixation is treated as a stimulus
        % 2 = baseline = grey fixation; black fixation is treated as a
        % stimulus
blkbkg_as_stim = 0; %is black bkg treated as a stimulus? (as well as background)
        
% load voi
% [VOI_BS] = BVQXfile([subject_dir,'/Actual_Stim_conservative.voi']);
% [VOI_BS] = BVQXfile([subject_dir,'/BS_CON_for_multivar.voi']);
% [VOI_BS] = BVQXfile([subject_dir,'/TargetBoth-TargetBS_2x2.voi']);
% [VOI_BS] = BVQXfile([subject_dir,'/ACTUAL_CON_for_multivar.voi']);
[VOI_BS] = BVQXfile([subject_dir,'/V1_AROUND_STIM_for_multivar.voi']);
% [VOI_BS] = BVQXfile([subject_dir,'/V2_for_multivar.voi']);
% [VOI_BS] = BVQXfile([subject_dir,'/V2_ACTUAL_STIM_CON.voi']);



% [Test_vmp] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_all_blkbkg_as_fix_VMP_2x2.vmp']);
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
% list = vmp.VoxelStats(1,voi.VOI(voinr).Voxels,�Tal�)

% Create vars for each condition
% There are 5-6 blocks of scans (depending on technical issues during data
% collection
% There are also two VMP maps for each condition: 1 created using grey
% screen as baseline and another using black screen as baseline.

Intact_betas = [];
BS_betas = [];
% Occluded_betas = [];
DeletedSharp_betas = [];
% DeletedFuzzy_betas = [];
ControlFellow_betas = [];
ControlBSEye_betas = [];
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
% % 
% % % for subjects with 5 blocks, e.g sub03
% block_group_n1 = {'123', '124', '125', '12', '134', '135', '13', '145', '14', '15'};
% block_group_n2 = {'45', '35', '34', '345', '25', '24', '245', '23', '235', '234'};


if fix_cond == 1
%     %load  vmp for each run individually
%     if ~strcmp(sub_no, '07') && ~strcmp(sub_no, '10')&& ~strcmp(sub_no, '11')&& ~strcmp(sub_no, '12')&& ~strcmp(sub_no, '13')
%         for blockn = 1:nRuns
%             [Intact_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_intact_blkbkg_as_fix_VMP_2x2.vmp']);
%             [BS_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
%             [Occluded_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
%             [DelSharp_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
%             [DelFuzz_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
%             [Fixation_vmp{blockn}] = BVQXfile([subject_dir,'/Block', num2str(blockn),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
%             
%             %         [test_vmp] = BVQXfile([subject_dir,'/test_vmp_t_vals.vmp']);
%             %         [testb_vmp] = BVQXfile([subject_dir,'/test_vmp_b_vals.vmp']);
%         end
%     end
    %load stuff for split-half analysis
    % first groups
%     if ~strcmp(sub_no, '07') && ~strcmp(sub_no, '10')&& ~strcmp(sub_no, '11')&& ~strcmp(sub_no, '12')&& ~strcmp(sub_no, '13')
        if blkbkg_as_stim
            for block_groups = 1:length(block_group_n1);
                [ALL_cond_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_all_blkbkg_as_fix_and_stim_VMP_2x2.vmp']);
            end
        else %normal analysis, blkfix not a stim
            for block_groups = 1:length(block_group_n1);
                [ALL_cond_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_all_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [Intact_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_intact_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [BS_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [Occluded_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
%                 [DelSharp_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [DelFuzz_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [Fixation_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
            end
        end
        %second groups
        if blkbkg_as_stim
            for block_groups = 1:length(block_group_n2);
                [ALL_cond_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_all_blkbkg_as_fix_and_stim_VMP_2x2.vmp']);
            end
        else %normal
            for block_groups = 1:length(block_group_n2);
                [ALL_cond_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_all_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [Intact_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_intact_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [BS_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [Occluded_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
%                 [DelSharp_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [DelFuzz_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
%                 [Fixation_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
            end
        end
%     else % subs 7,10, etc
%         if blkbkg_as_stim
%              for block_groups = 1:length(block_group_n1);
%                 [ALL_cond_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_all_blkbkg_as_fix_and_stim_VMP_2x2.vmp']);
%              end
%         else %normal
%             for block_groups = 1:length(block_group_n1);
%                 [ALL_cond_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_all_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [BS_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [Occluded_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
%                 %             [DelSharp_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [DelFuzz_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [Fixation_vmp{7+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n1{block_groups}),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
%             end
%         end
%         %second groups
%         if blkbkg_as_stim
%             for block_groups = 1:length(block_group_n2);
%                 [ALL_cond_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_all_blkbkg_as_fix_and_stim_VMP_2x2.vmp']);
%             end
%         else
%             for block_groups = 1:length(block_group_n2);
%                 [ALL_cond_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_all_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [BS_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_BS_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [Occluded_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
%                 %             [DelSharp_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [DelFuzz_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
%                 %             [Fixation_vmp{17+block_groups}] = BVQXfile([subject_dir,'/Block', num2str(block_group_n2{block_groups}),'_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
%             end
%         end
%     end
    
%     if ~strcmp(sub_no, '07') && ~strcmp(sub_no, '10')&& ~strcmp(sub_no, '11')&& ~strcmp(sub_no, '12')&& ~strcmp(sub_no, '13')
%         % load vmp for all blocks averaged together
%         [Intact_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_intact_blkbkg_as_fix_VMP_2x2.vmp']);
%         [BS_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_BS_blkbkg_as_fix_VMP_2x2.vmp']);
%         [Occluded_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_blkbkg_as_fix_occluded_VMP_2x2.vmp']);
%         [DelSharp_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_delSh_blkbkg_as_fix_VMP_2x2.vmp']);
%         [DelFuzz_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_delFuzz_blkbkg_as_fix_VMP_2x2.vmp']);
%         [Fixation_vmp{7}] = BVQXfile([subject_dir,'/Block_ALL_GreyFix_blkbkg_as_fix_VMP_2x2.vmp']);
%         %     [test_vmp] = BVQXfile([subject_dir,'/test_vmp_t_vals.vmp']);
%         %     [testb_vmp] = BVQXfile([subject_dir,'/test_vmp_b_vals.vmp']);
%         
%         %view vmp data
%         Intact_vmp{7}.Map.VMPData;
%         tmp_img = squeeze(Intact_vmp{7}.Map.VMPData(1,:,:)); % Y, front to back
%         figure; subplot(1,3,1), imagesc(tmp_img); colormap gray
%         tmp_img = squeeze(Intact_vmp{7}.Map.VMPData(:,1,:)); % Z, top to bottom
%         hold on, subplot(1,3,2), imagesc(tmp_img);colormap gray
%         tmp_img = squeeze(Intact_vmp{7}.Map.VMPData(:,:,1)); % X, right to left
%         subplot(1,3,3), imagesc(tmp_img);colormap gray
%         %list = Intact_vmp.VoxelStats(1,voi.VOI(voinr).Voxels,'Tal')
%     end
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
for blockn = [8:27]
%     if ~strcmp(sub_no, '07') && ~strcmp(sub_no, '10')&& ~strcmp(sub_no, '11')&& ~strcmp(sub_no, '12')&& ~strcmp(sub_no, '13') && ~blkbkg_as_stim
%         for voi_row = 1:VOI_BS.VOI.NrOfVoxels
%             tmp = VOI_BS.VOI.Voxels(voi_row,:);
%             [xIdx, yIdx, zIdx] = tal2native(tmp(1), tmp(2), tmp(3), 2);
%             voi_neuroElfIdx(voi_row,:) = [xIdx yIdx zIdx];
%             Intact_betas(voi_row,blockn) = Intact_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             BS_betas(voi_row,blockn) = BS_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             Occluded_betas(voi_row,blockn) = Occluded_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             DeletedSharp_betas(voi_row,blockn) = DelSharp_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             DeletedFuzzy_betas(voi_row,blockn) = DelFuzz_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             Fixation_betas(voi_row,blockn) = Fixation_vmp{blockn}.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             %         test_betas(voi_row) = testb_vmp.Map.VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%         end
%     else
        for voi_row = 1:VOI_BS.VOI.NrOfVoxels
            if mod(voi_row,50) == 0 || voi_row == 1 %every 50 rows or on the first row
                disp(sprintf('Getting betas from vmp: Block %d, VOI row %d out of %d', blockn, voi_row,VOI_BS.VOI.NrOfVoxels))
            end
            tmp = VOI_BS.VOI.Voxels(voi_row,:);
            [xIdx, yIdx, zIdx] = tal2native(tmp(1), tmp(2), tmp(3), 2);
            voi_neuroElfIdx(voi_row,:) = [xIdx yIdx zIdx];
            Intact_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(1).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
            BS_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(2).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             Occluded_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(3).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
            DeletedSharp_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(3).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
%             DeletedFuzzy_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(5).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
            ControlFellow_betas(voi_row, blockn) = ALL_cond_vmp{blockn}.Map(4).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
            ControlBSEye_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(5).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
            Fixation_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(6).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
            if blkbkg_as_stim
                BlackBkg_betas(voi_row,blockn) = ALL_cond_vmp{blockn}.Map(7).VMPData(voi_neuroElfIdx(voi_row,1), voi_neuroElfIdx(voi_row,2),voi_neuroElfIdx(voi_row,3));
            end
%             
%             %
        end
%     end
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

VOI_BS.ClearObject
% if ~strcmp(sub_no, '07') && ~strcmp(sub_no, '10')&& ~strcmp(sub_no, '11')&& ~strcmp(sub_no, '12')&& ~strcmp(sub_no, '13') && ~blkbkg_as_stim
%     for i = 1:27
%         Intact_vmp{i}.ClearObject
%         BS_vmp{i}.ClearObject
%         Occluded_vmp{i}.ClearObject
%         DelSharp_vmp{i}.ClearObject
%         DelFuzz_vmp{i}.ClearObject
%         Fixation_vmp{i}.ClearObject
%     end
% else
%     for i = 8:27
%         ALL_cond_vmp{i}.ClearObject;
%     end
% end

% remove duplicate betas (Voi is 1x1, data is 2x2, so some 2x2 voxels
% appear for separate 1x1 coords in TAL mode)

[C,unique_betas,~] = unique(Intact_betas(:,8), 'stable'); %these should be the same for each one so only need to calculate once. 
%Stable parameter stops them from being sorted in order (we need same order as they appear in the original matrix)


Intact_betas_unique = [];
BS_betas_unique = [];
% Occluded_betas_unique = [];
DeletedSharp_betas_unique = [];
% DeletedFuzzy_betas_unique = [];
ControlFellow_betas_unique = [];
ControlBSEye_betas_unique = [];
Fixation_betas_unique = [];
% BlackBkg_betas_unique = [];
for blockn = 1:27
        disp(sprintf('Calculating unique betas: Block %d', blockn))
        Intact_betas_unique(:, blockn) = Intact_betas(unique_betas,blockn);
        BS_betas_unique(:, blockn) = BS_betas(unique_betas,blockn);
%         Occluded_betas_unique(:, blockn) = Occluded_betas(unique_betas,blockn);
        DeletedSharp_betas_unique(:, blockn) = DeletedSharp_betas(unique_betas,blockn);
        ControlFellow_betas_unique(:,blockn) = ControlFellow_betas(unique_betas,blockn);
        ControlBSEye_betas_unique(:,blockn) = ControlBSEye_betas(unique_betas,blockn);
%         DeletedFuzzy_betas_unique(:, blockn) = DeletedFuzzy_betas(unique_betas,blockn);
        Fixation_betas_unique(:, blockn) = Fixation_betas(unique_betas,blockn);
        if blkbkg_as_stim
             BlackBkg_betas_unique(:, blockn) = BlackBkg_betas(unique_betas,blockn);
        end
        

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


%% DELETED SHARP

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

all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(ControlFellow_betas_unique(:,blockn), ControlFellow_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('ControlFellow_betas_unique vs ControlFellow_betas_unique split-half')
mean(all_correls)


all_correls = [];
correl_counter = 1;
for blockn = 8:17
    [correl_R, corr_pval] = corr(ControlBSEye_betas_unique(:,blockn), ControlBSEye_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('ControlBSEye_betas_unique vs ControlBSEye_betas_unique split-half')
mean(all_correls)

%% GREY FIX

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

% % %% Black bkg as stim
% % % split-half across blocks
% % % e.g. 1,2,3 vs 4,5,6
% % all_correls = [];
% % correl_counter = 1;
% % for blockn = 8:17
% %     [correl_R, corr_pval] = corr(BlackBkg_betas_unique(:,blockn), BlackBkg_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
% %    correl_Z = fisherztransform(correl_R);
% %         all_correls(correl_counter) = correl_Z;
% %     correl_counter = correl_counter + 1;
% % end
% % disp('BlackBkg_betas_unique vs BlackBkg_betas_unique split-half')
% % mean(all_correls)

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

%%
%split half stuff for Cond1 vs Cond2
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
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), Intact_betas_unique(:,blockn+10)); %block 8 corr with block 18, block 9 with block 19 etc
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs BS')
mean(all_correls)

% all_correls = [];
% correl_counter = 1;
% for blockn = 8:17
% %     subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), Occluded_betas_unique(:,blockn));
% %     hold on; lsline; %axis square; 
%     [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), Occluded_betas_unique(:,blockn+10));
% %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['Occluded betas Block ', num2str(blockn)]);
% %     plotcounter = plotcounter +1;
%     correl_Z = fisherztransform(correl_R);
%         all_correls(correl_counter) = correl_Z;
%     correl_counter = correl_counter + 1;
%     [correl_R, corr_pval] = corr(Occluded_betas_unique(:,blockn), Intact_betas_unique(:,blockn+10));%do it the opposite way now
%     correl_Z = fisherztransform(correl_R);
%         all_correls(correl_counter) = correl_Z;
%     correl_counter = correl_counter + 1;
% end   
% disp('Intact vs Occluded')
% mean(all_correls)

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
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), Intact_betas_unique(:,blockn+10)); %do it the opposite way now
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
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), ControlFellow_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +1;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(ControlFellow_betas_unique(:,blockn), Intact_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs ControlFellow')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
    %     subplot(6,6,plotcounter); scatter(Intact_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(Intact_betas_unique(:,blockn), ControlBSEye_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['Intact betas Block ',num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +1;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(ControlBSEye_betas_unique(:,blockn), Intact_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs ControlBSEye')
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
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,blockn), Intact_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Intact vs Fixation')
mean(all_correls)

% ````````````````````` BS
 
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
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), BS_betas_unique(:,blockn+10));
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
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), ControlFellow_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +1;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(ControlFellow_betas_unique(:,blockn), BS_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS vs ControlFellow')
mean(all_correls)


all_correls = [];
correl_counter = 1;
for blockn = 8:17
    %     subplot(6,6,plotcounter); scatter(BS_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(BS_betas_unique(:,blockn), ControlBSEye_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['BS betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +3;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(ControlBSEye_betas_unique(:,blockn), BS_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS vs ControlBSEye')
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
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,blockn), BS_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('BS vs Fixation')
mean(all_correls)




all_correls = [];
correl_counter = 1;
for blockn = 8:17
    % Deleted Sharp
    %     subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), ControlFellow_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelSharp betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +1;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(ControlFellow_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Deleted Sharp vs ControlFellow')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
    % Deleted Sharp
    %     subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), ControlBSEye_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelSharp betas Block ', num2str(blockn)]), ylabel(['DelFuzz betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +1;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(ControlBSEye_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Deleted Sharp vs ControlBSEye')
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
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('Deleted Sharp vs Fixation')
mean(all_correls)

if blkbkg_as_stim
    all_correls = [];
    correl_counter = 1;
    for blockn = 8:17
        
        %     subplot(6,6,plotcounter); scatter(DeletedSharp_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
        %     hold on; lsline; %axis square;
        [correl_R, corr_pval] = corr(DeletedSharp_betas_unique(:,blockn), BlackBkg_betas_unique(:,blockn+10));
        %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelSharp betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
        %     plotcounter = plotcounter +5;
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
        [correl_R, corr_pval] = corr(BlackBkg_betas_unique(:,blockn), DeletedSharp_betas_unique(:,blockn+10));
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    disp('Deleted Sharp vs Black')
    mean(all_correls)
end

all_correls = [];
correl_counter = 1;
for blockn = 8:17
    
    %     % Deleted Fuzzy
    %     subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(ControlFellow_betas_unique(:,blockn), ControlBSEye_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelFuzz betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +6;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(ControlBSEye_betas_unique(:,blockn), ControlFellow_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('ControlFellow vs ControlBSEye')
mean(all_correls)

all_correls = [];
correl_counter = 1;
for blockn = 8:17
    
    %     % Deleted Fuzzy
    %     subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(ControlFellow_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelFuzz betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +6;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,blockn), ControlFellow_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('ControlFellow vs Fixation')
mean(all_correls)


all_correls = [];
correl_counter = 1;
for blockn = 8:17
    
    %     % Deleted Fuzzy
    %     subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
    %     hold on; lsline; %axis square;
    [correl_R, corr_pval] = corr(ControlBSEye_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
    %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelFuzz betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
    %     plotcounter = plotcounter +6;
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
    [correl_R, corr_pval] = corr(Fixation_betas_unique(:,blockn), ControlBSEye_betas_unique(:,blockn+10));
    correl_Z = fisherztransform(correl_R);
    all_correls(correl_counter) = correl_Z;
    correl_counter = correl_counter + 1;
end
disp('ControlBSEye vs Fixation')
mean(all_correls)

if blkbkg_as_stim
    all_correls = [];
    correl_counter = 1;
    for blockn = 8:17
        
        %     % Deleted Fuzzy
        %     subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
        %     hold on; lsline; %axis square;
        [correl_R, corr_pval] = corr(DeletedFuzzy_betas_unique(:,blockn), BlackBkg_betas_unique(:,blockn+10));
        %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelFuzz betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
        %     plotcounter = plotcounter +6;
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
        [correl_R, corr_pval] = corr(BlackBkg_betas_unique(:,blockn), DeletedFuzzy_betas_unique(:,blockn+10));
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    disp('Deleted Fuzzy vs Black')
    mean(all_correls)
end

if blkbkg_as_stim
    all_correls = [];
    correl_counter = 1;
    for blockn = 8:17
        
        %     % Deleted Fuzzy
        %     subplot(6,6,plotcounter); scatter(DeletedFuzzy_betas_unique(:,blockn), Fixation_betas_unique(:,blockn));
        %     hold on; lsline; %axis square;
        [correl_R, corr_pval] = corr(Fixation_betas_unique(:,blockn), BlackBkg_betas_unique(:,blockn+10));
        %     title(['R = ', num2str(correl_R), '  p = ', num2str(corr_pval)]); xlabel(['DelFuzz betas Block ', num2str(blockn)]), ylabel(['Fixation betas Block ', num2str(blockn)]);
        %     plotcounter = plotcounter +6;
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
        [correl_R, corr_pval] = corr(BlackBkg_betas_unique(:,blockn), Fixation_betas_unique(:,blockn+10));
        correl_Z = fisherztransform(correl_R);
        all_correls(correl_counter) = correl_Z;
        correl_counter = correl_counter + 1;
    end
    disp('Fixation vs Black')
    mean(all_correls)
end


%% Multidimensional scaling

%Select data

% currdata = MRI_multivariate.Expt1_BS_CON_V1_average_for_MDS;
% currdata = MRI_multivariate.Expt1_ACTUAL_CON_V1_average_for_MDS;
% currdata = MRI_multivariate.Expt1_BS_CON_V2_average_for_MDS;
% currdata = MRI_multivariate.Expt1_ACTUAL_CON_V2_average_for_MDS;
% currdata = MRI_multivariate.Expt1_V1_outside_stim_average_for_MDS;
% currdata = MRI_multivariate.Expt1_BS_EDGE_V1_average_for_MDS;
% currdata = MRI_multivariate.Expt1_BS_EDGE_V2_average_for_MDS;

% currdata = MRI_multivariate.Expt2_BS_CON_V1_average_for_MDS;
% currdata = MRI_multivariate.Expt2_ACTUAL_CON_V1_average_for_MDS;
% currdata = MRI_multivariate.Expt2_BS_CON_V2_average_for_MDS;
% currdata = MRI_multivariate.Expt2_ACTUAL_CON_V2_average_for_MDS;
% currdata = MRI_multivariate.Expt2_V1_outside_stim_average_for_MDS;
% currdata = MRI_multivariate.BothExRpt_BS_CON_V1_average_for_MDS;
% currdata = MRI_multivariate.BothExpt_ACTUAL_CON_V1_average_for_MDS;
% currdata = MRI_multivariate.BothExpt_BS_CON_V2_average_for_MDS;
% currdata = MRI_multivariate.BothExpt_ACTUAL_CON_V2_average_for_MDS;
% currdata = MRI_multivariate.BothExpt_V1_outside_stim_average_for_MDS;

% currdata = MRI_multivariate.Expt2_BS_CON_V1_average_for_MDS_CORRECTED_FOR_EYE_of_ORIGIN;
% currdata = MRI_multivariate.Expt2_ACTUAL_CON_V1_average_for_MDS_CORRECTED_FOR_EYE_of_ORIGIN;
% currdata = MRI_multivariate.Expt2_BS_CON_V2_average_for_MDS_CORRECTED_FOR_EYE_of_ORIGIN;
currdata = MRI_multivariate.Expt2_ACTUAL_CON_V2_average_for_MDS_CORRECTED_FOR_EYE_of_ORIGIN;
ncond = 6; %4 or 6



% needs to a dissimilarity matrix not similarity so try a transform
% D_BS_tr1 = 1./D_BS
% D_BS_tr2 = 1 - D_BS

% needs to be zeros on diagonal

% for i = 1:6
%     D_BS_tr1(i,i) = 0;
%     D_BS_tr2(i,i) = 0;
% end

% Y_tr1 = cmdscale(D_BS, 2)
 


%fill in the lower triangle
for row = 1:size(currdata,1)
    for column = 1:size(currdata,2)
        currdata(column,row) = currdata(row,column);
    end
end


%normalize
minval = -1.5;
maxval = 1.5;
%(value-minX)/(maxX-minX) 
currdata_trnsf = ((currdata - minval)/ (maxval - minval));

% add 1s to diagonal
for i = 1:size(currdata_trnsf,1)
    currdata_trnsf(i,i) = 1;
end

%extract unique values (upper triangle) which will be used as line
%thicknesses for plotting
offset = 1; %start with second column
currcolumn = 1;
tmp = 1;
column = 1;
widthsvector = [];
for row = 1:ncond - 1
    currcolumn = 1;
    for column = currcolumn+offset:size(currdata_trnsf,2)
        widthsvector(tmp) = currdata_trnsf(row,column);
        tmp = tmp + 1;
    end
    offset = offset + 1;
end
widthsvector = widthsvector';


% MDS
[Y_tr1,eigenvals] = cmdscale(currdata_trnsf)

% plot eigenvalues
figure; plot(1:length(eigenvals)-1, eigenvals(1:end-1))
% figure; plot(1:5, eigenvals(1:5))



figure; plot(Y_tr1(:,1), Y_tr1(:,2), 'ko', 'MarkerSize', 10)
% labels_names = {'Intact', 'BS', 'Occluded', 'DelSh', 'DelFuzz', 'Grey'};
% labels_names = {'Intact', 'BS', 'Occ', 'DelSh', 'DelFuzz', 'Grey', 'Black'};
labels_names = {'Intact', 'BS', 'DelSh', 'CtrlFellow', 'CtrlBS', 'Grey'};
% labels_names = {'Intact', 'BS', 'DelSh', 'Grey'};
% text(Y_tr1(:,1)+0.02,Y_tr1(:,2),labels_names);
%add lines of thickness corresponding to relationship
hold on
counter = 1;
for a = 1:ncond-1
    for b = a+1:ncond
        plot([Y_tr1([a,b],1)'], [Y_tr1([a,b],2)'], 'r-', 'LineWidth', 2*widthsvector(counter))
        counter = counter + 1;
    end
end
set(gcf, 'Position', [500 500 800 800])
axis([-0.6 0.6 -0.6 0.6] )
axis square
text(Y_tr1(:,1)+0.02,Y_tr1(:,2),labels_names);


%% Stats on multivariate correlations

% V1

nobvs = 26;
nobvsV2 = 7;
expt1subs = 1:13;
expt2subs = 14:26;

expt1V2subsBSROI = [2,7,9:13];
expt1V2subsACTUALROI = [2,7,9:13];

expt2V2subsBSROI = [14:16,19:20,24];
expt2V2subsACTUALROI = [14:16, 18:22,24:25];
expt2V2subsACTUALROI_V1matchV2 = [14,16, 18:20, 22, 24];

exptBothV2subsBSROI =  [2,7,9:16,19:20,24]; % only subs with V2 rois available
exptBothV2subsACTUALROI =  [2,7,9:16,18:22,24:25]; % only subs with V2 rois available


exptBothsubsACTUALROI_V1matchV2 = [2,7,9:14,16, 18:20,22,24]; %only subs where BOTH V1 and V2 are available (removes 3 V2 subs without a V1)

% ROIS
% 1 = BS_CON_V1
% 2 = ACTUAL_CON_V1
% 3 = V1_around_stim
% 4 = BS_CON_V2
% 5 = ACTUAL_CON_V2
% 6 = BS_EDGE_V1
% 7 = BS_EDGE_V2

% CONDS
% 1 = Intact vs BS
% 2 = Intact vs Occ
% 3 = Intact vs DelSh
% 4 = Intact vs DelFuzz
% 5 = Intact vs Ctrl Fellow
% 6 = Intact vs Ctrl BS
% 7 = Intact vs Grey
% 8 = BS vs Occ
% 9 = BS vs DelSh
% 10 = BS vs DelFuzz
% 11 = BS vs Ctrl Fellow
% 12 = BS vs Ctrl BS
% 13 = BS vs Grey
% 14 = Occ vs DelSh
% 15 = Occ vs DelFuzz
% 16 = Occ vs Grey
% 17 = DelSh vs DelFuzz
% 18 = DelSh vs Ctrl Fellow
% 19 = DelSh vs Ctrl BS
% 20 = DelSh vs Grey
% 21 = Del Fuzz vs Grey
% 22 = Ctrl Fellow vs Ctrl BS
% 23 = Ctrl Fellow vs Grey
% 24 = Ctrl BS vs Grey
% 25 = {blank}
% 26 = Intact vs Intact
% 27 = BS vs BS
% 28 = Occ vs Occ
% 29 = DelSh vs DelSh
% 30 = DelFuzzy vs DelFuzzy
% 31 = Ctrl Fellow vs Ctrl Fellow
% 32 = Ctrl BS vs Ctrl BS
% 33 = Grey vs Grey




%%%%%%%%%%%%%%%%%%%%%%%%%%%
%which experiment?
whichexpt = 2; %1 or 2 or 3(both)
whichrois = 1; % 1 normal results; 2 supplementary

%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if whichrois == 1
%     rois = 1:3; %for main results V1
% elseif whichrois == 2
%     rois = [1,6, 4, 7]; %for supplementary fig with BS EDGE ROIs
% end


if whichexpt == 1;
    subs = expt1subs;
%     conds = [1,2,3,4,5,8];
elseif whichexpt == 2;
    subs = expt2subs;
%     conds = [1,2,4,6,7,8];
else
    subs = [expt1subs, expt2subs];
%     conds = [1,2,4,8];
%     catIdx = repmat([zeros(1,length(expt1subs))'; ones(1,length(expt2subs))'],[length(conds), 1]);
end



clear data_to_plot
%data_to_plot(1,1,1) = [];
data_to_plot(:,:,1) = MRI_multivariate.BS_CON_V1;
data_to_plot(:,:,2) = MRI_multivariate.ACTUAL_CON_V1;
% data_to_plot(:,:,3) = MRI_univariate.V1_outside_stim_all_expts;
data_to_plot(:,:,4) = MRI_multivariate.BS_CON_V2;
data_to_plot(:,:,5) = MRI_multivariate.ACTUAL_CON_V2;
% data_to_plot(:,:,6) = MRI_univariate.BS_EDGE_V1_expt1;
% data_to_plot(:,:,7) = MRI_univariate.BS_EDGE_V2_expt1;
data_to_plot(:,:,8) = MRI_multivariate.BS_CON_V1_eye_of_origin_corr;
data_to_plot(:,:,9) = MRI_multivariate.BS_CON_V2_eye_of_origin_corr;

clear x_index;
% initial_coords = [0, 100, 200, 300, 400, 500];
% initial_coords = [0, 200, 400, 600, 800, 1000];
initial_coords = [0, 250, 500, 750, 1000, 1250 1500 1750];
x_index(:,:,1) = initial_coords;
x_index(:,:,2) = initial_coords + 40;
x_index(:,:,3) = initial_coords + 80;
x_index(:,:,4) = initial_coords + 120;
x_index(:,:,5) = initial_coords + 160;
x_index(:,:,6) = initial_coords + 200;
x_index(:,:,7) = initial_coords + 240;



color_index(:,:,1) = [215/255, 20/255, 64/255];
color_index(:,:,2) = [24/255, 28/255, 98/255];
color_index(:,:,3) = [200/255, 200/255, 200/255];
color_index(:,:,4) = [141/255, 205/255, 255/255];
color_index(:,:,5) = [128/255, 128/255, 128/255];
color_index(:,:,6) = [91/255, 155/255, 213/255];
color_index(:,:,7) = [255/255, 255/255, 213/255];





%% AGAINST ZERO
conditionsnames = {'Intact vs BS', 'Intact vs Occ', 'Intact vs DelSh', 'Intact vs DelFuzz', 'Intact vs Ctrl Fellow', 'Intact vs Ctrl BS', 'Intact vs Grey', ...
    'BS vs Occ', 'BS vs DelSh', 'BS vs DelFuzz', 'BS vs Ctrl Fellow', 'BS vs Ctrl BS', 'BS vs Grey', ...
    'Occ vs DelSh', 'Occ vs DelFuzz', 'Occ vs Grey', ...
    'DelSh vs DelFuzz', 'DelSh vs Ctrl Fellow', 'DelSh vs Ctrl BS', 'DelSh vs Grey', ...
    'Del Fuzz vs Grey', ...
    'Ctrl Fellow vs Ctrl BS', 'Ctrl Fellow vs Grey', ...
    'Ctrl BS vs Grey', ' ', ...
    'Intact vs Intact', 'BS vs BS', 'Occ vs Occ', 'DelSh vs DelSh', ...
    'DelFuzzy vs DelFuzzy', 'Ctrl Fellow vs Ctrl Fellow', 'Ctrl BS vs Ctrl BS', 'Grey vs Grey'};


whichexpt = 2; % 1 or 2 or 3both
roi = 9;

if whichexpt == 1
    subs = [1:13];
elseif whichexpt == 2
    subs = [14:26];
elseif whichexpt == 3
    subs = [1:26];
end

%for both expts
for eachcond = 1:33 %for intact, BS etc
        % choose which subs to use, we only want subs with no NaNs in both
        % conditions. This is important for calculating the correct means
        % for the pairwise comparison. E.g. Intact mean for IntactvsBS is
        % not the same as IntactvsOccluded because different groups of
        % Intact subs are used. nanmean(Intact) just gives the general mean
        % which is what's on the graph, but not what we use for t-test.
        % For BayesFactor we can use the overall mean as the more
        % theoretical one is fine (rather than the one we used for the
        % specific comparison in ttest due to missing data in that specific pair of conds).
        % This is what I did in beh paper.
        data_ = data_to_plot(subs,:,:); %select the correct bit of the dataset for each experiment. Tmpsubs vector is only as long as each experiment
        % eg 1 to 13, and then it doesn't work for experiment 2 because we
        % need to index 14 to 26 instead. So if we extract data(14:26) into
        % data (1:13) then can index without fear :)
        tmpsubs = ~isnan(data_to_plot(subs,eachcond,roi));
        fprintf ('%s', conditionsnames{eachcond})
        [H,P, STATS, raweffect, SE, corrected_SE] = t_test_from_zero(data_(tmpsubs,eachcond,roi));
        [lowerBound upperBound BF] = BayesFactor_Dienes(1, corrected_SE, raweffect, -6, 6, 0)
        %     lowerBound
        %     upperBound
        %     BF
end

%% Stats - Conditions against one another
conditionsnames = {'Intact vs BS', 'Intact vs Occ', 'Intact vs DelSh', 'Intact vs DelFuzz', 'Intact vs Ctrl Fellow', 'Intact vs Ctrl BS', 'Intact vs Grey', ...
    'BS vs Occ', 'BS vs DelSh', 'BS vs DelFuzz', 'BS vs Ctrl Fellow', 'BS vs Ctrl BS', 'BS vs Grey', ...
    'Occ vs DelSh', 'Occ vs DelFuzz', 'Occ vs Grey', ...
    'DelSh vs DelFuzz', 'DelSh vs Ctrl Fellow', 'DelSh vs Ctrl BS', 'DelSh vs Grey', ...
    'Del Fuzz vs Grey', ...
    'Ctrl Fellow vs Ctrl BS', 'Ctrl Fellow vs Grey', ...
    'Ctrl BS vs Grey', ' ', ...
    'Intact vs Intact', 'BS vs BS', 'Occ vs Occ', 'DelSh vs DelSh', ...
    'DelFuzzy vs DelFuzzy', 'Ctrl Fellow vs Ctrl Fellow', 'Ctrl BS vs Ctrl BS', 'Grey vs Grey'};

whichexpt =2; % 1 or 2 or 3both
roi = 9;

if whichexpt == 1
    subs = [1:13];
elseif whichexpt == 2
    subs = [14:26];
elseif whichexpt == 3
    subs = [1:26];
end

%for both expts
for eachcond = 23 %for intact, BS etc
    for eachcomparisoncond = eachcond+1:24
        % choose which subs to use, we only want subs with no NaNs in both
        % conditions. This is important for calculating the correct means
        % for the pairwise comparison. E.g. Intact mean for IntactvsBS is
        % not the same as IntactvsOccluded because different groups of
        % Intact subs are used. nanmean(Intact) just gives the general mean
        % which is what's on the graph, but not what we use for t-test.
        % For BayesFactor we can use the overall mean as the more
        % theoretical one is fine (rather than the one we used for the
        % specific comparison in ttest due to missing data in that specific pair of conds).
        % This is what I did in beh paper.
        data_ = data_to_plot(subs,:,:); %select the correct bit of the dataset for each experiment. Tmpsubs vector is only as long as each experiment
        % eg 1 to 13, and then it doesn't work for experiment 2 because we
        % need to index 14 to 26 instead. So if we extract data(14:26) into
        % data (1:13) then can index without fear :)
        tmpsubs = ~isnan(data_to_plot(subs,eachcond,roi)) & ~isnan(data_to_plot(subs,eachcomparisoncond,roi));
        disp (fprintf ('[%s] vs [%s]', conditionsnames{eachcond}, conditionsnames{eachcomparisoncond}))
        disp('')
        [mean1, mean2, H,P, STATS, raweffect, SE, corrected_SE] = t_test_pairwise(data_(tmpsubs,eachcond,roi), data_(tmpsubs,eachcomparisoncond,roi));
        [lowerBound upperBound BF] = BayesFactor_Dienes(1, corrected_SE, raweffect, -6, 6, nanmean(data_to_plot(subs,eachcond,roi)));
%         format long
        fprintf ('Mean1 = %5.4g, Mean2 = %5.4g, t(%d) = %#5.5g, p = %5.4g, B(%5.4g, %5.4g) = %5.5g \n \n', mean1, mean2, STATS.df, STATS.tstat, P, lowerBound, upperBound, BF)
%         disp('')
        %     lowerBound
        %     upperBound
        %     BF
    end
end



%% Correlate with behaviour

% VVIQ with UNIVARIATE

% VVIQ with V1 BS Centre UNIVARIATE

for i = 8
    figure; scatter(MRI_univariate.VVIQ, MRI_univariate.BS_CON_V1_all_expts(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.BS_CON_V1_all_expts(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.BS_CON_V1_all_expts(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V1 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('VVIQ')
    ylabel('Beta')
    nsubs = sum(~isnan(MRI_univariate.VVIQ) & ~isnan(MRI_univariate.BS_CON_V1_all_expts(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end

% VVIQ with V1 ACTUAL UNIVARIATE

for i = 8
    figure; scatter(MRI_univariate.VVIQ, MRI_univariate.ACTUAL_CON_V1_all_expts(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.ACTUAL_CON_V1_all_expts(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.ACTUAL_CON_V1_all_expts(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V1 Stimulus ROI r = %f, p = %f', r, p))
    xlabel('VVIQ')
    ylabel('Beta')
    nsubs = sum(~isnan(MRI_univariate.VVIQ) & ~isnan(MRI_univariate.ACTUAL_CON_V1_all_expts(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end


% VVIQ with V2 BS Centre UNIVARIATE

for i = 8
    figure; scatter(MRI_univariate.VVIQ, MRI_univariate.BS_CON_V2_all_expts(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.BS_CON_V2_all_expts(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.BS_CON_V2_all_expts(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V2 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('VVIQ')
    ylabel('Beta')
    nsubs = sum(~isnan(MRI_univariate.VVIQ) & ~isnan(MRI_univariate.BS_CON_V2_all_expts(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end

% VVIQ with V2 Stimulus UNIVARIATE

for i = 8
    figure; scatter(MRI_univariate.VVIQ, MRI_univariate.ACTUAL_CON_V2_all_expts(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.ACTUAL_CON_V2_all_expts(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.VVIQ, MRI_univariate.ACTUAL_CON_V2_all_expts(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V2 Stimulus ROI r = %f, p = %f', r, p))
    xlabel('VVIQ')
    ylabel('Beta')
    nsubs = sum(~isnan(MRI_univariate.VVIQ) & ~isnan(MRI_univariate.ACTUAL_CON_V2_all_expts(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end


% Perceptual Filling-in (bias) with UNIVARIATE

% Perceptual Filling-in (bias) with V1 BS Centre UNIVARIATE
for i = 5
    figure; scatter(MRI_univariate.Perceptual_filling_in_bias(:,i), MRI_univariate.BS_CON_V1_all_expts(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i), MRI_univariate.BS_CON_V1_all_expts(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i), MRI_univariate.BS_CON_V1_all_expts(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V1 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('Perceptual Filling-in')
    ylabel('Beta')
    nsubs = sum(~isnan(MRI_univariate.Perceptual_filling_in_bias(:,i)) & ~isnan(MRI_univariate.BS_CON_V1_all_expts(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end

% Perceptual Filling-in (bias) with V1 BS Centre UNIVARIATE
for i = 5
    figure; scatter(MRI_univariate.Perceptual_filling_in_bias(:,i), MRI_univariate.BS_CON_V2_all_expts(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i), MRI_univariate.BS_CON_V2_all_expts(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i), MRI_univariate.BS_CON_V2_all_expts(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V2 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('Perceptual Filling-in')
    ylabel('Beta')
    nsubs = sum(~isnan(MRI_univariate.Perceptual_filling_in_bias(:,i)) & ~isnan(MRI_univariate.BS_CON_V2_all_expts(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end

% VVIQ with multivariate correlation

% VVIQ with with V1 BS Centre MULTIVARIATE
for i = 7
    figure; scatter(MRI_univariate.VVIQ, MRI_multivariate.BS_CON_V1(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.VVIQ, MRI_multivariate.BS_CON_V1(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.VVIQ, MRI_multivariate.BS_CON_V1(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V1 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('VVIQ')
    ylabel('Correlation Fisher-z')
    nsubs = sum(~isnan(MRI_univariate.VVIQ) & ~isnan(MRI_multivariate.BS_CON_V1(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end

% VVIQ with with V2 BS Centre MULTIVARIATE
for i = 7
    figure; scatter(MRI_univariate.VVIQ, MRI_multivariate.BS_CON_V2(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.VVIQ, MRI_multivariate.BS_CON_V2(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.VVIQ, MRI_multivariate.BS_CON_V2(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V2 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('VVIQ')
    ylabel('Correlation Fisher-z')
    nsubs = sum(~isnan(MRI_univariate.VVIQ) & ~isnan(MRI_multivariate.BS_CON_V2(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end

% Perceptual filling-in (bias) with V1 BS Center multivariate correlation
for i = 4
    figure; scatter(MRI_univariate.Perceptual_filling_in_bias(:,i+1), MRI_multivariate.BS_CON_V1(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i+1), MRI_multivariate.BS_CON_V1(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i+1), MRI_multivariate.BS_CON_V1(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V1 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('Perceptual filling-in')
    ylabel('Correlation Fisher-z')
    nsubs = sum(~isnan(MRI_univariate.Perceptual_filling_in_bias(:,i+1)) & ~isnan(MRI_multivariate.BS_CON_V1(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end

% Perceptual filling-in (bias) with V2 BS Center multivariate correlation
for i = 4
    figure; scatter(MRI_univariate.Perceptual_filling_in_bias(:,i+1), MRI_multivariate.BS_CON_V2(:,i), 'ko', 'MarkerFaceColor', 'y'); lsline; 
    fprintf('Spearman'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i+1), MRI_multivariate.BS_CON_V2(:,i), 'Type', 'Spearman', 'rows', 'complete')
    fprintf('Pearson'); [r, p] = corr(MRI_univariate.Perceptual_filling_in_bias(:,i+1), MRI_multivariate.BS_CON_V2(:,i), 'Type', 'Pearson', 'rows', 'complete')
    title(sprintf('V2 BS Centre ROI r = %f, p = %f', r, p))
    xlabel('Perceptual filling-in')
    ylabel('Correlation Fisher-z')
    nsubs = sum(~isnan(MRI_univariate.Perceptual_filling_in_bias(:,i+1)) & ~isnan(MRI_multivariate.BS_CON_V2(:,i)))
    SE = 1/sqrt(nsubs-3)
    zscore = fisherztransform(r)
end


%%

%%% from baseline
disp ('Intact/BS BS con from zero')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_multivariate.BS_con(:,1))
[H,P, ~,STATS] = ttest(MRI_multivariate.BS_con(:,1))
%for bayes
raweffect = mean(mean(MRI_multivariate.BS_con(:,1) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%% from baseline
disp ('Intact/Occ BS con from zero')
% mean(MRI_univariate.BS_lib(:,1))
mean(MRI_multivariate.BS_con(:,2))
[H,P, ~,STATS] = ttest(MRI_multivariate.BS_con(:,2))
%for bayes
raweffect = mean(mean(MRI_multivariate.BS_con(:,2) - 0))
SE = raweffect/STATS.tstat
corrected_SE = SE*(1 + 20/(STATS.df*STATS.df)) %for small sample sizes <30

%%% from baseline
disp ('Intact/DelSh BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,3))

%%% from baseline
disp ('Intact/DelFuzz BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,4))

%%% from baseline
disp ('Intact/Grey BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,5))


%%% from baseline
disp ('BS/Occ BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,6))

%%% from baseline
disp ('BS/DelSh BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,7))

%%% from baseline
disp ('BS/DelFuzz BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,8))


%%% from baseline
disp ('BS/Grey BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,9))


%%% from baseline
disp ('Occ/DelSh BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,10))


%%% from baseline
disp ('Occ/DelFuzz BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,11))


%%% from baseline
disp ('Occ/Grey BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,12))

%%% from baseline
disp ('DelSh/DelFuzz BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,13))

%%% from baseline
disp ('DelSh/Grey BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,14))


%%% from baseline
disp ('DelFuzz/Grey BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,15))


%%% from baseline
disp ('Intact BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,17))

%%% from baseline
disp ('BS BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,18))

%%% from baseline
disp ('Occ BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,19))

%%% from baseline
disp ('DelSh BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,20))

%%% from baseline
disp ('DelFuzz BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,21))

%%% from baseline
disp ('Grey BS con from zero')
t_test_from_zero(MRI_multivariate.BS_con(:,22))


%%%% Actual con

%%% from baseline
disp ('Intact/BS Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,1))

%%% from baseline
disp ('Intact/Occ Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,2))

%%% from baseline
disp ('Intact/DelSh Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,3))

%%% from baseline
disp ('Intact/DelFuzz Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,4))

%%% from baseline
disp ('Intact/Grey Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,5))

%%% from baseline
disp ('BS/Occ Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,6))

%%% from baseline
disp ('BS/DelSh Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,7))

%%% from baseline
disp ('BS/DelFuzz Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,8))

%%% from baseline
disp ('BS/Grey Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,9))

%%% from baseline
disp ('Occ/DelSh Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,10))

%%% from baseline
disp ('Occ/DelFuzz Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,11))

%%% from baseline
disp ('Occ/Grey Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,12))

%%% from baseline
disp ('DelSh/DelFuzz Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,13))

%%% from baseline
disp ('DelSh/Grey Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,14))

%%% from baseline
disp ('DelFuzz/Grey Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,15))


%%% from baseline
disp ('Intact Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,17))

%%% from baseline
disp ('BS Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,18))

%%% from baseline
disp ('Occ Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,19))

%%% from baseline
disp ('DelSh Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,20))

%%% from baseline
disp ('DelFuzz Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,21))

%%% from baseline
disp ('Grey Actual con from zero')
t_test_from_zero(MRI_multivariate.Actual_con(:,22))



%%% V1 around stim

%%% from baseline
disp ('Intact/BS V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,1))

%%% from baseline
disp ('Intact/Occ V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,2))

%%% from baseline
disp ('Intact/DelSh V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,3))

%%% from baseline
disp ('Intact/DelFuzz V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,4))

%%% from baseline
disp ('Intact/Grey V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,5))

%%% from baseline
disp ('BS/Occ V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,6))

%%% from baseline
disp ('BS/DelSh V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,7))

%%% from baseline
disp ('BS/DelFuzz V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,8))

%%% from baseline
disp ('BS/Grey V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,9))

%%% from baseline
disp ('Occ/DelSh V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,10))

%%% from baseline
disp ('Occ/DelFuzz V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,11))

%%% from baseline
disp ('Occ/Grey V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,12))

%%% from baseline
disp ('DelSh/DelFuzz V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,13))

%%% from baseline
disp ('DelSh/Grey V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,14))

%%% from baseline
disp ('DelFuzz/Grey V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,15))


%%% from baseline
disp ('Intact V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,17))

%%% from baseline
disp ('BS V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,18))

%%% from baseline
disp ('Occ V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,19))

%%% from baseline
disp ('DelSh V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,20))

%%% from baseline
disp ('DelFuzz V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,21))

%%% from baseline
disp ('Grey V1 around stim from zero')
t_test_from_zero(MRI_multivariate.V1(:,22))





%%% V2 BS

%%% from baseline
disp ('Intact/BS V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,1))

%%% from baseline
disp ('Intact/Occ V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,2))

%%% from baseline
disp ('Intact/DelSh V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,3))

%%% from baseline
disp ('Intact/DelFuzz V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,4))

%%% from baseline
disp ('Intact/Grey V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,5))

%%% from baseline
disp ('BS/Occ V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,6))

%%% from baseline
disp ('BS/DelSh V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,7))

%%% from baseline
disp ('BS/DelFuzz V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,8))

%%% from baseline
disp ('BS/Grey V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,9))

%%% from baseline
disp ('Occ/DelSh V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,10))

%%% from baseline
disp ('Occ/DelFuzz V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,11))

%%% from baseline
disp ('Occ/Grey V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,12))

%%% from baseline
disp ('DelSh/DelFuzz V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,13))

%%% from baseline
disp ('DelSh/Grey V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,14))

%%% from baseline
disp ('DelFuzz/Grey V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,15))


%%% from baseline
disp ('Intact V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,17))

%%% from baseline
disp ('BS V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,18))

%%% from baseline
disp ('Occ V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,19))

%%% from baseline
disp ('DelSh V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,20))

%%% from baseline
disp ('DelFuzz V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,21))

%%% from baseline
disp ('Grey V2 from zero')
t_test_from_zero(MRI_multivariate.V2_BS_con(:,22))



%%% PAIRWISE COMPARISONS

%%% BS_CON
disp ('Intact/BS vs Intact/Occ')
t_test_pairwise(MRI_multivariate.BS_con(:,1), MRI_multivariate.BS_con(:,2))

disp ('Intact/BS vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.BS_con(:,1), MRI_multivariate.BS_con(:,3))

disp ('Intact/BS vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,1), MRI_multivariate.BS_con(:,4))

disp ('Intact/BS vs Intact/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,1), MRI_multivariate.BS_con(:,5))

%~~~~~~~~~~~~~~
disp ('Intact/Occ vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.BS_con(:,2), MRI_multivariate.BS_con(:,3))

disp ('Intact/Occ vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,2), MRI_multivariate.BS_con(:,4))

disp ('Intact/Occ vs Intact/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,2), MRI_multivariate.BS_con(:,5))

%~~~~~~~~~~~~~~~

disp ('Intact/DelSh vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,3), MRI_multivariate.BS_con(:,4))

disp ('Intact/DelSh vs Intact/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,3), MRI_multivariate.BS_con(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~

disp ('Intact/DelFuzz vs Intact/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,4), MRI_multivariate.BS_con(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('BS/Occ vs BS/Delsh')
t_test_pairwise(MRI_multivariate.BS_con(:,6), MRI_multivariate.BS_con(:,7))

disp ('BS/Occ vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,6), MRI_multivariate.BS_con(:,8))

disp ('BS/Occ vs BS/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,6), MRI_multivariate.BS_con(:,9))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('BS/DelSh vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,7), MRI_multivariate.BS_con(:,8))

disp ('BS/DelSh vs BS/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,7), MRI_multivariate.BS_con(:,9))

%~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzz vs BS/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,8), MRI_multivariate.BS_con(:,9))


%~~~~~~~~~~~~~~~~~
disp ('Intact/Occ vs BS/Occ')
t_test_pairwise(MRI_multivariate.BS_con(:,2), MRI_multivariate.BS_con(:,6))

disp ('Intact/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.BS_con(:,2), MRI_multivariate.BS_con(:,10))

disp ('Intact/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,2), MRI_multivariate.BS_con(:,11))

disp ('Intact/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,2), MRI_multivariate.BS_con(:,12))

%~~~~~~~~~~~~~~~~~
disp ('BS/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.BS_con(:,6), MRI_multivariate.BS_con(:,10))

disp ('BS/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,6), MRI_multivariate.BS_con(:,11))

disp ('BS/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,6), MRI_multivariate.BS_con(:,12))


%~~~~~~~~~~~~~~~~~
disp ('occ/delsh vs Occ/delfuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,10), MRI_multivariate.BS_con(:,11))

disp ('Occ/delsh vs Occ/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,10), MRI_multivariate.BS_con(:,12))

disp ('occ/delfuzz vs Occ/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,11), MRI_multivariate.BS_con(:,12))



%~~~~~~~~~~~~~~~~~
disp ('Intact/delsh vs BS/delsh')
t_test_pairwise(MRI_multivariate.BS_con(:,3), MRI_multivariate.BS_con(:,7))

disp ('Intact/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.BS_con(:,3), MRI_multivariate.BS_con(:,10))

disp ('intact/delsh vs delsh/delfuzz')
t_test_pairwise(MRI_multivariate.BS_con(:,3), MRI_multivariate.BS_con(:,13))

disp ('intact/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,3), MRI_multivariate.BS_con(:,14))



%~~~~~~~~~~~~~~~~~
disp ('BS/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.BS_con(:,7), MRI_multivariate.BS_con(:,10))

disp ('BS/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,7), MRI_multivariate.BS_con(:,13))

disp ('BS/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,7), MRI_multivariate.BS_con(:,14))

%~~~~~~~~~~~~~~~~~
disp ('Occ/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,10), MRI_multivariate.BS_con(:,13))

disp ('Occ/delsh vs DelSh/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,10), MRI_multivariate.BS_con(:,14))

disp ('delsh/delfuzzy vs delsh/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,13), MRI_multivariate.BS_con(:,14))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/DelFuzzy vs BS/DelFuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,4), MRI_multivariate.BS_con(:,8))

disp ('Intact/DelFuzzy vs occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,4), MRI_multivariate.BS_con(:,11))

disp ('Intact/delfuzzy vs delsh/delfuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,4), MRI_multivariate.BS_con(:,13))

disp ('Intact/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,4), MRI_multivariate.BS_con(:,15))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzzy vs Occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,8), MRI_multivariate.BS_con(:,11))

disp ('BS/DelFuzzy vs delsh/DelFuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,8), MRI_multivariate.BS_con(:,13))

disp ('BS/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,8), MRI_multivariate.BS_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/DelFuzzy vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.BS_con(:,11), MRI_multivariate.BS_con(:,13))

disp ('Occ/DelFuzzy vs Delfuzzy/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,11), MRI_multivariate.BS_con(:,15))

disp ('delsh/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,13), MRI_multivariate.BS_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/Grey vs BS/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,5), MRI_multivariate.BS_con(:,9))

disp ('Intact/Grey vs Occ/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,5), MRI_multivariate.BS_con(:,12))

disp ('Intact/Grey vs DelSh/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,5), MRI_multivariate.BS_con(:,14))

disp ('Intact/Grey vs DelFuzzy/grey')
t_test_pairwise(MRI_multivariate.BS_con(:,5), MRI_multivariate.BS_con(:,15))

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/Grey vs Occ/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,9), MRI_multivariate.BS_con(:,12))

disp ('BS/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,9), MRI_multivariate.BS_con(:,14))

disp ('BS/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,9), MRI_multivariate.BS_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,12), MRI_multivariate.BS_con(:,14))

disp ('Occ/Grey vs Delfuzzy/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,12), MRI_multivariate.BS_con(:,15))

disp ('Delsh/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.BS_con(:,14), MRI_multivariate.BS_con(:,15))





%% PAIRWISE
%%% ACTUAL_CON
disp ('Intact/BS vs Intact/Occ')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,2))

disp ('Intact/BS vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,3))

disp ('Intact/BS vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,4))

disp ('Intact/BS vs Intact/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,5))

%~~~~~~~~~~~~~~
disp ('Intact/Occ vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.Actual_con(:,2), MRI_multivariate.Actual_con(:,3))

disp ('Intact/Occ vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,2), MRI_multivariate.Actual_con(:,4))

disp ('Intact/Occ vs Intact/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,2), MRI_multivariate.Actual_con(:,5))

%~~~~~~~~~~~~~~~

disp ('Intact/DelSh vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,3), MRI_multivariate.Actual_con(:,4))

disp ('Intact/DelSh vs Intact/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,3), MRI_multivariate.Actual_con(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~

disp ('Intact/DelFuzz vs Intact/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,4), MRI_multivariate.Actual_con(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('Intact/BS vs BS/Occ')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,6))

disp ('Intact/BS vs BS/DelSh')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,7))

disp ('Intact/BS vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,8))

disp ('Intact/BS vs BS/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,1), MRI_multivariate.Actual_con(:,9))



%~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/Occ vs BS/Delsh')
t_test_pairwise(MRI_multivariate.Actual_con(:,6), MRI_multivariate.Actual_con(:,7))

disp ('BS/Occ vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,6), MRI_multivariate.Actual_con(:,8))

disp ('BS/Occ vs BS/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,6), MRI_multivariate.Actual_con(:,9))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('BS/DelSh vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,7), MRI_multivariate.Actual_con(:,8))

disp ('BS/DelSh vs BS/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,7), MRI_multivariate.Actual_con(:,9))

%~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzz vs BS/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,8), MRI_multivariate.Actual_con(:,9))


%~~~~~~~~~~~~~~~~~
disp ('Intact/Occ vs BS/Occ')
t_test_pairwise(MRI_multivariate.Actual_con(:,2), MRI_multivariate.Actual_con(:,6))

disp ('Intact/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.Actual_con(:,2), MRI_multivariate.Actual_con(:,10))

disp ('Intact/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,2), MRI_multivariate.Actual_con(:,11))

disp ('Intact/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,2), MRI_multivariate.Actual_con(:,12))

%~~~~~~~~~~~~~~~~~
disp ('BS/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.Actual_con(:,6), MRI_multivariate.Actual_con(:,10))

disp ('BS/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,6), MRI_multivariate.Actual_con(:,11))

disp ('BS/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,6), MRI_multivariate.Actual_con(:,12))


%~~~~~~~~~~~~~~~~~
disp ('occ/delsh vs Occ/delfuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,10), MRI_multivariate.Actual_con(:,11))

disp ('Occ/delsh vs Occ/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,10), MRI_multivariate.Actual_con(:,12))

disp ('occ/delfuzz vs Occ/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,11), MRI_multivariate.Actual_con(:,12))



%~~~~~~~~~~~~~~~~~
disp ('Intact/delsh vs BS/delsh')
t_test_pairwise(MRI_multivariate.Actual_con(:,3), MRI_multivariate.Actual_con(:,7))

disp ('Intact/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.Actual_con(:,3), MRI_multivariate.Actual_con(:,10))

disp ('intact/delsh vs delsh/delfuzz')
t_test_pairwise(MRI_multivariate.Actual_con(:,3), MRI_multivariate.Actual_con(:,13))

disp ('intact/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,3), MRI_multivariate.Actual_con(:,14))



%~~~~~~~~~~~~~~~~~
disp ('BS/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.Actual_con(:,7), MRI_multivariate.Actual_con(:,10))

disp ('BS/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,7), MRI_multivariate.Actual_con(:,13))

disp ('BS/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,7), MRI_multivariate.Actual_con(:,14))

%~~~~~~~~~~~~~~~~~
disp ('Occ/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,10), MRI_multivariate.Actual_con(:,13))

disp ('Occ/delsh vs DelSh/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,10), MRI_multivariate.Actual_con(:,14))

disp ('delsh/delfuzzy vs delsh/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,13), MRI_multivariate.Actual_con(:,14))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/DelFuzzy vs BS/DelFuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,4), MRI_multivariate.Actual_con(:,8))

disp ('Intact/DelFuzzy vs occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,4), MRI_multivariate.Actual_con(:,11))

disp ('Intact/delfuzzy vs delsh/delfuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,4), MRI_multivariate.Actual_con(:,13))

disp ('Intact/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,4), MRI_multivariate.Actual_con(:,15))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzzy vs Occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,8), MRI_multivariate.Actual_con(:,11))

disp ('BS/DelFuzzy vs delsh/DelFuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,8), MRI_multivariate.Actual_con(:,13))

disp ('BS/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,8), MRI_multivariate.Actual_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/DelFuzzy vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.Actual_con(:,11), MRI_multivariate.Actual_con(:,13))

disp ('Occ/DelFuzzy vs Delfuzzy/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,11), MRI_multivariate.Actual_con(:,15))

disp ('delsh/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,13), MRI_multivariate.Actual_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/Grey vs BS/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,5), MRI_multivariate.Actual_con(:,9))

disp ('Intact/Grey vs Occ/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,5), MRI_multivariate.Actual_con(:,12))

disp ('Intact/Grey vs DelSh/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,5), MRI_multivariate.Actual_con(:,14))

disp ('Intact/Grey vs DelFuzzy/grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,5), MRI_multivariate.Actual_con(:,15))

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/Grey vs Occ/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,9), MRI_multivariate.Actual_con(:,12))

disp ('BS/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,9), MRI_multivariate.Actual_con(:,14))

disp ('BS/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,9), MRI_multivariate.Actual_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,12), MRI_multivariate.Actual_con(:,14))

disp ('Occ/Grey vs Delfuzzy/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,12), MRI_multivariate.Actual_con(:,15))

disp ('Delsh/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.Actual_con(:,14), MRI_multivariate.Actual_con(:,15))



%% PAIRWISE
%%% V1 around stim
disp ('Intact/BS vs Intact/Occ')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,2))

disp ('Intact/BS vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,3))

disp ('Intact/BS vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,4))

disp ('Intact/BS vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,5))

%~~~~~~~~~~~~~~
disp ('Intact/Occ vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.V1(:,2), MRI_multivariate.V1(:,3))

disp ('Intact/Occ vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,2), MRI_multivariate.V1(:,4))

disp ('Intact/Occ vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V1(:,2), MRI_multivariate.V1(:,5))

%~~~~~~~~~~~~~~~

disp ('Intact/DelSh vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,3), MRI_multivariate.V1(:,4))

disp ('Intact/DelSh vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V1(:,3), MRI_multivariate.V1(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~

disp ('Intact/DelFuzz vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V1(:,4), MRI_multivariate.V1(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('Intact/BS vs BS/Occ')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,6))

disp ('Intact/BS vs BS/DelSh')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,7))

disp ('Intact/BS vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,8))

disp ('Intact/BS vs BS/Grey')
t_test_pairwise(MRI_multivariate.V1(:,1), MRI_multivariate.V1(:,9))



%~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/Occ vs BS/Delsh')
t_test_pairwise(MRI_multivariate.V1(:,6), MRI_multivariate.V1(:,7))

disp ('BS/Occ vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,6), MRI_multivariate.V1(:,8))

disp ('BS/Occ vs BS/Grey')
t_test_pairwise(MRI_multivariate.V1(:,6), MRI_multivariate.V1(:,9))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('BS/DelSh vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,7), MRI_multivariate.V1(:,8))

disp ('BS/DelSh vs BS/Grey')
t_test_pairwise(MRI_multivariate.V1(:,7), MRI_multivariate.V1(:,9))

%~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzz vs BS/Grey')
t_test_pairwise(MRI_multivariate.V1(:,8), MRI_multivariate.V1(:,9))


%~~~~~~~~~~~~~~~~~
disp ('Intact/Occ vs BS/Occ')
t_test_pairwise(MRI_multivariate.V1(:,2), MRI_multivariate.V1(:,6))

disp ('Intact/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.V1(:,2), MRI_multivariate.V1(:,10))

disp ('Intact/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,2), MRI_multivariate.V1(:,11))

disp ('Intact/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V1(:,2), MRI_multivariate.V1(:,12))

%~~~~~~~~~~~~~~~~~
disp ('BS/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.V1(:,6), MRI_multivariate.V1(:,10))

disp ('BS/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.V1(:,6), MRI_multivariate.V1(:,11))

disp ('BS/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V1(:,6), MRI_multivariate.V1(:,12))


%~~~~~~~~~~~~~~~~~
disp ('occ/delsh vs Occ/delfuzz')
t_test_pairwise(MRI_multivariate.V1(:,10), MRI_multivariate.V1(:,11))

disp ('Occ/delsh vs Occ/grey')
t_test_pairwise(MRI_multivariate.V1(:,10), MRI_multivariate.V1(:,12))

disp ('occ/delfuzz vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V1(:,11), MRI_multivariate.V1(:,12))



%~~~~~~~~~~~~~~~~~
disp ('Intact/delsh vs BS/delsh')
t_test_pairwise(MRI_multivariate.V1(:,3), MRI_multivariate.V1(:,7))

disp ('Intact/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.V1(:,3), MRI_multivariate.V1(:,10))

disp ('intact/delsh vs delsh/delfuzz')
t_test_pairwise(MRI_multivariate.V1(:,3), MRI_multivariate.V1(:,13))

disp ('intact/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.V1(:,3), MRI_multivariate.V1(:,14))



%~~~~~~~~~~~~~~~~~
disp ('BS/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.V1(:,7), MRI_multivariate.V1(:,10))

disp ('BS/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V1(:,7), MRI_multivariate.V1(:,13))

disp ('BS/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.V1(:,7), MRI_multivariate.V1(:,14))

%~~~~~~~~~~~~~~~~~
disp ('Occ/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V1(:,10), MRI_multivariate.V1(:,13))

disp ('Occ/delsh vs DelSh/grey')
t_test_pairwise(MRI_multivariate.V1(:,10), MRI_multivariate.V1(:,14))

disp ('delsh/delfuzzy vs delsh/grey')
t_test_pairwise(MRI_multivariate.V1(:,13), MRI_multivariate.V1(:,14))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/DelFuzzy vs BS/DelFuzzy')
t_test_pairwise(MRI_multivariate.V1(:,4), MRI_multivariate.V1(:,8))

disp ('Intact/DelFuzzy vs occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.V1(:,4), MRI_multivariate.V1(:,11))

disp ('Intact/delfuzzy vs delsh/delfuzzy')
t_test_pairwise(MRI_multivariate.V1(:,4), MRI_multivariate.V1(:,13))

disp ('Intact/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V1(:,4), MRI_multivariate.V1(:,15))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzzy vs Occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.V1(:,8), MRI_multivariate.V1(:,11))

disp ('BS/DelFuzzy vs delsh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V1(:,8), MRI_multivariate.V1(:,13))

disp ('BS/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V1(:,8), MRI_multivariate.V1(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/DelFuzzy vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V1(:,11), MRI_multivariate.V1(:,13))

disp ('Occ/DelFuzzy vs Delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V1(:,11), MRI_multivariate.V1(:,15))

disp ('delsh/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V1(:,13), MRI_multivariate.V1(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/Grey vs BS/Grey')
t_test_pairwise(MRI_multivariate.V1(:,5), MRI_multivariate.V1(:,9))

disp ('Intact/Grey vs Occ/grey')
t_test_pairwise(MRI_multivariate.V1(:,5), MRI_multivariate.V1(:,12))

disp ('Intact/Grey vs DelSh/grey')
t_test_pairwise(MRI_multivariate.V1(:,5), MRI_multivariate.V1(:,14))

disp ('Intact/Grey vs DelFuzzy/grey')
t_test_pairwise(MRI_multivariate.V1(:,5), MRI_multivariate.V1(:,15))

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/Grey vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V1(:,9), MRI_multivariate.V1(:,12))

disp ('BS/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.V1(:,9), MRI_multivariate.V1(:,14))

disp ('BS/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.V1(:,9), MRI_multivariate.V1(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.V1(:,12), MRI_multivariate.V1(:,14))

disp ('Occ/Grey vs Delfuzzy/Grey')
t_test_pairwise(MRI_multivariate.V1(:,12), MRI_multivariate.V1(:,15))

disp ('Delsh/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.V1(:,14), MRI_multivariate.V1(:,15))



%% PAIRWISE
%%% V2 BS
disp ('Intact/BS vs Intact/Occ')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,2))

disp ('Intact/BS vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,3))

disp ('Intact/BS vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,4))

disp ('Intact/BS vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,5))

%~~~~~~~~~~~~~~
disp ('Intact/Occ vs Intact/DelSh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,2), MRI_multivariate.V2_BS_con(:,3))

disp ('Intact/Occ vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,2), MRI_multivariate.V2_BS_con(:,4))

disp ('Intact/Occ vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,2), MRI_multivariate.V2_BS_con(:,5))

%~~~~~~~~~~~~~~~

disp ('Intact/DelSh vs Intact/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,3), MRI_multivariate.V2_BS_con(:,4))

disp ('Intact/DelSh vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,3), MRI_multivariate.V2_BS_con(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~

disp ('Intact/DelFuzz vs Intact/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,4), MRI_multivariate.V2_BS_con(:,5))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('Intact/BS vs BS/Occ')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,6))

disp ('Intact/BS vs BS/DelSh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,7))

disp ('Intact/BS vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,8))

disp ('Intact/BS vs BS/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,1), MRI_multivariate.V2_BS_con(:,9))



%~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/Occ vs BS/Delsh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,6), MRI_multivariate.V2_BS_con(:,7))

disp ('BS/Occ vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,6), MRI_multivariate.V2_BS_con(:,8))

disp ('BS/Occ vs BS/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,6), MRI_multivariate.V2_BS_con(:,9))

%~~~~~~~~~~~~~~~~~~~~~~~~~

disp ('BS/DelSh vs BS/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,7), MRI_multivariate.V2_BS_con(:,8))

disp ('BS/DelSh vs BS/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,7), MRI_multivariate.V2_BS_con(:,9))

%~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzz vs BS/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,8), MRI_multivariate.V2_BS_con(:,9))


%~~~~~~~~~~~~~~~~~
disp ('Intact/Occ vs BS/Occ')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,2), MRI_multivariate.V2_BS_con(:,6))

disp ('Intact/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,2), MRI_multivariate.V2_BS_con(:,10))

disp ('Intact/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,2), MRI_multivariate.V2_BS_con(:,11))

disp ('Intact/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,2), MRI_multivariate.V2_BS_con(:,12))

%~~~~~~~~~~~~~~~~~
disp ('BS/Occ vs Occ/DelSh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,6), MRI_multivariate.V2_BS_con(:,10))

disp ('BS/Occ vs Occ/DelFuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,6), MRI_multivariate.V2_BS_con(:,11))

disp ('BS/Occ vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,6), MRI_multivariate.V2_BS_con(:,12))


%~~~~~~~~~~~~~~~~~
disp ('occ/delsh vs Occ/delfuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,10), MRI_multivariate.V2_BS_con(:,11))

disp ('Occ/delsh vs Occ/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,10), MRI_multivariate.V2_BS_con(:,12))

disp ('occ/delfuzz vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,11), MRI_multivariate.V2_BS_con(:,12))



%~~~~~~~~~~~~~~~~~
disp ('Intact/delsh vs BS/delsh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,3), MRI_multivariate.V2_BS_con(:,7))

disp ('Intact/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,3), MRI_multivariate.V2_BS_con(:,10))

disp ('intact/delsh vs delsh/delfuzz')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,3), MRI_multivariate.V2_BS_con(:,13))

disp ('intact/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,3), MRI_multivariate.V2_BS_con(:,14))



%~~~~~~~~~~~~~~~~~
disp ('BS/delsh vs Occ/delsh')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,7), MRI_multivariate.V2_BS_con(:,10))

disp ('BS/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,7), MRI_multivariate.V2_BS_con(:,13))

disp ('BS/delsh vs delsh/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,7), MRI_multivariate.V2_BS_con(:,14))

%~~~~~~~~~~~~~~~~~
disp ('Occ/delsh vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,10), MRI_multivariate.V2_BS_con(:,13))

disp ('Occ/delsh vs DelSh/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,10), MRI_multivariate.V2_BS_con(:,14))

disp ('delsh/delfuzzy vs delsh/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,13), MRI_multivariate.V2_BS_con(:,14))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/DelFuzzy vs BS/DelFuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,4), MRI_multivariate.V2_BS_con(:,8))

disp ('Intact/DelFuzzy vs occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,4), MRI_multivariate.V2_BS_con(:,11))

disp ('Intact/delfuzzy vs delsh/delfuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,4), MRI_multivariate.V2_BS_con(:,13))

disp ('Intact/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,4), MRI_multivariate.V2_BS_con(:,15))


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/DelFuzzy vs Occ/DelFuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,8), MRI_multivariate.V2_BS_con(:,11))

disp ('BS/DelFuzzy vs delsh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,8), MRI_multivariate.V2_BS_con(:,13))

disp ('BS/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,8), MRI_multivariate.V2_BS_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/DelFuzzy vs DelSh/DelFuzzy')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,11), MRI_multivariate.V2_BS_con(:,13))

disp ('Occ/DelFuzzy vs Delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,11), MRI_multivariate.V2_BS_con(:,15))

disp ('delsh/delfuzzy vs delfuzzy/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,13), MRI_multivariate.V2_BS_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Intact/Grey vs BS/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,5), MRI_multivariate.V2_BS_con(:,9))

disp ('Intact/Grey vs Occ/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,5), MRI_multivariate.V2_BS_con(:,12))

disp ('Intact/Grey vs DelSh/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,5), MRI_multivariate.V2_BS_con(:,14))

disp ('Intact/Grey vs DelFuzzy/grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,5), MRI_multivariate.V2_BS_con(:,15))

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('BS/Grey vs Occ/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,9), MRI_multivariate.V2_BS_con(:,12))

disp ('BS/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,9), MRI_multivariate.V2_BS_con(:,14))

disp ('BS/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,9), MRI_multivariate.V2_BS_con(:,15))



%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
disp ('Occ/Grey vs DelSh/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,12), MRI_multivariate.V2_BS_con(:,14))

disp ('Occ/Grey vs Delfuzzy/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,12), MRI_multivariate.V2_BS_con(:,15))

disp ('Delsh/Grey vs DelFuzzy/Grey')
t_test_pairwise(MRI_multivariate.V2_BS_con(:,14), MRI_multivariate.V2_BS_con(:,15))
