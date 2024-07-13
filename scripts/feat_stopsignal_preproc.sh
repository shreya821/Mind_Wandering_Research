#!/bin/bash

for id in `cat ctrl_subject_ids.txt`
do
	subject="sub-${id}"
	if [ -d ${subject} ]
	then
		echo "Preprocessing of ${subject} started."

		cd "${subject}/anat"
		if [ ! -f ${subject}_T1w_brain_f02.nii.gz ]
		then
			echo "Skull-stripped brain not found. USing BET with a fractional intensity of 0.2."
			bet2 ${subject}_T1w.nii.gz ${subject}_T1w_brain_f02.nii.gz -f 0.2 || echo "Problem occured during skull-stripping for ${subject}."
		fi

		cd ..
		cp ../stopsignal_preproc.fsf .

		sed -i "s/sub-10217/"${subject}"/g" stopsignal_preproc.fsf
		feat stopsignal_preproc.fsf

		echo "Preprocessing of SST fMRI of ${subject} completed."
		cd ..
		echo
	fi

done
