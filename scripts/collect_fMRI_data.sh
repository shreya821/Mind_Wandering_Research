#!/bin/bash

if [ -f fmri_data.tsv ]
then
	rm fmri_data.tsv
fi

{
	echo -n -e "Subject ID\t"
	for i in `seq 1 184`
	do
		echo -n -e "${i}\t"

	done
	echo
} > fmri_data.tsv

for id in `cat ctrl_subject_ids.txt`
do
	if [ -d sub-${id}/sub-${id}_stopsignal.feat ]
	then
		echo -n -e "${id}\t" >> fmri_data.tsv
		cd "sub-${id}/sub-${id}_stopsignal.feat"

		fslmeants \
		-i ./filtered_func_to_standard.nii.gz \
		-m ../../mPFC+PCC_DMN_mask.nii.gz --transpose \
		> dmn_data_sub-${id}.txt

		cd ../..

		sed "s/ \+/\t/g" \
		./sub-${id}/sub-${id}_stopsignal.feat/dmn_data_sub-${id}.txt \
		| tr -d '\n' \
		>> fmri_data.tsv

		echo >> fmri_data.tsv

	fi
done

rm ./sub-1????/sub-1????_stopsignal.feat/dmn_data*.txt
