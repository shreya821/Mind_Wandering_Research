#!/bin/bash

for id in `cat ctrl_subject_ids.txt`
do
	subject="sub-${id}"
	if [ -d ${subject} ]
	then
		cd "${subject}/${subject}_stopsignal.feat"
		if [ ! -f filtered_func_to_standard.nii.gz ]
		then

			$FSLDIR/bin/flirt -in filtered_func_data.nii.gz \
			-ref $FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz \
			-out filtered_func_to_standard.nii.gz \
			-applyxfm -init ./reg/example_func2standard.mat \
			&& \
			echo "Filtered functional data was correctly mapped into standard space for ${subject}."
		fi
		cd ../..
	fi
done


