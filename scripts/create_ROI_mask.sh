#!/bin/bash

# Step 1

fslmaths $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz -mul 0 -add 1 \
-roi 50 1 90 1 34 1 0 1 point_ROI1.nii.gz -odt float

fslmaths $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz -mul 0 -add 1 \
-roi 40 1 90 1 33 1 0 1 point_ROI2.nii.gz -odt float

fslmaths $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz -mul 0 -add 1 \
-roi 50 1 88 1 46 1 0 1 point_ROI3.nii.gz -odt float

fslmaths $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz -mul 0 -add 1 \
-roi 40 1 88 1 46 1 0 1 point_ROI4.nii.gz -odt float

fslmaths $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz -mul 0 -add 1 \
-roi 48 1 38 1 54 1 0 1 point_ROI5.nii.gz -odt float

fslmaths $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz -mul 0 -add 1 \
-roi 42 1 38 1 53 1 0 1 point_ROI6.nii.gz -odt float

# Step 2

fslmaths point_ROI1.nii.gz -kernel sphere 6 -fmean sphere_ROI1.nii.gz -odt float

fslmaths point_ROI2.nii.gz -kernel sphere 6 -fmean sphere_ROI2.nii.gz -odt float

fslmaths point_ROI3.nii.gz -kernel sphere 6 -fmean sphere_ROI3.nii.gz -odt float

fslmaths point_ROI4.nii.gz -kernel sphere 6 -fmean sphere_ROI4.nii.gz -odt float

fslmaths point_ROI5.nii.gz -kernel sphere 6 -fmean sphere_ROI5.nii.gz -odt float

fslmaths point_ROI6.nii.gz -kernel sphere 6 -fmean sphere_ROI6.nii.gz -odt float

# Step 3

fslmaths sphere_ROI1.nii.gz -bin sphere_ROI1_bin.nii.gz

fslmaths sphere_ROI2.nii.gz -bin sphere_ROI2_bin.nii.gz

fslmaths sphere_ROI3.nii.gz -bin sphere_ROI3_bin.nii.gz

fslmaths sphere_ROI4.nii.gz -bin sphere_ROI4_bin.nii.gz

fslmaths sphere_ROI5.nii.gz -bin sphere_ROI5_bin.nii.gz

fslmaths sphere_ROI6.nii.gz -bin sphere_ROI6_bin.nii.gz

# Step 4

fslmaths sphere_ROI1_bin.nii.gz \
-add sphere_ROI2_bin.nii.gz \
-add sphere_ROI3_bin.nii.gz \
-add sphere_ROI4_bin.nii.gz \
-add sphere_ROI5_bin.nii.gz \
-add sphere_ROI6_bin.nii.gz \
-bin mPFC+PCC_DMN_mask.nii.gz


# Step 5

rm point_ROI?.nii.gz
rm sphere_ROI?.nii.gz
rm sphere_ROI?_bin.nii.gz
