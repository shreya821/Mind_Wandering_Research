import pandas
import numpy as np
import os 

fmri_data = pandas.read_csv('fmri_data.tsv', sep = '\t').dropna(axis = 1)

home_dir = os.getcwd()
dmn_tab = {}

with open('ctrl_subject_ids.txt','r') as file:
    lines = file.readlines()

if(os.path.isfile('high_dmn_go_rt.txt')):
    os.remove('high_dmn_go_rt.txt')

if(os.path.isfile('low_dmn_go_rt.txt')):
    os.remove('low_dmn_go_rt.txt')

high_go_rt = open("high_dmn_go_rt.txt",'a')
low_go_rt = open("low_dmn_go_rt.txt", 'a')

for id in lines:
    sub_index = id.strip()
    dir_name = 'sub-' + sub_index
    if(os.path.exists(dir_name)):
        dmn_tab[sub_index] = []

subj_nos = len(fmri_data)

for j in range(22): # We are considering the first 22 windows only.
    for i in range(subj_nos):
        df = fmri_data[fmri_data.columns[j*8+1:(j+1)*8+1]]
        value = df.mean(axis = 1).loc[i]
        median = fmri_data.median(axis = 1).loc[i]
        sub_id = int(fmri_data.loc[i].at["Subject ID"])
        key = sub_id.__str__()
        if(value > median):
            dmn_tab[key].append(True)
        else:
            dmn_tab[key].append(False)

for id in lines:
    sub_index = id.strip()
    dir_name = 'sub-' + sub_index
    
    if(os.path.exists(dir_name)):
        beh_file = os.getcwd() + f'/{dir_name}/func'
        os.chdir(beh_file)

        beh_data = pandas.read_csv(f'{dir_name}_task-stopsignal_events.tsv', sep = '\t')
        beh_file_length = len(beh_data)
        
        loc_to_partition = []
        i = 0
        for window in range(22): # We are considering the first 22 windows only.
            go_rts = []
            while(i < beh_file_length and beh_data.loc[i].at["TimeCourse"] < 16*(window + 1)):
                if(beh_data.loc[i].at["TrialOutcome"] == "SuccessfulGo"):
                    go_rts.append(beh_data.loc[i].at["ReactionTime"])
                i += 1

            if(len(go_rts) != 0):
                mean_go_rt = np.mean(go_rts) * 1000
                
                os.chdir(home_dir)
                if(dmn_tab[sub_index][window]):
                    high_go_rt.write('%f' %mean_go_rt)
                    high_go_rt.write('\n')
                else:
                    low_go_rt.write('%f' %mean_go_rt)
                    low_go_rt.write('\n')
                os.chdir(beh_file)
            else:
                continue
        
        os.chdir(home_dir)

low_go_rt.close()
high_go_rt.close()
file.close()
