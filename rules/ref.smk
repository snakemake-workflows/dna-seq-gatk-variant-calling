rule get_genome:
    output:
        "resources/genome.fasta"
    log:
        "logs/get-genome.log"
    params:
        species=config["ref"]["species"],
        datatype="dna",
        build=config["ref"]["build"],
        release=config["ref"]["release"]
    cache: True
    wrapper:
        "0.50.4/bio/reference/ensembl-sequence"


rule genome_faidx:
    input:
        "resources/genome.fasta"
    output:
        "resources/genome.fasta.fai"
    log:
        "logs/genome-faidx.log"
    cache: True
    wrapper:
        "0.50.4/bio/samtools/faidx"


rule genome_dict:
    input:
        "resources/genome.fasta"
    output:
        "resources/genome.dict"
    log:
        "logs/samtools/create_dict.log"
    conda:
        "../envs/samtools.yaml"
    cache: True
    shell:
        "samtools dict {input} > {output} 2> {log} "


rule get_known_variation:
    input:
        # use fai to annotate contig lengths for GATK BQSR
        fai="resources/genome.fasta.fai"
    output:
        vcf="resources/variation.vcf.gz"
    log:
        "logs/get-known-variants.log"
    params:
        species=config["ref"]["species"],
        release=config["ref"]["release"],
        type="all"
    cache: True
    wrapper:
        "0.51.1/bio/reference/ensembl-variation"


rule remove_iupac_codes:
    input:
        "resources/variation.vcf.gz"
    output:
        "resources/variation.noiupac.vcf.gz"
    log:
        "logs/fix-iupac-alleles.log"
    conda:
        "../envs/rbt.yaml"
    cache: True
    shell:
        "rbt vcf-fix-iupac-alleles < {input} | bcftools view -Oz > {output}"


rule bwa_index:
    input:
        "resources/genome.fasta"
    output:
        multiext("resources/genome.fasta", ".amb", ".ann", ".bwt", ".pac", ".sa")
    log:
        "logs/bwa_index.log"
    resources:
        mem_mb=369000
    cache: True
    wrapper:
        "0.50.4/bio/bwa/index"


rule download_snpeff_db:
    output:
        # wildcard {reference} may be anything listed in `snpeff databases`
        directory("resources/snpeff/{reference}")
    log:
        "logs/snpeff/download/{reference}.log"
    params:
        reference="{reference}"
    cache: True
    wrapper:
        "0.52.0/bio/snpeff/download"
