

wildcard_constraints:
    vartype="snvs|indels"


def get_vartype_arg(wildcards):
    return "--select-type-to-include {}".format(
        "SNP" if wildcards.vartype == "snvs" else "INDEL")


rule select_calls:
    input:
        "calls/all.vcf.gz"
    output:
        "calls/all.{vartype}.vcf.gz"
    params:
        extra=get_vartype_arg
    log:
        "logs/gatk/selectvariants/{vartype}.log"
    wrapper:
        "master/bio/gatk/selectvariants"


rule hard_filter_calls:
    input:
        "calls/all.{vartype}.vcf.gz"
    output:
        "calls/all.{vartype}.filtered.vcf.gz"
    params:
        filters=lambda w: config["hard-filtering"][w.vartype]
    log:
        "logs/gatk/variantfiltration/{vartype}.log"
    wrapper:
        "master/bio/gatk/variantfiltration"


rule recalibrate_calls:
    input:
        "calls/all.{vartype}.vcf.gz"
    output:
        "calls/all.{vartype}.recalibrated.vcf.gz"
    log:
        "logs/gatk/variantrecalibrator/{vartype}.log"
    wrapper:
        "master/bio/gatk/variantrecalibrator"
