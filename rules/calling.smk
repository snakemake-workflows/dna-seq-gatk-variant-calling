
rule call_variants:
    input:
        bam=get_sample_bams,
        ref=config["ref"]["genome"],
        known=config["ref"]["known-variants"]
    output:
        gvcf=protected("calls/{sample}.{contig}.g.vcf.gz")
    log:
        "logs/gatk/haplotypecaller/{sample}.{contig}.log"
    params:
        extra=config["params"]["gatk"]["HaplotypeCaller"]
    wrapper:
        "0.27.0/bio/gatk/haplotypecaller"


rule combine_calls:
    input:
        ref=config["ref"]["genome"],
        gvcfs=expand("calls/{sample}.{{contig}}.g.vcf.gz", sample=samples.index)
    output:
        gvcf="calls/all.{contig}.g.vcf.gz"
    log:
        "logs/gatk/combinegvcfs.{contig}.log"
    wrapper:
        "0.27.0/bio/gatk/combinegvcfs"


rule genotype_variants:
    input:
        ref=config["ref"]["genome"],
        gvcf="calls/all.{contig}.g.vcf.gz"
    output:
        vcf=temp("calls/all.{contig}.vcf.gz")
    params:
        extra=config["params"]["gatk"]["GenotypeGVCFs"]
    log:
        "logs/gatk/genotypegvcfs.{contig}.log"
    wrapper:
        "0.27.0/bio/gatk/genotypegvcfs"


rule merge_variants:
    input:
        vcf=expand("calls/all.{contig}.vcf.gz", contig=contigs)
    output:
        vcf="calls/all.vcf.gz"
    log:
        "logs/picard/mergevcfs.log"
    wrapper:
        "0.27.0/bio/picard/mergevcfs"
