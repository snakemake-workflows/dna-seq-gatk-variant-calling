def get_vartype_arg(wildcards):
    return "--select-type-to-include {}".format(
        "SNP" if wildcards.vartype == "snvs" else "INDEL")


rule select_calls:
    input:
        ref=config["ref"]["index"],
        vcf="calls/all.vcf.gz"
    output:
        vcf="calls/all.{vartype}.vcf.gz"
    params:
        extra=get_vartype_arg
    log:
        "logs/gatk/selectvariants/{vartype}.log"
    wrapper:
        "gatk4/bio/gatk/selectvariants"


rule hard_filter_calls:
    input:
        ref=config["ref"]["index"],
        vcf="calls/all.{vartype}.vcf.gz"
    output:
        vcf="calls/all.{vartype}.filtered.vcf.gz"
    params:
        filters=lambda w: config["filtering"]["hard"][w.vartype]
    log:
        "logs/gatk/variantfiltration/{vartype}.log"
    wrapper:
        "gatk4/bio/gatk/variantfiltration"


rule recalibrate_calls:
    input:
        vcf="calls/all.{vartype}.vcf.gz"
    output:
        vcf="calls/all.{vartype}.recalibrated.vcf.gz"
    params:
        extra=config["params"]["gatk"]["VariantRecalibrator"]
    log:
        "logs/gatk/variantrecalibrator/{vartype}.log"
    wrapper:
        "gatk4/bio/gatk/variantrecalibrator"
