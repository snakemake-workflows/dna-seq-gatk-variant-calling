rule fastqc:
    input:
        unpack(get_fastq)
    output:
        html="qc/fastqc/{sample}-{unit}.html",
        zip="qc/fastqc/{sample}-{unit}.zip"
    wrapper:
        "0.27.1/bio/fastqc"


rule samtools_stats:
    input:
        "recal/{sample}-{unit}.bam"
    output:
        "qc/samtools-stats/{sample}-{unit}.txt"
    log:
        "logs/samtools-stats/{sample}-{unit}.log"
    wrapper:
        "0.27.1/bio/samtools/stats"


rule multiqc:
    input:
        expand(["qc/samtools-stats/{u.sample}-{u.unit}.txt",
                "qc/fastqc/{u.sample}-{u.unit}.zip",
                "qc/dedup/{u.sample}-{u.unit}.metrics.txt"],
               u=units.itertuples()),
        "snpeff/all.csv"
    output:
        report("qc/multiqc.html", caption="../report/multiqc.rst", category="Quality control")
    log:
        "logs/multiqc.log"
    wrapper:
        "0.27.1/bio/multiqc"
