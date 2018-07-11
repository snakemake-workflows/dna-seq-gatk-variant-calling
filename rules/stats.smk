rule vcf_to_tsv:
    input:
        "annotated/all.vcf.gz"
    output:
        report("tables/calls.tsv.gz", caption="../report/calls.rst")
    conda:
        "../envs/rbt.yaml"
    shell:
        "bcftools view --apply-filters PASS --output-type u {input} | "
        "rbt vcf-to-txt -g --fmt DP AD --info ANN | "
        "gzip > {output}"


rule plot_stats:
    input:
        "tables/calls.tsv.gz"
    output:
        depths=report("plots/depths.svg", caption="../report/depths.rst"),
        freqs=report("plots/allele-freqs.svg", caption="../report/freqs.rst")
    conda:
        "../envs/stats.yaml"
    script:
        "../scripts/plot-depths.py"
