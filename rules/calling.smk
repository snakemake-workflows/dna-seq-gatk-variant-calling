def get_sample_bams(wildcards):
    return expand("recal/{sample}-{unit}.bam",
                  sample=wildcards.sample,
                  unit=units.loc[wildcards.sample].unit)


rule call_variants:
    input:
        bam=get_sample_bams
        ref=config["ref"]["index"],
        known=config["ref"]["known"]
    output:
        gvcf="calls/{sample}.g.vcf.gz"
    log:
        "logs/gatk/haplotypecaller/{sample}.log"
    params:
        extra=config["params"]["gatk"]["HaplotypeCaller"]
    wrapper:
        "master/bio/gatk/haplotypecaller"


rule combine_calls:
    input:
        expand("calls/{sample}.g.vcf.gz", sample=samples.index)
    output:
        "calls/all.g.vcf.gz"
    log:
        "logs/gatk/combinegvcfs.log"
    wrapper:
        "master/bio/gatk/combinegvcfs"


rule genotype_variants:
    input:
        "calls/all.g.vcf.gz"
    output:
        "calls/all.vcf.gz"
    log:
        "logs/gatk/genotypegvcfs.log"
    wrapper:
        "master/bio/gatk/genotypegvcfs"
