
rule call_variants:
    input:
        bam=get_sample_bams,
        ref=config["ref"]["index"],
        known=config["ref"]["known-variants"]
    output:
        gvcf="calls/{sample}.g.vcf.gz"
    log:
        "logs/gatk/haplotypecaller/{sample}.log"
    params:
        extra=config["params"]["gatk"]["HaplotypeCaller"]
    wrapper:
        "gatk4/bio/gatk/haplotypecaller"


rule combine_calls:
    input:
        ref=config["ref"]["index"],
        gvcfs=expand("calls/{sample}.g.vcf.gz", sample=samples.index)
    output:
        gvcf="calls/all.g.vcf.gz"
    log:
        "logs/gatk/combinegvcfs.log"
    wrapper:
        "gatk4/bio/gatk/combinegvcfs"


rule genotype_variants:
    input:
        ref=config["ref"]["index"],
        gvcf="calls/all.g.vcf.gz"
    output:
        vcf="calls/all.vcf.gz"
    params:
        extra=config["params"]["gatk"]["GenotypeGVCFs"]
    log:
        "logs/gatk/genotypegvcfs.log"
    wrapper:
        "gatk4/bio/gatk/genotypegvcfs"
