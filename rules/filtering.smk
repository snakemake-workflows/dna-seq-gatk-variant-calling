def get_vartype_arg(wildcards):
    return "--select-type-to-include {}".format(
        "SNP" if wildcards.vartype == "snvs" else "INDEL")


rule select_calls:
    input:
        ref=config["ref"]["genome"],
        vcf="calls/all.vcf.gz"
    output:
        vcf=temp("calls/all.{vartype}.vcf.gz")
    params:
        extra=get_vartype_arg
    log:
        "logs/gatk/selectvariants/{vartype}.log"
    wrapper:
        "gatk4/bio/gatk/selectvariants"


def get_filter(wildcards):
    return {
        "snv-hard-filter":
        config["filtering"]["hard"][wildcards.vartype]}


rule hard_filter_calls:
    input:
        ref=config["ref"]["genome"],
        vcf="calls/all.{vartype}.vcf.gz"
    output:
        vcf=temp("calls/all.{vartype}.filtered.vcf.gz")
    params:
        filters=get_filter
    log:
        "logs/gatk/variantfiltration/{vartype}.log"
    wrapper:
        "gatk4/bio/gatk/variantfiltration"


rule recalibrate_calls:
    input:
        vcf="calls/all.{vartype}.vcf.gz"
    output:
        vcf=temp("calls/all.{vartype}.recalibrated.vcf.gz")
    params:
        extra=config["params"]["gatk"]["VariantRecalibrator"]
    log:
        "logs/gatk/variantrecalibrator/{vartype}.log"
    wrapper:
        "gatk4/bio/gatk/variantrecalibrator"


rule merge_calls:
    input:
        vcf=expand("calls/all.{vartype}.{filtertype}.vcf.gz",
                   vartype=["snvs", "indels"],
                   filtertype="recalibrated"
                              if config["filtering"]["vqsr"]
                              else "filtered")
    output:
        vcf="calls/all.final.vcf.gz"
    log:
        "logs/picard/mergevcfs.log"
    wrapper:
        "gatk4/bio/picard/mergevcfs"
