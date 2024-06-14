#!/bin/bash

echo -e "Subject ID\tNo. of Trials\tGo Trials\tCorrect Go\tIncorrect Go\tStop Trials\tSuccessful Stop\tUnsuccessful Stop" > /home/shreya/Downloads/ds000030-download/behavior_summary.tsv


for id in `cat subject_ids.txt`
do
	if [ -d "sub-$id" ]; then
		cd "sub-$id/func"

		sed '1d' "sub-${id}_task-stopsignal_events.tsv" > temp.tsv
		
		count_trials=$(grep -v "NULL" temp.tsv | wc -l)
		count_go=$(grep "GO" temp.tsv | wc -l)
		count_correct_go=$(grep "GO" temp.tsv | grep "CorrectResponse" | wc -l)
		count_incorrect_go=$(grep "GO" temp.tsv | grep "IncorrectResponse" | wc -l)
		count_stop=$(grep "STOP" temp.tsv | wc -l)
		successful_stops=$(grep "STOP" temp.tsv | grep "SuccessfulStop" | wc -l)
		unsuccessful_stops=$(grep "STOP" temp.tsv | grep -v "SuccessfulStop" | wc -l)

		echo -e "$id\t$count_trials\t$count_go\t$count_correct_go\t$count_incorrect_go\t$count_stop\t$successful_stops\t$unsuccessful_stops" >> /home/shreya/Downloads/ds000030-download/behavior_summary.tsv
		
		rm temp.tsv
		cd ../..
	fi
done


