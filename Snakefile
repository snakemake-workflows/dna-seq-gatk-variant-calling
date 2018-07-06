include: "rules/common.smk"

##### Target rules #####

rule all:
    input:
        "calls/all.annotated.vcf.gz",
        "qc/multiqc.html"


##### Modules #####

include: "rules/mapping.smk"
include: "rules/calling.smk"
include: "rules/filtering.smk"
include: "rules/stats.smk"
include: "rules/qc.smk"
include: "rules/annotation.smk"
