#!/bin/bash

rm -f combined_GO_RT_*.txt \
combined_failed_STOP_RT_*.txt \
combined_SSRT_*.txt \
go_trials_*.txt \
stop_trials_*.txt \
successful_go_trials_*.txt \
successful_stop_trials_*.txt

sed -i "s/clinical/ctrl/g" behavior_check.sh \
behavioral_analysis.sh \
compute_RT_analysis.sh

bash behavior_check.sh
bash behavioral_analysis.sh
bash compute_RT_analysis.sh

sed -i "s/ctrl/schz/g" behavior_check.sh \
behavioral_analysis.sh \
compute_RT_analysis.sh

bash behavior_check.sh
bash behavioral_analysis.sh
bash compute_RT_analysis.sh

sed -i "s/schz/bipolar/g" behavior_check.sh \
behavioral_analysis.sh \
compute_RT_analysis.sh

bash behavior_check.sh
bash behavioral_analysis.sh
bash compute_RT_analysis.sh

sed -i "s/bipolar/adhd/g" behavior_check.sh \
behavioral_analysis.sh \
compute_RT_analysis.sh

bash behavior_check.sh
bash behavioral_analysis.sh
bash compute_RT_analysis.sh

sed -i "s/adhd/all/g" behavior_check.sh \
behavioral_analysis.sh \
compute_RT_analysis.sh

bash behavior_check.sh
bash behavioral_analysis.sh
bash compute_RT_analysis.sh


sed -i "s/all/clinical/g" behavior_check.sh \
behavioral_analysis.sh \
compute_RT_analysis.sh

bash behavior_check.sh
bash behavioral_analysis.sh
bash compute_RT_analysis.sh
