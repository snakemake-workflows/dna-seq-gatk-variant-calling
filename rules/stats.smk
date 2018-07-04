rule vcf_to_tsv:
    input:
        "calls/all.final.vcf.gz"
    output:
        report("tables/calls.tsv.gz", caption="../report/calls.rst")
    conda:
        "../envs/rbt.yaml"
    shell:
        "rbt vcf-to-txt -g --fmt DP AD < {input} | gzip > {output}"


rule plot_depths:
    input:
        "tables/calls.tsv.gz"
    output:
        report("plots/depths.svg", caption="../report/depths.rst")
    conda:
        "../envs/stats.yaml"
    script:
        "../scripts/plot-depths.py"
