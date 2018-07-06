import common
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

calls = pd.read_table(snakemake.input[0], header=[0, 1])
samples = [name for name in calls.columns.levels[0] if name != "VARIANT"]
sample_info = calls.loc[:, samples].stack([0, 1]).unstack().reset_index(1, drop=False)
sample_info = sample_info.rename({"level_1": "sample"}, axis=1)

sample_info = sample_info[sample_info["DP"] > 0]
sample_info["freq"] = sample_info["AD"] / sample_info["DP"]

plt.figure()

sns.stripplot(x="sample", y="freq", data=sample_info, jitter=True)
plt.ylabel("allele frequency")

plt.savefig(snakemake.output.freqs)

plt.figure()

sns.stripplot(x="sample", y="DP", data=sample_info, jitter=True)
plt.ylabel("read depth")

plt.savefig(snakemake.output.depths)
