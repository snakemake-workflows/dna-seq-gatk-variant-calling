# The main entry point of your workflow.
# After configuring, running snakemake -n in a clone of this repository should successfully execute a dry-run of the workflow.


configfile: "config.yaml"


target_vcf = "calls/all.recalibrated.vcf.gz" if config["filtering"]["vqsr"] else "calls/all.filtered.vcf.gz"


rule all:
    input:
        target_vcf


include: "rules/mapping.smk"
include: "rules/calling.smk"
include: "rules/filtering.smk"
