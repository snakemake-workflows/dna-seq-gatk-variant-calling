import pandas as pd
from snakemake.utils import validate

###### Config file and sample sheets #####
configfile: "config.yaml"
validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
validate(samples, schema="schemas/samples.schema.yaml")

units = pd.read_table(config["units"], dtype=str).set_index(["sample", "unit"], drop=False)
units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])  # enforce str in index
validate(units, schema="schemas/units.schema.yaml")

# contigs in reference genome
contigs = pd.read_table(config["ref"]["genome"] + ".fai",
                        header=None, usecols=[0], squeeze=True, dtype=str)

##### Global variables #####
target_vcf = expand("calls/all.{vartype}.recalibrated.vcf.gz"
                    if config["filtering"]["vqsr"] else
                    "calls/all.{vartype}.filtered.vcf.gz",
                    vartype=["snvs", "indels"])


##### Wildcard constraints #####
wildcard_constraints:
    vartype="snvs|indels",
    sample="|".join(samples.index),
    unit="|".join(units["unit"]),
    contig="|".join(contigs)

##### Target rules #####
rule all:
    input:
        target_vcf


##### Modules #####

include: "rules/common.smk"
include: "rules/mapping.smk"
include: "rules/calling.smk"
include: "rules/filtering.smk"
