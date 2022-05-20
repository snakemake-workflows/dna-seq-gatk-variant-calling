# use this on results/annotated/all.vcf.txt
# grep -v '##' all.vcf > all.vcf.txt 

import pandas as pd
import sys

def contains(string, genes):
	return any([x.upper() == string.upper() for x in genes])

fname='all.vcf.txt'
oname1='all.xlsx'
oname2='all.flt.xlsx'


# read and parse
df = pd.read_table(fname)
print(df.head())

infos = df.loc[:, 'INFO']
gene_names = [x.split('|')[3] for x in infos]
variant_classifications = [x.split('|')[1] for x in infos]
significances = [x.split('|')[2] for x in infos]

df.insert(2, 'Gene_Names', gene_names)
df.insert(3, 'Variant_Classifications', variant_classifications)
df.insert(4, 'Significance', significances)
df.to_excel(oname1, index=False)


# filter
genes = pd.read_table("genes.txt", header=None)  
genes = genes.iloc[:, 0].tolist() # 28
genes = list(set(genes))  # uniq 12
idx = [contains(a, genes) for a in gene_names]
out = df.iloc[idx, :]
out.to_excel(oname2, index=False)
