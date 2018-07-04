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


sns.pairplot(hue="sample", vars=["DP", "freq"], data=sample_info)

plt.savefig(snakemake.output[0])
