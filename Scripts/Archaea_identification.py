#!/usr/bin/python3
# -*- coding: utf-8 -*-

import pandas as pd
import getopt,sys,re

def usage():
    print("Usage: python3 Archaea_seq_ext.py -i <input_scaffold_fasta> -f <raw_seq_file> -c <Arc_bac_count
> -s <screened_table> -o <output_contig_fasta>")

try:
    options, remainder=getopt.getopt(sys.argv[1:], 'i:f:l:c:s:o:h')

except getopt.GetoptError as err:
    print(str(err))
    usage()
    sys.exit()

for opt, arg in options:
    if opt in ('-i'):
        input_file = arg
    if opt in ('-f'):
        raw_seq_file = arg
    if opt in ('-c'):
        Arc_bac_count = arg
    if opt in ('-s'):
        screened_table = arg
    if opt in ('-h'):
        usage()
        sys.exit()
    elif opt in ('-o'):
        output_file = arg

df = pd.read_csv(input_file,sep = '\t|;',header = None,engine = 'python')
contig_ID=df[0].str.split('_',expand = True)[0]
df.insert(0,'contig_ID',contig_ID)
df1 = df.set_index('contig_ID')
df_ext = df.iloc[:,[0,3]]
df_ext.columns = ['contig_ID', 'kingdom']
df_sta = df_ext.groupby(['contig_ID'])['kingdom'].value_counts().unstack()
df_sta = df_sta.fillna(0)
df_sta.to_csv(Arc_bac_count,sep = '\t')

try:
    contig_ext_ID_1 = df_sta.loc[lambda x: x['d__Archaea'] > x['d__Bacteria']].index.tolist()
    contig_ext_ID_2 = df_sta.loc[lambda x:x['d__Archaea'] >= 5].index.tolist()
    contig_ext_ID = list(set(contig_ext_ID_1).intersection(set(contig_ext_ID_2)))
except:
    contig_ext_ID = df_sta.loc[lambda x:x['d__Archaea'] >= 5].index.tolist()
df2 = df1.loc[contig_ext_ID,:]
df2 = df2.reset_index()
df2.drop(df.columns[2], axis = 1, inplace = True)
df2.to_csv(screened_table,sep = '\t',index = False,header = False)

seq = {}
for line in open(raw_seq_file,'r'):
    if line.startswith('>'):   
        #print(line)
        name = line.split('>')[1].strip()    
        seq[name] = ''
    else:
        seq[name]+=line.replace('\n', '')

length = 60
with open(output_file,'w+') as f:
    for lin in contig_ext_ID:
        #print(lin)
        f.write(">" + lin + '\n')
        value = seq[lin]
        while len(value) > length:
            f.write(value[0:length]+'\n')
            value = value[length:len(value)]
        f.write(value+'\n')
