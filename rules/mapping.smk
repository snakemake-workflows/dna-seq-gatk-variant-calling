

def get_fastq(wildcards):
    fqs = units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]]
    assert not fqs.isnull().any()
    return fqs


rule trim_reads:
    input:
        get_fastq
    output:
        fastq1="trimmed/{sample}-{unit}.1.fastq.gz",
        fastq2="trimmed/{sample}-{unit}.2.fastq.gz",
        qc="trimmed/{sample}-{unit}.qc.txt"
    params:
        "-a {} {}".format(config["adapter"], config["params"]["cutadapt-pe"])
    log:
        "logs/cutadapt/{sample}-{unit}.log"
    wrapper:
        "0.17.4/bio/cutadapt/pe"


rule map_reads:
    input:
        reads=["trimmed/{sample}-{unit}.1.fastq",
               "trimmed/{sample}-{unit}.2.fastq"]
    output:
        temp("mapped/{sample}-{unit}.sorted.bam")
    log:
        "logs/bwa_mem/{sample}-{unit}.log"
    params:
        index=config["ref"]["index"],
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sort="samtools",
        sort_order="coordinate"
    threads: 8
    wrapper:
        "0.26.1/bio/bwa/mem"


rule mark_duplicates:
    input:
        "mapped/{sample}-{unit}.bam"
    output:
        bam="dedup/{sample}-{unit}.bam",
        metrics="dedup/{sample}-{unit}.metrics.txt"
    log:
        "logs/picard/dedup/{sample}-{unit}.log"
    params:
        "REMOVE_DUPLICATES=true"
    wrapper:
        "0.26.1/bio/picard/markduplicates"


rule recalibrate_base_qualities:
    input:
        bam="dedup/{sample}-{unit}.bam",
        ref=config["ref"]["index"],
        known=config["ref"]["known"]
    output:
        bam="recal/{sample}-{unit}.bam"
    params:
        extra=config["params"]["gatk"]["BaseRecalibrator"]
    log:
        "logs/gatk/bqsr/{sample}-{unit}.log"
    wrapper:
        "master/bio/gatk/baserecalibrator"
