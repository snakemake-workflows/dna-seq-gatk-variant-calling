rule snpeff:
    input:
        calls="filtered/all.vcf.gz",
        db="resources/snpeff/{reference}".format(reference=get_snpeff_reference())
    output:
        calls=report("annotated/all.vcf.gz", caption="../report/vcf.rst", category="Calls"),
        csvstats="snpeff/all.csv"
    log:
        "logs/snpeff.log"
    params:
        extra="-Xmx6g"
    wrapper:
        "0.52.0/bio/snpeff/annotate"


rule annotate_variants:
    input:
        calls="filtered/all.vcf.gz",
        cache="resources/vep/cache",
        plugins="resources/vep/plugins"
    output:
        calls=report("annotated/all.vcf.gz", caption="../report/vcf.rst", category="Calls"),
        stats=report("stats/all.stats.html", caption="../report/stats.rst", category="Calls")
    params:
        # Pass a list of plugins to use, see https://www.ensembl.org/info/docs/tools/vep/script/vep_plugins.html
        # Plugin args can be added as well, e.g. via an entry "MyPlugin,1,FOO", see docs.
        plugins=config["params"]["vep"]["plugins"],
        extra=config["params"]["vep"]["extra"]
    log:
        "logs/vep/annotate.log"
    wrapper:
        "0.55.0/bio/vep/annotate"