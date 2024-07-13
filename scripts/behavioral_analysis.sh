#!/bin/bash

population="clinical"

rm -f successful_go_trials_${population}.txt successful_stop_trials_${population}.txt

for id in `cat ${population}_subject_ids.txt`
do
	subject="sub-${id}"
	if [ ! -d ${subject} ]
	then
		continue
	fi

	file=${subject}/func/${subject}_task-stopsignal_events.tsv \
	|| echo "Behavioural file not found for ${subject}."

	count_successful_go=$( grep "GO" $file | grep "CorrectResponse" \
			| wc -l )
	echo $count_successful_go >> successful_go_trials_${population}.txt

	count_successful_stop=$( grep "STOP" $file | grep "SuccessfulStop" \
				| wc -l )
	echo $count_successful_stop >> successful_stop_trials_${population}.txt
done

if [ -f behavior_summary_${population}.tsv ]
then
	rm -f go_trials_${population}.txt
	sed '1d' behavior_summary_${population}.tsv | cut -f 3 > go_trials_${population}.txt

	rm -f stop_trials_${population}.txt
	sed '1d' behavior_summary_${population}.tsv | cut -f 6 > stop_trials_${population}.txt
fi
