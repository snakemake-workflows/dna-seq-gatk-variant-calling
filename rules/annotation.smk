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
        "0.52.0/bio/snpeff"
