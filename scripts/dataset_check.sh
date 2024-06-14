#!bin/bash

for id in `cat subject_ids.txt`
do
	if [ ! -d sub-$id ]; then
		echo "sub-$id data was not downloaded."
	else
		cd "sub-$id"
		
		if [ ! -d func ]; then
			echo "sub-$id has missing func directory."
		else 
			cd func

			if [ ! -f sub-$id\_task-stopsignal_bold.nii.gz ]; then
				echo "sub-$id has missing fMRI data for SST."
			fi
		
			if [ ! -f sub-$id\_task-rest_bold.nii.gz ]; then
				echo "sub-$id has missing resting fMRI data."
			fi

			if [ ! -f sub-$id\_task-stopsignal_events.tsv ]; then
				echo "sub-$id has missing events.tsv file for SST."
			fi
		
			cd ..
		fi
		
		if [ ! -d anat ]; then
			echo "sub-$id has missing anat directory."
		else 
			cd anat

			if [ ! -f sub-$id\_T1w.nii.gz ]; then
				echo "sub-$id has missing anatomical scan data."
			fi
			
			cd ..
		fi
		
		if [ ! -d beh ]; then
			echo "sub-$id has missing beh directory."
		else
			cd beh
			
			if [ ! -f sub-$id\_task-stopsignaltraining_events.tsv ]; then
				echo "sub-$id has missing stop-signal behavioural data."
			fi
			
			cd ..
		fi
				

		echo "sub-$id checked."

		cd ..
	fi
done
