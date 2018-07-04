include: "rules/common.smk"

##### Target rules #####

rule all:
    input:
        "calls/all.final.vcf.gz"


##### Modules #####

include: "rules/mapping.smk"
include: "rules/calling.smk"
include: "rules/filtering.smk"
