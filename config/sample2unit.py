import pandas as pd
samples=pd.read_table('samples.tsv')
print("sample	unit	platform	fq1	fq2")
for i in range(len(samples)):
    s = samples.iloc[i, 0]
    print("\t".join([s,
                    '1',
                    'ILLUMINA',
                    'data/reads/{}.R1.fastq.gz'.format(s),
                    'data/reads/{}.R2.fastq.gz'.format(s)]))
