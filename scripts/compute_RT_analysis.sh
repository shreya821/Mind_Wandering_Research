#!/bin/bash

population="clinical"
rm -f combined_GO_RT_${population}.txt combined_failed_STOP_RT_${population}.txt combined_SSRT_${population}.txt

for id in `cat ${population}_subject_ids.txt`
do
	subject="sub-${id}"
	if [ -d ${subject} ]
	then
		cd "${subject}/func"

		rm -f ${subject}_GO_RT.txt ${subject}_failed_STOP_RT.txt ${subject}_SSD.txt

		grep "GO" ${subject}_task-stopsignal_events.tsv \
		| grep "CorrectResponse" | cut -f 5 | sort \
		> ${subject}_GO_RT.txt

		grep "STOP" ${subject}_task-stopsignal_events.tsv \
		| grep "UnsuccessfulStop" | cut -f 5 \
		> ${subject}_failed_STOP_RT.txt

		grep "STOP" ${subject}_task-stopsignal_events.tsv \
		| cut -f 10 | grep -v '^0$' \
		> ${subject}_SSD.txt

		mean_GO_RT=$(Rscript -e "x <- scan('${subject}_GO_RT.txt', quiet=TRUE); m <- mean(x); cat(m,'\n')")
		mean_failed_STOP_RT=$(Rscript -e "x <- scan('${subject}_failed_STOP_RT.txt', quiet=TRUE); m <- mean(x); cat(m,'\n')")
		mean_SSD=$(Rscript -e "x <- scan('${subject}_SSD.txt', quiet=TRUE); m <- mean(x); cat(m,'\n')")

		# Analysis of SSRT for one subject
		stop_trials=$(grep "STOP" ${subject}_task-stopsignal_events.tsv | wc -l)
		responded_stop_trials=$(cat ${subject}_failed_STOP_RT.txt | wc -l)
		p_respond_stop=$(echo "scale=4; ${responded_stop_trials} / ${stop_trials}" | bc -l)
		num_correct_go=$(cat ${subject}_GO_RT.txt | wc -l)

		index_go=$(Rscript -e "id <- ceiling(${p_respond_stop} * ${num_correct_go}); cat(id, '\n')")
		integration_point=$(sed -n "${index_go}p" ${subject}_GO_RT.txt)
		SSRT=$(echo "scale=4; ${integration_point} - ${mean_SSD}" | bc -l)

		echo ${mean_GO_RT} >> ../../combined_GO_RT_${population}.txt
		echo ${mean_failed_STOP_RT} >> ../../combined_failed_STOP_RT_${population}.txt
		echo ${SSRT} >> ../../combined_SSRT_${population}.txt

		rm -f ${subject}_GO_RT.txt ${subject}_SSD.txt ${subject}_failed_STOP_RT.txt

		cd ../..
	fi
done

lines_GO=$(cat combined_GO_RT_${population}.txt | wc -l)
lines_STOP=$(cat combined_failed_STOP_RT_${population}.txt | wc -l)

if [ ${lines_GO} -eq ${lines_STOP} ]
then
	n=${lines_GO}

	mean_GO_RT=$(Rscript -e "x <- scan('combined_GO_RT_${population}.txt', quiet=TRUE); x <- x * 1000; m <- mean(x); cat(m, '\n')")
	sem_GO_RT=$(Rscript -e "x <- scan('combined_GO_RT_${population}.txt', quiet=TRUE); x <- x * 1000; sme <- sd(x) / sqrt($n) ; cat(sme, '\n')")

	mean_failed_STOP_RT=$(Rscript -e "x <- scan('combined_failed_STOP_RT_${population}.txt', quiet=TRUE); x <- x * 1000; m <- mean(x); cat(m, '\n')")
	sem_failed_STOP_RT=$(Rscript -e "x <- scan('combined_failed_STOP_RT_${population}.txt', quiet=TRUE); x <- x * 1000; sme <- sd(x) / sqrt($n) ; cat(sme, '\n')")

	mean_SSRT=$(Rscript -e "x <- scan('combined_SSRT_${population}.txt', quiet=TRUE); x <- x * 1000; m <- mean(x); cat(m, '\n')")
	sem_SSRT=$(Rscript -e "x <- scan('combined_SSRT_${population}.txt', quiet=TRUE); x <- x * 1000; sme <- sd(x) / sqrt($n) ; cat(sme, '\n')")

	echo "For ${population}:"
	Rscript -e "cat(sprintf('The mean of GO RTs is %.2f ms.\n', ${mean_GO_RT}))"
	Rscript -e "cat(sprintf('The SEM of GO RTs is %.2f ms.\n', ${sem_GO_RT}))"

	echo

	Rscript -e "cat(sprintf('The mean of failed STOP RTs is %.2f ms.\n', ${mean_failed_STOP_RT}))"
	Rscript -e "cat(sprintf('The SEM of failed STOP RTs is %.2f ms.\n', ${sem_failed_STOP_RT}))"

	echo

	Rscript -e "cat(sprintf('The mean of SSRTs is %.2f ms.\n', ${mean_SSRT}))"
	Rscript -e "cat(sprintf('The SEM of SSRTs is %.2f ms.\n', ${sem_SSRT}))"
	
	echo 
else
	echo "There is a discrepancy in the number of subjects while collecting different RTs."
	echo "Lines in GO RT file: ${lines_GO}, Lines in STOP RT file: ${lines_STOP}"
	echo
fi

